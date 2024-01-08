set PATH ~/bin ~/.bin ~/.local/bin ~/.bun/bin ~/.cargo/bin $PATH
set -g theme_color_scheme nord
set -gx EDITOR nvim
set -gx ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH go1.20
set -gx PF_INFO "ascii title os uptime pkgs wm shell editor"
set -gx BAT_THEME gruvbox-dark

abbr -a -- - "cd -"
abbr -a -- n "alacritty &"

alias ls="eza -a --long --git"
alias dfs="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
#alias air="~/go/bin/air"
#alias matrix="unimatrix -af -s 96"
alias clock="tty-clock -c"
#alias thought="fortune | pokemonthink"
#alias strat="aow | pokemonsay"
# alias nvim-config="cd ~/.config/nvim && nvim ."
alias xmonad-config="cd ~/.config/xmonad && nvim ."
alias fish-config="cd ~/.config/fish && nvim ."
alias vue-language-server="vls"
alias g="git"
alias susp="systemctl suspend"

bass export NVM_DIR=~/.nvm

bass source /usr/share/nvm/nvm.sh
bass source /usr/share/nvm/bash_completion
bass source /usr/share/nvm/install-nvm-exec
source /home/daniel/.opam/opam-init/init.fish 

# set PATH ~/.nvm/versions/node/v16.17.0/lib/node_modules/npm  $PATH
set PATH "/home/daniel/.nvm/versions/node/(nvm version)/bin"  $PATH
set JUPYTERLAB_DIR "$HOME/.local/share/jupyter/lab" 
set GOPATH "(go env GOPATH)"
set PATH "(go env GOPATH)/bin" $PATH
# bass export PATH=$PATH:$(npm config --global get prefix)/bin

# neofetch

# pnpm
set -gx PNPM_HOME "/home/daniel/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

starship init fish | source

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/daniel/.local/share/coursier/bin"
# <<< coursier install directory <<<
