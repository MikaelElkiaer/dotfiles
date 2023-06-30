#!/bin/bash

pacmanfile dump && cat ~/.config/pacmanfile/*.txt | sort | uniq -u > ~/.config/pacmanfile/pacmanfile-unsorted.txt; rm ~/.config/pacmanfile/pacmanfile-dumped.txt
