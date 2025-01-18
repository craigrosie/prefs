ulimit -n 10240;
# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{sensible,path,bash_prompt,exports,aliases,functions,extra,fzf-git.sh}; do
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
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_wrap__git_main &> /dev/null && [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F __git_wrap__git_main g
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Add homebrew location to path
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Enable pyenv shims & autocomplete
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi

# Enable pyenv-virtualenv auto-activation
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Enable rbenv shims & autocomplete
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Enable jenv shims & autocomplete
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Enable fasd
eval "$(fasd --init bash-hook bash-ccomp bash-ccomp-install posix-alias posix-hook)"

# Enable normal names for coreutils tools
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"

# Enable gnu get-opt
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

# Enable normal man pages for coreutils tools
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH";

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
export GOPATH=~/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export EDITOR=nvim

# Automate ssh-agent startup
# https://superuser.com/questions/1152833/save-identities-added-by-ssh-add-so-they-persist
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"

# Enable github cli autocompletion
eval "$(gh completion -s bash)"

# Enable kubectl autocompletion
source <(kubectl completion bash)
# Enable it for k alias
complete -F __start_kubectl k

# Enable kube-ps1 (https://github.com/jonmosco/kube-ps1)
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_CTX_COLOR=26  # blue
export KUBE_PS1_NS_COLOR=172  # orange

# Prevent pip from installing packages outside of a virtualenv
# https://switowski.com/blog/disable-pip-outside-of-virtual-environments
export PIP_REQUIRE_VIRTUALENV=true

# ASDF (https://github.com/asdf-vm/asdf)
. $(brew --prefix asdf)/libexec/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

echo "System online ✔︎"
