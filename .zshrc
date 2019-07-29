# zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/je/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="pygmalion"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8 

export JAVA_HOME="`/usr/libexec/java_home -v 1.8`"

export TERM=xterm-256color

export PATH=~/bin:$PATH

export HOMEBREW_FORCE_BREWED_CURL=1
# export HOMEBREW_NO_AUTO_UPDATE=true

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
eval "$(pyenv init -)"

alias rsync='rsync -avr --progress'
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs "$@"'
alias ce='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n'
alias re="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudo -e"

alias g='git'

alias mpc='ncmpcpp'

alias gweb='wget -r -p -np -k -c'
alias pwget="proxychains4 wget"
alias pbrew="ALL_PROXY=socks5://127.0.0.1:1080 brew"
alias tq='curl wttr.in'
alias pc='proxychains4'
alias curl='proxychains4 curl'

# percol zsh history search
function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

# extract various files with x $arg
function x()
{
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)
                tar jxvf "$1"
                ;;
            *.tar.gz)
                tar zxvf "$1"
                ;;
            *.tar.bz)
                tar zxvf "$1"
                ;;
            *.tar.Z)
                tar zxvf "$1"
                ;;
            *.tar.xz)
                tar Jxvf "$1"
                ;;
            *.bz2)
                bunzip2 "$1"
                ;;
            *.rar)
                unrar x "$1"
                ;;
            *.gz)
                gunzip "$1"
                ;;
            *.jar)
                unzip "$1"
                ;;
            *.tar)
                tar xvf "$1"
                ;;
            *.tbz2)
                tar jxvf "$1"
                ;;
            *.tgz)
                tar zxvf "$1"
                ;;
            *.zip)
                unzip "$1"
                ;;
            *.Z)
                uncompress "$1"
                ;;
            *.7z)
                7z x "$1"
                ;;
            *)
                echo "'$1' cannot be extracted!"
                ;;
        esac
    else
        echo "'$1' is not a valid archive!"
    fi
}

# extract various files with x $arg
function t()
{
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)
                tar jtvf "$1"
                ;;
            *.tar.gz)
                tar ztvf "$1"
                ;;
            *.tar.bz)
                tar ztvf "$1"
                ;;
            *.tar.Z)
                tar ztvf "$1"
                ;;
            *.tar.xz)
                tar Jtvf "$1"
                ;;
            *.bz2)
                bunzip2 "$1"
                ;;
            *.rar)
                unrar l "$1"
                ;;
            *.gz)
                gunzip -l "$1"
                ;;
            *.jar)
                unzip -v "$1"
                ;;
            *.tar)
                tar tvf "$1"
                ;;
            *.tbz2)
                tar jtvf "$1"
                ;;
            *.tgz)
                tar ztvf "$1"
                ;;
            *.zip)
                unzip -v "$1"
                ;;
            *.Z)
                uncompress "$1"
                ;;
            *.7z)
                7z l "$1"
                ;;
            *)
                echo "'$1' cannot be extracted!"
                ;;
        esac
    else
        echo "'$1' is not a valid archive!"
    fi
}

# File search functions
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Create a folder and move into it in one command
function mcd() { mkdir -p "$@" && cd "$_"; }

export PATH="/usr/local/opt/curl/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"

 . /Users/je/.nix-profile/etc/profile.d/nix.sh

