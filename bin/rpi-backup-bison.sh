#!/bin/sh

TIMESTAMP=$(date --rfc-3339=s -u | cut -f 1 -d + | tr ' ' '_')

nc -l 8080 \
	| pv \
	| pixz \
	> /mnt/vault/rpi/backup-${TIMESTAMP}.tar.pxz
