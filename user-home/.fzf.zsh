# Setup fzf
# ---------
if [[ ! "$PATH" == */home/xue/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/xue/.fzf/bin"
fi

source <(fzf --zsh)
