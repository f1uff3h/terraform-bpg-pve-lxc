$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
}

def rmswap [] { fd -H .*.sw[p|o]$ $env.HOME | xargs -I{} rm -rf {}}

alias nv = nvim
alias ll = ls -ls
alias la = ls -la
alias glog = git log --all --oneline --decorate --swap_graph
alias gl = git log --all --oneline -n 4
alias gd = git $"--git-dir=($env.HOME)/repos/.files" $"--work-tree=($env.HOME)"
alias lt = sed -i 's/mocha/latte/' $"($env.HOME)/.config/alacritty/alacritty.toml"
alias dt = sed -i 's/latte/mocha/' $"($env.HOME)/.config/alacritty/alacritty.toml"
alias tfdev = podman container run -it -v persist-nu:/home/user/.config/nushell -v persist-nv:/home/user/.local/share/nvim -v persist-z:/home/user/.local/share/zoxide -v $'($env.HOME)/.ssh/:/home/user/.ssh:ro' -v $'($env.HOME)/.gitconfig:/home/user/.gitconfig:ro' -v ./:/home/user/workspace tfdev nu

source ~/.cache/zoxide/init.nu
use ~/.cache/starship/init.nu
