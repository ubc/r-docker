#!/bin/bash
set -e

if [ "$1" = 'R' ]; then
    # check if there is any local packages to be installed
    if [ -d "/localdata/packages" ]; then
      for i in /localdata/packages/*.tar.gz; do
        echo "Installing $i..."
        Rscript -e "install.packages('$i', repo=NULL, type='source')"
      done
    fi
fi

exec "$@"
