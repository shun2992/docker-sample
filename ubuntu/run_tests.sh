#!/bin/sh -eux
exec 1>&2

localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
