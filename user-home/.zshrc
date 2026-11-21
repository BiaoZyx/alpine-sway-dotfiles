# ============================================================
# Zsh Configuration for Alpine Linux
# ============================================================

# ------------------------------------------------------------
# Extentions
# ------------------------------------------------------------
# powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ------------------------------------------------------------
# History
# ------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

# ------------------------------------------------------------
# Navigation
# ------------------------------------------------------------
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

# ------------------------------------------------------------
# Misc
# ------------------------------------------------------------
setopt EXTENDED_GLOB NO_CASE_GLOB INTERACTIVE_COMMENTS

# ------------------------------------------------------------
# Key Bindings (Emacs mode)
# ------------------------------------------------------------
bindkey -e

bindkey '^U' backward-kill-line
bindkey '^K' kill-line
bindkey '^W' backward-kill-word
bindkey '^[d' kill-word

bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word

# Ctrl+Backspace / Alt+Backspace: kill the word before the cursor
bindkey '^H' backward-kill-word          # Ctrl+Backspace (most terminals)
bindkey '^[[7;5~' backward-kill-word     # Ctrl+Backspace (xterm modifyOtherKeys)
bindkey '^[^?' backward-kill-word        # Alt+Backspace
bindkey '^[^H' backward-kill-word        # Alt+Backspace (terminals with BS=^H)

bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OF' end-of-line

bindkey '^[[1;5D' backward-word
bindkey '^[^[[D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[^[[C' forward-word

# ------------------------------------------------------------
# Aliases
# ------------------------------------------------------------
# ls
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --sort=type --color=always'
    alias ll='ls -l --git --group --links'
    alias la='ls -A'
    alias l='ls -lA --git --group --links'
else
    alias ls='ls --color=always'
    alias ll='ls -l'
    alias la='ls -A'
    alias l='ls -lAh'
fi

# Parent dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Useful ones
alias cls='clear'

# Colorful outputs
alias grep='grep --color=auto'
alias ip='ip --color=auto'

# Git
alias g=git
alias gst='git status'
alias gp='git pull'
alias gpu='git push'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline --graph'

# customs
alias fastfetch='fastfetch -l Alpine2'
alias less='less -MSR --mouse --use-color'
#alias t='trans -e bing -b'

# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------
mkcd() { [ -n "$1" ] || { echo "usage: mkcd <dir>" >&2; return 1; }; mkdir -p "$1" && cd "$1"; }

extract() {
    [ -f "$1" ] || { echo "extract: no such file: $1" >&2; return 1; }
    case "$1" in
        *.tar.gz|*.tgz) tar xzf "$1" ;;
        *.tar.xz)       tar xJf "$1" ;;
        *.tar.bz2)      tar xjf "$1" ;;
        *.zip)          unzip "$1" ;;
        *.gz)           gunzip "$1" ;;
        *)              echo "extract: unknown format: $1" >&2; return 1 ;;
    esac
}


# ------------------------------------------------------------
# Completion
# ------------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _ignored

# ------------------------------------------------------------
# Syntax Highlighting
# ------------------------------------------------------------
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ------------------------------------------------------------
# Autosuggestions
# ------------------------------------------------------------
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#787878"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# ------------------------------------------------------------
# History Substring Search
# ------------------------------------------------------------
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

    bindkey '^[[A' up-line-or-history
    bindkey '^[[B' down-line-or-history
    bindkey '^[OA' up-line-or-history
    bindkey '^[OB' down-line-or-history
    bindkey '^R' history-incremental-search-backward

    bindkey '^[[1;3A' history-substring-search-up
    bindkey '^[[1;3B' history-substring-search-down

    bindkey '^[[1;2A' up-history
    bindkey '^[[1;2B' down-history
    bindkey '^[[5~' up-history
    bindkey '^[[6~' down-history
fi

# ------------------------------------------------------------
# Powerlevel10k Theme
# ------------------------------------------------------------
if [ -f /usr/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /usr/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# ------------------------------------------------------------
# Environment Settings
# ------------------------------------------------------------
export PATH=/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/.opencode/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Language
if [ $TERM = linux ]; then
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export LANGUAGE=en_US:en
else
	export LANG=zh_CN.UTF-8
	export LC_ALL=zh_CN.UTF-8
	export LANGUAGE=zh_CN:zh
fi

export XDG_CURRENT_DESKTOP=sway

# Input Method
#export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# Qt Settings
export QT_QPA_PLATFORMTHEME=qt6ct

#export QT_AUTO_SCREEN_SCALE_FACTOR=0
#export QT_SCREEN_SCALE_FACTORS=1
#export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1
export QT_FONT_DPI=90

# GTK Settings
export ADW_DISABLE_PORTAL=1
