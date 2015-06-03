#!/usr/bin/env python

import os
import logging
import argparse
import csv


def uninstall(src, dst):
    if os.path.exists(dst) and os.path.islink(dst):
        logging.info('unlink\t {}'.format(dst))
        os.unlink(dst)
    elif os.path.exists(dst) and os.path.isdir(dst):
        logging.error('Can\'t remove {}; it\'s a directory'.format(dst))
    elif os.path.exists(dst) and os.path.isfile(dst):
        logging.error('Can\'t remove {}; it\'s a file'.format(dst))


def install(src, dst):
    if not os.path.exists(os.path.dirname(dst)):
        logging.info('makedir\t{}'.format(dst))
        os.makedirs(dst)

    src = os.path.abspath(src)
    if not os.path.exists(dst):
        logging.info('link\t{} -> {}'.format(src, dst))
        os.symlink(src, dst)


parser = argparse.ArgumentParser()
parser.add_argument('--uninstall', help='Uninstall the links', dest='action',
                    action='store_const', const=uninstall, default=install)
args = parser.parse_args()

dirs = {}
dirs['home'] = os.getenv('HOME')
dirs['xdg_conf'] = os.getenv('XDG_CONFIG_HOME',
                             default=dirs['home']+'/.config/')
dirs['xdg_data'] = os.getenv('XDG_DATA_HOME',
                             default=dirs['home']+'/.local/share/')

logging.basicConfig(format='[%(levelname)s] %(message)s', level=logging.INFO)

with open('install.list') as f:
    reader = csv.reader(f)
    for row in reader:
        if row:
            src = row[0].strip()
            macro = row[1].strip()
            dst = row[2].strip()
            args.action(src, os.path.join(dirs[macro], dst))
