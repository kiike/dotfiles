#!/bin/sh

nc -l 8080 \
	| pv \
	| pixz \
	> /mnt/vault/rpi.tar.gz
