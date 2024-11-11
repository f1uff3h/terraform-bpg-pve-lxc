$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
}

def rmswap [] { fd -H .*.sw[p|o]$ $env.HOME | xargs -I{} rm -rf {}}

alias nv = nvim
alias ll = ls -ls
alias la = ls -la
alias glog = git log --all --oneline --decorate --graph
alias gl = git log --all --oneline -n 5
alias t = terraform
alias td = terraform-docs

source ~/.cache/zoxide/init.nu
use ~/.cache/starship/init.nu
