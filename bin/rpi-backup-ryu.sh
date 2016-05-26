#!/bin/sh
sudo tar \
	--exclude 'var/cache/*' \
	--exclude 'sys/*' \
	--exclude 'proc/*' \
	--exclude 'dev/*' \
	--exclude 'run/*' \
	--exclude 'mnt/*' \
	--exclude 'media/*' \
	-cp --directory=/ . \
	| nc bison 8080
