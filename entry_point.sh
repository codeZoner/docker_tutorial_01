#!/bin/sh
git config --global --add safe.directory /app &&
    git config --global user.email "example@email.com" &&
    git config --global user.name "John Doe" &&
    git pull &&
    bun install &&
    bun build &&
    bun start
