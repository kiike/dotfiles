# My scripts
export PATH=$HOME/bin:$PATH

# Luarocks
if hash lua &> /dev/null; then
    export PATH=$HOME/.luarocks/bin:$PATH
fi

# Wine
if hash wine &> /dev/null; then
    export WINEPREFIX=$HOME/.wine/default
    export WINEDLLOVERRIDES=winemenubuilder.exe=d
fi

# Go
if hash go &> /dev/null; then
    export PATH=$HOME/projects/go/bin:$PATH
    export GOPATH=$HOME/projects/go
fi

export PAGER="less"

if hash qutebrowser &> /dev/null; then
  export BROWSER="qutebrowser"
elif hash firefox &> /dev/null; then
  export BROWSER="firefox"
fi

if hash emacsclient &> /dev/null; then
  export EDITOR="emacsclient -nc"
elif hash vim &> /dev/null; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi

# Font settings for Java apps
if hash java &> /dev/null; then
    export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
fi