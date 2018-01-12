# My scripts
export PATH=$HOME/bin:$PATH

# Luarocks
export PATH=$HOME/.luarocks/bin:$PATH

# Wine
export WINEPREFIX=$HOME/.wine/default
export WINEDLLOVERRIDES=winemenubuilder.exe=d

# Go
export PATH=$HOME/projects/go/bin:$PATH
export GOPATH=$HOME/projects/go

# Global settings
export PAGER="less"

if hash qutebrowser 2>&1 > /dev/null; then
  export BROWSER="qutebrowser"
elif hash firefox 2>&1 > /dev/null; then
  export BROWSER="firefox"
fi

if hash emacsclient 2>&1 > /dev/null; then
  export EDITOR="emacsclient -nc"
elif hash vim 2>&1 > /dev/null; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi