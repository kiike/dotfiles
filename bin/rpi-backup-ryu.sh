#!/bin/sh
sudo tar \
	--exclude 'var/cache/*' \
	--exclude 'sys/*' \
	--exclude 'proc/*' \
	--exclude 'dev/*' \
	--exclude 'run/*' \
	-cp --directory=/ . \
	| nc bison 8080
