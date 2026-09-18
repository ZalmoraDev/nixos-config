#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Export own bins to PATH
export PATH="$PATH:/home/sv/bin"

# Start ssh-agent if not already running
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval "$(ssh-agent -s)"
    # ssh-add ~/.ssh/helios-github

    # TODO: temp, old Arch system keys
    # ssh-add ~/.ssh/sv-gitlab
    ssh-add ~/.ssh/sv-github
    #ssh-add ~/.ssh/SV-VPS
fi

numlockx on
