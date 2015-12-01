ifndef $(XDG_CONFIG_HOME)
	XDG_CONFIG_HOME=$(HOME)/.config
endif

ifndef $(XDG_DATA)
	XDG_DATA_HOME=$(HOME)/.local
endif

minimum: vim zsh tmux bin
all: minimum awesome bspwm compton newsbeuter X vifm submodules

bin:
	ln -Tsf $(PWD)/bin $(HOME)/bin

mksh:
	ln -Tsf $(PWD)/mksh/mkshrc $(HOME)/.mkshrc
	ln -Tsf $(PWD)/mksh/profile $(HOME)/.profile

zsh:
	ln -Tsf $(PWD)/zlogin $(HOME)/.zlogin
	ln -Tsf $(PWD)/zprofile $(HOME)/.zprofile
	ln -Tsf $(PWD)/zshrc $(HOME)/.zshrc

awesome:
	ln -Tsf $(PWD)/awesome $(XDG_CONFIG_HOME)/awesome
	ln -Tsf $(PWD)/awesome $(XDG_DATA_HOME)/awesome

bspwm:
	ln -Tsf $(PWD)/bspwm $(XDG_CONFIG_HOME)/bspwm
	ln -Tsf $(PWD)/sxhkd $(XDG_CONFIG_HOME)/sxhkd
	ln -Tsf $(PWD)/panelrc $(HOME)/.panelrc

compton:
	ln -Tsf $(PWD)/compton.conf $(XDG_CONFIG_HOME)/compton.conf

newsbeuter:
	ln -Tsf $(PWD)/newsbeuter/ $(HOME)/.newsbeuter

X:
	ln -Tsf $(PWD)/xinitrc $(HOME)/.xinitrc
	ln -Tsf $(PWD)/Xresources $(HOME)/.Xresources
	ln -Tsf $(PWD)/Xcompose $(HOME)/.Xcompose
	ln -Tsf $(PWD)/Xmodmaprc $(HOME)/.Xmodmaprc

vifm:
	ln -Tsf $(PWD)/vifm $(HOME)/.vifm


tmux:
	ln -Tsf $(PWD)/tmux.conf $(HOME)/.tmux.conf

vim:
	ln -Tsf $(PWD)/vimrc $(HOME)/.vimrc

nvim:
	ln -Tsf $(PWD)/nvim/init.vim $(HOME)/.config/nvim/init.vim


clean:
	rm -f $(HOME)/.zlogin $(HOME)/.zprofile $(HOME)/.zshrc
	rm -rf $(XDG_CONFIG_HOME)/awesome $(XDG_DATA_HOME)/awesome
	rm -rf $(XDG_CONFIG_HOME)/bspwm $(XDG_CONFIG_HOME)/sxhkd $(HOME)/.panelrc
	rm -f $(XDG_CONFIG_HOME)/compton.conf
	rm -f $(HOME)/.xinitrc $(HOME)/.Xresources $(HOME)/.Xcompose $(HOME)/.Xmodmaprc
	rm -rf $(HOME)/.vifm
	rm -f $(HOME)/.tmux.conf
	rm -f $(HOME)/.vimrc
	rm -f $(HOME)/.nvimrc

submodules:
	git submodule update --recursive

.PHONY: vim tmux vifm X newsbeuter compton bspwm awesome zsh mpv clean nvim bin
