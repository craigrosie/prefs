# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{sensible,path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Enable bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Enable pyenv shims & autocomplete
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Enable pyenv-virtualenv auto-activation
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable rbenv shims & autocomplete
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Enable jenv shims & autocomplete
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Enable thefuck alias
eval "$(thefuck --alias)"

# Enable fasd
eval "$(fasd --init auto)"

# Enable normal names for coreutils tools
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH";

# Enable normal man pages for coreutils tools
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH";

# Enable fzf auto-completion & key bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Also use ag for the fzf ctrl+T command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set default options for fzf
export FZF_DEFAULT_OPTS="--height 30% --reverse --cycle"

# Don't record jrnl entries in bash history
HISTIGNORE="$HISTIGNORE:jrnl *"

# Set up golang env
export GOPATH=~/github/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export EDITOR=`command -v vim`

# Enable github cli autocompletion
eval "$(gh completion -s bash)"

echo "System online ✔︎"
