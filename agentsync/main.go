// agentsync assembles GitHub Copilot and OpenCode agent files from a
// shared source layout.
//
// Each agent lives in its own subdirectory under ai/agents/:
//
//	ai/agents/<name>/
//	    body.md       — the agent instructions (no frontmatter)
//	    copilot.md    — GitHub Copilot frontmatter only (optional)
//	    opencode.md   — OpenCode frontmatter only (optional)
//
// The script concatenates the appropriate frontmatter file with body.md
// and writes the result to the platform-specific output directory:
//
//	Copilot  → ai/dist/copilot/<name>.agent.md
//	OpenCode → ai/dist/opencode/<name>.md
//
// At least one of copilot.md or opencode.md must exist per agent.
// body.md is always required. A warning is printed for any missing
// optional file; the corresponding output is simply skipped.
//
// Usage:
//
//	go run . [flags]
//
// Flags:
//
//	--dry-run             print what would be written without writing anything
//	--source <dir>        source agents directory (default: ai/agents relative to repo root)
//	--out-copilot <dir>   output directory for Copilot files (default: ai/dist/copilot relative to repo root)
//	--out-opencode <dir>  output directory for OpenCode files (default: ai/dist/opencode relative to repo root)
//	--skills              also create symlinks for skills into ~/.config/opencode/skills/
//	--agents              also symlink generated files into ~/.copilot/agents/ and ~/.config/opencode/agents/
//	--rules               also symlink ai/global-rules.md → ~/work/AGENTS.md
package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	dryRun := flag.Bool("dry-run", false, "Print what would be written without writing any files")
	sourceDir := flag.String("source", "", "Source agents directory (default: ai/agents relative to repo root)")
	outCopilot := flag.String("out-copilot", "", "Output directory for Copilot files (default: ai/dist/copilot relative to repo root)")
	outOpencode := flag.String("out-opencode", "", "Output directory for OpenCode files (default: ai/dist/opencode relative to repo root)")
	syncSkills := flag.Bool("skills", false, "Also create symlinks for skills into ~/.config/opencode/skills/")
	syncAgents := flag.Bool("agents", false, "Also symlink generated agent files into ~/.copilot/agents/ and ~/.config/opencode/agents/")
	syncRules := flag.Bool("rules", false, "Also symlink ai/AGENTS.md → ~/.config/opencode/AGENTS.md and ~/.claude/CLAUDE.md")
	flag.Parse()

	repoRoot, err := findRepoRoot()
	if err != nil {
		fatalf("could not find repo root: %v\n", err)
	}

	src := *sourceDir
	if src == "" {
		src = filepath.Join(repoRoot, "ai", "agents")
	}

	copilotOut := *outCopilot
	if copilotOut == "" {
		copilotOut = filepath.Join(repoRoot, "ai", "dist", "copilot")
	}

	opencodeOut := *outOpencode
	if opencodeOut == "" {
		opencodeOut = filepath.Join(repoRoot, "ai", "dist", "opencode")
	}

	entries, err := os.ReadDir(src)
	if err != nil {
		fatalf("could not read source directory %q: %v\n", src, err)
	}

	if !*dryRun {
		for _, dir := range []string{copilotOut, opencodeOut} {
			if err := os.MkdirAll(dir, 0o755); err != nil {
				fatalf("could not create output directory %q: %v\n", dir, err)
			}
		}
	}

	var processed, written, skipped int

	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}

		agentDir := filepath.Join(src, entry.Name())
		result, err := processAgent(agentDir, entry.Name(), copilotOut, opencodeOut, *dryRun)
		processed++
		written += result.written
		if err != nil {
			warnf("%s: %v\n", entry.Name(), err)
			skipped++
		}
	}

	fmt.Printf("\ndone: %d agents processed, %d files written, %d agents skipped\n", processed, written, skipped)

	if *syncSkills {
		syncSkillsDir(repoRoot, *dryRun)
	}

	if *syncAgents {
		home, err := os.UserHomeDir()
		if err != nil {
			warnf("agents sync: could not determine home directory: %v\n", err)
		} else {
			symlinkDir(copilotOut, filepath.Join(home, ".copilot", "agents"), *dryRun)
			symlinkDir(opencodeOut, filepath.Join(home, ".config", "opencode", "agents"), *dryRun)
		}
	}

	if *syncRules {
		syncRulesFile(repoRoot, *dryRun)
	}
}

type processResult struct {
	written int
}

// processAgent handles a single agent directory. It reads body.md plus
// whichever of copilot.md / opencode.md exist, and writes the assembled
// output files. Returns an error only for fatal problems (e.g. missing body,
// both frontmatter files absent). Missing individual frontmatter files
// produce warnings but are not fatal.
func processAgent(agentDir, name, copilotOut, opencodeOut string, dryRun bool) (processResult, error) {
	var result processResult

	// body.md is always required.
	bodyPath := filepath.Join(agentDir, "body.md")
	body, err := os.ReadFile(bodyPath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return result, fmt.Errorf("body.md is missing")
		}
		return result, fmt.Errorf("could not read body.md: %w", err)
	}

	copilotFM, copilotErr := readFile(filepath.Join(agentDir, "copilot.md"))
	opencodeFM, opencodeErr := readFile(filepath.Join(agentDir, "opencode.md"))

	// Both missing is a hard error — nothing to do.
	if errors.Is(copilotErr, os.ErrNotExist) && errors.Is(opencodeErr, os.ErrNotExist) {
		return result, fmt.Errorf("both copilot.md and opencode.md are missing")
	}

	// Warn about individual missing or unreadable files.
	if errors.Is(copilotErr, os.ErrNotExist) {
		warnf("%s: copilot.md not found, skipping Copilot output\n", name)
	} else if copilotErr != nil {
		warnf("%s: could not read copilot.md: %v — skipping Copilot output\n", name, copilotErr)
	}

	if errors.Is(opencodeErr, os.ErrNotExist) {
		warnf("%s: opencode.md not found, skipping OpenCode output\n", name)
	} else if opencodeErr != nil {
		warnf("%s: could not read opencode.md: %v — skipping OpenCode output\n", name, opencodeErr)
	}

	bodyStr := strings.TrimRight(string(body), "\n") + "\n"

	// Write Copilot output.
	if copilotErr == nil {
		outPath := filepath.Join(copilotOut, name+".agent.md")
		assembled := assembleMD(copilotFM, bodyStr)
		if err := writeFile(outPath, assembled, dryRun); err != nil {
			warnf("%s: could not write Copilot output: %v\n", name, err)
		} else {
			result.written++
		}
	}

	// Write OpenCode output.
	if opencodeErr == nil {
		outPath := filepath.Join(opencodeOut, name+".md")
		assembled := assembleMD(opencodeFM, bodyStr)
		if err := writeFile(outPath, assembled, dryRun); err != nil {
			warnf("%s: could not write OpenCode output: %v\n", name, err)
		} else {
			result.written++
		}
	}

	return result, nil
}

// readFile reads a file and returns its contents trimmed of trailing newlines.
// Returns os.ErrNotExist (unwrapped) if the file does not exist.
func readFile(path string) (string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return strings.TrimRight(string(data), "\n"), nil
}

// assembleMD concatenates a frontmatter block and a body into a single
// agent markdown file. A single newline separates them so the body starts
// on the line immediately after the closing ---.
func assembleMD(frontmatter, body string) string {
	return frontmatter + "\n\n" + body
}

// writeFile writes content to path, or prints a dry-run preview.
func writeFile(path, content string, dryRun bool) error {
	if dryRun {
		fmt.Printf("[dry-run] would write: %s\n", path)
		fmt.Println(strings.Repeat("-", 60))
		fmt.Print(content)
		fmt.Println(strings.Repeat("-", 60))
		return nil
	}
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		return err
	}
	fmt.Printf("wrote: %s\n", path)
	return nil
}

// symlinkDir creates a symlink at dst pointing to src. If the symlink already
// exists (pointing anywhere), it is left untouched. Non-symlink entries at dst
// are warned about and skipped.
func symlinkDir(src, dst string, dryRun bool) {
	if dryRun {
		if _, err := os.Lstat(dst); err == nil {
			fmt.Printf("[dry-run] symlink already exists, skipping: %s\n", dst)
		} else {
			fmt.Printf("[dry-run] would symlink: %s -> %s\n", dst, src)
		}
		return
	}

	info, err := os.Lstat(dst)
	if err == nil {
		if info.Mode()&os.ModeSymlink != 0 {
			// Already a symlink — leave it alone.
			return
		}
		warnf("agents sync: %q exists and is not a symlink, skipping\n", dst)
		return
	}

	// Ensure the parent directory exists.
	if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
		warnf("agents sync: could not create parent of %q: %v\n", dst, err)
		return
	}

	if err := os.Symlink(src, dst); err != nil {
		warnf("agents sync: could not create symlink %q -> %q: %v\n", dst, src, err)
		return
	}
	fmt.Printf("symlinked: %s -> %s\n", dst, src)
}

// syncSkillsDir creates symlinks in ~/.config/opencode/skills/ pointing to
// each skill directory under ai/skills/.
func syncSkillsDir(repoRoot string, dryRun bool) {
	skillsSrc := filepath.Join(repoRoot, "ai", "skills")
	home, err := os.UserHomeDir()
	if err != nil {
		warnf("skills sync: could not determine home directory: %v\n", err)
		return
	}
	skillsDst := filepath.Join(home, ".config", "opencode", "skills")

	entries, err := os.ReadDir(skillsSrc)
	if err != nil {
		warnf("skills sync: could not read %q: %v\n", skillsSrc, err)
		return
	}

	if !dryRun {
		if err := os.MkdirAll(skillsDst, 0o755); err != nil {
			warnf("skills sync: could not create %q: %v\n", skillsDst, err)
			return
		}
	}

	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		src := filepath.Join(skillsSrc, entry.Name())
		dst := filepath.Join(skillsDst, entry.Name())

		if dryRun {
			fmt.Printf("[dry-run] would symlink: %s -> %s\n", dst, src)
			continue
		}

		// Remove existing symlink or directory at destination.
		if _, err := os.Lstat(dst); err == nil {
			if err := os.Remove(dst); err != nil {
				warnf("skills sync: could not remove existing %q: %v\n", dst, err)
				continue
			}
		}

		if err := os.Symlink(src, dst); err != nil {
			warnf("skills sync: could not create symlink %q -> %q: %v\n", dst, src, err)
			continue
		}
		fmt.Printf("symlinked: %s -> %s\n", dst, src)
	}
}

// syncRulesFile symlinks ai/global-rules.md into ~/work/AGENTS.md so that
// OpenCode and GitHub Copilot pick it up as workspace-level rules for all
// repos under ~/work/.
func syncRulesFile(repoRoot string, dryRun bool) {
	src := filepath.Join(repoRoot, "ai", "global-rules.md")

	home, err := os.UserHomeDir()
	if err != nil {
		warnf("rules sync: could not determine home directory: %v\n", err)
		return
	}

	dst := filepath.Join(home, "work", "AGENTS.md")

	if dryRun {
		fmt.Printf("[dry-run] would symlink: %s -> %s\n", dst, src)
		return
	}

	if _, err := os.Lstat(dst); err == nil {
		if err := os.Remove(dst); err != nil {
			warnf("rules sync: could not remove existing %q: %v\n", dst, err)
			return
		}
	}

	if err := os.Symlink(src, dst); err != nil {
		warnf("rules sync: could not create symlink %q -> %q: %v\n", dst, src, err)
		return
	}
	fmt.Printf("symlinked: %s -> %s\n", dst, src)
}

// findRepoRoot walks up from the current working directory until it finds a
// directory containing a .git entry.
func findRepoRoot() (string, error) {
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, ".git")); err == nil {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", fmt.Errorf("no .git directory found")
		}
		dir = parent
	}
}

func fatalf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "agentsync: "+format, args...)
	os.Exit(1)
}

func warnf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "agentsync: warning: "+format, args...)
}
