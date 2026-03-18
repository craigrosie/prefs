// agentsync assembles GitHub Copilot, OpenCode, and Claude agent and command
// files from a shared source layout.
//
// Each agent lives in its own subdirectory under ai/agents/:
//
//	ai/agents/<name>/
//	    body.md       — the agent instructions (no frontmatter)
//	    copilot.md    — GitHub Copilot frontmatter only (optional)
//	    opencode.md   — OpenCode frontmatter only (optional)
//	    claude.md     — Claude Code frontmatter only (optional)
//
// Commands follow the same layout under ai/commands/:
//
//	ai/commands/<name>/
//	    body.md       — the command instructions (no frontmatter)
//	    copilot.md    — GitHub Copilot frontmatter only (optional)
//	    opencode.md   — OpenCode frontmatter only (optional)
//	    claude.md     — Claude Code frontmatter only (optional)
//
// The script concatenates the appropriate frontmatter file with body.md
// and writes the result to the platform-specific output directory:
//
//	Agents:
//	  Copilot  → ai/dist/copilot/agents/<name>.agent.md
//	  OpenCode → ai/dist/opencode/agents/<name>.md
//	  Claude   → ai/dist/claude/agents/<name>.md
//
//	Commands:
//	  Copilot  → ai/dist/copilot/commands/<name>.prompt.md
//	  OpenCode → ai/dist/opencode/commands/<name>.md
//	  Claude   → ai/dist/claude/commands/<name>.md
//
// At least one of copilot.md, opencode.md, or claude.md must exist per
// agent/command. body.md is always required. A warning is printed for any
// missing optional file; the corresponding output is simply skipped.
//
// Usage:
//
//	go run . [flags]
//
// Flags:
//
//	--dry-run             print what would be written without writing anything
//	--source <dir>        source agents directory (default: ai/agents relative to repo root)
//	--commands-source <dir> source commands directory (default: ai/commands relative to repo root)
//	--out-copilot <dir>   output base directory for Copilot files (default: ai/dist/copilot relative to repo root)
//	--out-opencode <dir>  output base directory for OpenCode files (default: ai/dist/opencode relative to repo root)
//	--out-claude <dir>    output base directory for Claude files (default: ai/dist/claude relative to repo root)
//	--skills              also symlink ai/skills/ → ~/.config/opencode/skills/ and ~/.copilot/skills/
//	--agents              also symlink generated agent files into ~/.copilot/agents/, ~/.config/opencode/agents/, and ~/.claude/agents/
//	--commands            also symlink generated command files into ~/.copilot/commands/, ~/.config/opencode/commands/, and ~/.claude/commands/
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
	commandsSourceDir := flag.String("commands-source", "", "Source commands directory (default: ai/commands relative to repo root)")
	outCopilot := flag.String("out-copilot", "", "Output base directory for Copilot files (default: ai/dist/copilot relative to repo root)")
	outOpencode := flag.String("out-opencode", "", "Output base directory for OpenCode files (default: ai/dist/opencode relative to repo root)")
	outClaude := flag.String("out-claude", "", "Output base directory for Claude files (default: ai/dist/claude relative to repo root)")
	syncSkills := flag.Bool("skills", false, "Also symlink ai/skills/ into ~/.config/opencode/skills/ and ~/.copilot/skills/")
	syncAgents := flag.Bool("agents", false, "Also symlink generated agent files into ~/.copilot/agents/, ~/.config/opencode/agents/, and ~/.claude/agents/")
	syncCommands := flag.Bool("commands", false, "Also symlink generated command files into ~/.copilot/commands/, ~/.config/opencode/commands/, and ~/.claude/commands/")
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

	cmdSrc := *commandsSourceDir
	if cmdSrc == "" {
		cmdSrc = filepath.Join(repoRoot, "ai", "commands")
	}

	copilotOut := *outCopilot
	if copilotOut == "" {
		copilotOut = filepath.Join(repoRoot, "ai", "dist", "copilot")
	}

	opencodeOut := *outOpencode
	if opencodeOut == "" {
		opencodeOut = filepath.Join(repoRoot, "ai", "dist", "opencode")
	}

	claudeOut := *outClaude
	if claudeOut == "" {
		claudeOut = filepath.Join(repoRoot, "ai", "dist", "claude")
	}

	copilotAgentsOut := filepath.Join(copilotOut, "agents")
	opencodeAgentsOut := filepath.Join(opencodeOut, "agents")
	claudeAgentsOut := filepath.Join(claudeOut, "agents")
	copilotCommandsOut := filepath.Join(copilotOut, "commands")
	opencodeCommandsOut := filepath.Join(opencodeOut, "commands")
	claudeCommandsOut := filepath.Join(claudeOut, "commands")

	entries, err := os.ReadDir(src)
	if err != nil {
		fatalf("could not read source directory %q: %v\n", src, err)
	}

	if !*dryRun {
		for _, dir := range []string{copilotAgentsOut, opencodeAgentsOut, claudeAgentsOut, copilotCommandsOut, opencodeCommandsOut, claudeCommandsOut} {
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
		result, err := processAgent(agentDir, entry.Name(), copilotAgentsOut, opencodeAgentsOut, claudeAgentsOut, *dryRun)
		processed++
		written += result.written
		if err != nil {
			warnf("%s: %v\n", entry.Name(), err)
			skipped++
		}
	}

	fmt.Printf("\nagents: %d processed, %d files written, %d skipped\n", processed, written, skipped)

	// Process commands.
	cmdEntries, err := os.ReadDir(cmdSrc)
	if err != nil {
		if !errors.Is(err, os.ErrNotExist) {
			fatalf("could not read commands source directory %q: %v\n", cmdSrc, err)
		}
		// Commands directory doesn't exist — that's fine, just skip.
		fmt.Println("commands: source directory not found, skipping")
	} else {
		var cmdProcessed, cmdWritten, cmdSkipped int

		for _, entry := range cmdEntries {
			if !entry.IsDir() {
				continue
			}

			cmdDir := filepath.Join(cmdSrc, entry.Name())
			result, err := processCommand(cmdDir, entry.Name(), copilotCommandsOut, opencodeCommandsOut, claudeCommandsOut, *dryRun)
			cmdProcessed++
			cmdWritten += result.written
			if err != nil {
				warnf("%s: %v\n", entry.Name(), err)
				cmdSkipped++
			}
		}

		fmt.Printf("commands: %d processed, %d files written, %d skipped\n", cmdProcessed, cmdWritten, cmdSkipped)
		written += cmdWritten
	}

	fmt.Printf("\ndone: %d total files written\n", written)

	if *syncSkills {
		syncSkillsDir(repoRoot, *dryRun)
	}

	if *syncAgents {
		home, err := os.UserHomeDir()
		if err != nil {
			warnf("agents sync: could not determine home directory: %v\n", err)
		} else {
			symlinkDir(copilotAgentsOut, filepath.Join(home, ".copilot", "agents"), *dryRun)
			symlinkDir(opencodeAgentsOut, filepath.Join(home, ".config", "opencode", "agents"), *dryRun)
			symlinkDir(claudeAgentsOut, filepath.Join(home, ".claude", "agents"), *dryRun)
		}
	}

	if *syncCommands {
		home, err := os.UserHomeDir()
		if err != nil {
			warnf("commands sync: could not determine home directory: %v\n", err)
		} else {
			symlinkDir(copilotCommandsOut, filepath.Join(home, ".copilot", "commands"), *dryRun)
			symlinkDir(opencodeCommandsOut, filepath.Join(home, ".config", "opencode", "commands"), *dryRun)
			symlinkDir(claudeCommandsOut, filepath.Join(home, ".claude", "commands"), *dryRun)
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
// whichever of copilot.md / opencode.md / claude.md exist, and writes the
// assembled output files. Returns an error only for fatal problems (e.g.
// missing body, all frontmatter files absent). Missing individual frontmatter
// files produce warnings but are not fatal.
func processAgent(agentDir, name, copilotOut, opencodeOut, claudeOut string, dryRun bool) (processResult, error) {
	return processEntry(agentDir, name, copilotOut, opencodeOut, claudeOut, dryRun, agentNaming)
}

// processCommand handles a single command directory. It follows the same
// assembly logic as agents but uses plain .md naming for both platforms.
func processCommand(cmdDir, name, copilotOut, opencodeOut, claudeOut string, dryRun bool) (processResult, error) {
	return processEntry(cmdDir, name, copilotOut, opencodeOut, claudeOut, dryRun, commandNaming)
}

// namingFunc returns the output filename for a given entry name.
type namingFunc func(name string) string

func agentNaming(name string) string   { return name + ".agent.md" }
func commandNaming(name string) string { return name + ".prompt.md" }

// processEntry handles a single agent or command directory. It reads body.md
// plus whichever of copilot.md / opencode.md / claude.md exist, and writes
// the assembled output files using the provided naming function to determine
// filenames.
func processEntry(entryDir, name, copilotOut, opencodeOut, claudeOut string, dryRun bool, copilotName namingFunc) (processResult, error) {
	var result processResult

	// body.md is always required.
	bodyPath := filepath.Join(entryDir, "body.md")
	body, err := os.ReadFile(bodyPath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return result, fmt.Errorf("body.md is missing")
		}
		return result, fmt.Errorf("could not read body.md: %w", err)
	}

	copilotFM, copilotErr := readFile(filepath.Join(entryDir, "copilot.md"))
	opencodeFM, opencodeErr := readFile(filepath.Join(entryDir, "opencode.md"))
	claudeFM, claudeErr := readFile(filepath.Join(entryDir, "claude.md"))

	// All three missing is a hard error — nothing to do.
	if errors.Is(copilotErr, os.ErrNotExist) && errors.Is(opencodeErr, os.ErrNotExist) && errors.Is(claudeErr, os.ErrNotExist) {
		return result, fmt.Errorf("copilot.md, opencode.md, and claude.md are all missing")
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

	if errors.Is(claudeErr, os.ErrNotExist) {
		warnf("%s: claude.md not found, skipping Claude output\n", name)
	} else if claudeErr != nil {
		warnf("%s: could not read claude.md: %v — skipping Claude output\n", name, claudeErr)
	}

	bodyStr := strings.TrimRight(string(body), "\n") + "\n"

	// Write Copilot output.
	if copilotErr == nil {
		outPath := filepath.Join(copilotOut, copilotName(name))
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

	// Write Claude output.
	if claudeErr == nil {
		outPath := filepath.Join(claudeOut, name+".md")
		assembled := assembleMD(claudeFM, bodyStr)
		if err := writeFile(outPath, assembled, dryRun); err != nil {
			warnf("%s: could not write Claude output: %v\n", name, err)
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

// syncSkillsDir symlinks the entire ai/skills/ directory into the
// platform-specific skills locations:
//
//	OpenCode → ~/.config/opencode/skills/
//	Copilot  → ~/.copilot/skills/
func syncSkillsDir(repoRoot string, dryRun bool) {
	skillsSrc := filepath.Join(repoRoot, "ai", "skills")
	home, err := os.UserHomeDir()
	if err != nil {
		warnf("skills sync: could not determine home directory: %v\n", err)
		return
	}

	dsts := []string{
		filepath.Join(home, ".config", "opencode", "skills"),
		filepath.Join(home, ".copilot", "skills"),
	}

	for _, dst := range dsts {
		if dryRun {
			if _, err := os.Lstat(dst); err == nil {
				fmt.Printf("[dry-run] symlink already exists, skipping: %s\n", dst)
			} else {
				fmt.Printf("[dry-run] would symlink: %s -> %s\n", dst, skillsSrc)
			}
			continue
		}

		// Remove whatever exists at the destination (symlink, real dir, file)
		// so we can replace it with the whole-directory symlink.
		if _, err := os.Lstat(dst); err == nil {
			if err := os.RemoveAll(dst); err != nil {
				warnf("skills sync: could not remove existing %q: %v\n", dst, err)
				continue
			}
		}

		if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
			warnf("skills sync: could not create parent of %q: %v\n", dst, err)
			continue
		}

		if err := os.Symlink(skillsSrc, dst); err != nil {
			warnf("skills sync: could not create symlink %q -> %q: %v\n", dst, skillsSrc, err)
			continue
		}
		fmt.Printf("symlinked: %s -> %s\n", dst, skillsSrc)
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
