#!/usr/bin/env sh

cd ~ || exit 1

find .ssh/ -type f -exec chmod 600 {} \;
find .ssh/ -type d -exec chmod 700 {} \;
find .ssh/ -type f -name "*.pub" -exec chmod 644 {} \;
find .ssh/ -type f -name "authorized_keys" -exec chmod 640 {} \;
