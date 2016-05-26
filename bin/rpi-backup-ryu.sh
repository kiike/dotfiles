#!/bin/sh
sudo tar \
	--create \
	--directory=/ . \
	--exclude 'dev/*' \
	--exclude 'media/*' \
	--exclude 'mnt/*' \
	--exclude 'proc/*' \
	--exclude 'run/*' \
	--exclude 'sys/*' \
	--exclude 'tmp/*' \
	--exclude 'var/cache/*' \
	--preserve \
	| nc bison 8080
