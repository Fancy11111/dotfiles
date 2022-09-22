set PATH ~/bin ~/.bin ~/.local/bin ~/.bun/bin ~/.cargo/bin $PATH
set -g theme_color_scheme nord
set -gx EDITOR nvim
set -gx PF_INFO "ascii title os uptime pkgs wm shell editor"
set -gx BAT_THEME catppuccin

abbr -a -- - "cd -"
abbr -a -- n "alacritty &"

alias ls="exa -a --long --git"
alias dfs="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
#alias air="~/go/bin/air"
#alias matrix="unimatrix -af -s 96"
alias clock="tty-clock -c"
#alias thought="fortune | pokemonthink"
#alias strat="aow | pokemonsay"
alias nvim-config="cd ~/.config/nvim && nvim ."
alias xmonad-config="cd ~/.config/xmonad &6 nvim ."
alias fish-config="cd ~/.config/fish && nvim ."
alias vue-language-server="vls"

bass export NVM_DIR=~/.nvm

bass source /usr/share/nvm/nvm.sh
bass source /usr/share/nvm/bash_completion
bass source /usr/share/nvm/install-nvm-exec

# set PATH ~/.nvm/versions/node/v16.17.0/lib/node_modules/npm  $PATH
set PATH "~/.nvm/versions/node/$(nvm version)/bin"  $PATH

# bass export PATH=$PATH:$(npm config --global get prefix)/bin

starship init fish | source
neofetch
