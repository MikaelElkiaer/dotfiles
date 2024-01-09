#!/usr/bin/env bash

sed -i '/url/s/https:\/\/github.com\/\(.*\)/git@github.com:\1/' .git/config
