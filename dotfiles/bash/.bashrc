# ~/.bashrc

# TODO: Rework secrets

# load .gitignore'd secrets
secrets="$HOME/dotfiles/.secrets"
if [ -f "$secrets" ]; then
    source "$secrets"
fi

##################################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set starship as PS1 shell prompt
eval "$(starship init bash)"

export TERM=xterm-256color
export COLORTERM=truecolor

##################################################
# general
alias grep='grep --color=auto'
alias nano='nano -ET4 -i'

# nixos
alias nrs='sudo nixos-rebuild switch'
alias nru='sudo nixos-rebuild switch --upgrade'
alias cdn='cd /etc/nixos'

# ls
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias l='ls'

# git
alias gita='git add .'
alias gitc='git commit -m' # message to be inserted by user
alias gitp='git push origin'
alias gits='git status'
alias gitf='git fame --cost hour -wMC --format svg --min 1 > docs/authors.svg'

# docker / Laravel Sail
alias docker-nuke='docker container prune -f; docker image prune -af; docker volume prune -f; docker network prune -f'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcdv='docker compose down -v'

alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# ssh
alias ssh-vps='ssh -i $SECRET_VPS_KEY root@$SECRET_VPS_IP'

# $HOME/bin & $HOME/code/workflows
alias llm-clean='sudo rm -rf $HOME/code/workflow/open-webui/open-webui/{uploads/*,cache/audio/speech/*}'
