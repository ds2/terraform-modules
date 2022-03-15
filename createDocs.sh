#!/usr/bin/env bash

dirs=$(find -maxdepth 1 -type d)

mkdir docs 2>>/dev/null

for d in $dirs; do
    mainFile="$d/main.tf"
    if [ -f $mainFile ]; then
        terraform-docs $d/ >docs/${d}.md
    fi
done
