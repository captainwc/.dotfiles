export PS1="\[\e[32;1m\][\[\e[33;1m\]\u\[\e[31;1m\]@\[\e[33;1m\]\h \[\e[36;1m\]\w\[\e[32;1m\]]\[\e[34;1m\]\$ \[\e[0m\]"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi

if [ -f ~/.bash_tmux ]; then
    if [ -n "$TMUX" ]; then
        . ~/.bash_tmux
    fi
fi
