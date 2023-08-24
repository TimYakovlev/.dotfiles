#!/usr/bin/env bash

curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip
unzip RobotoMono.zip -d ~/.local/share/fonts
rm RobotoMono.zip
fc-cache -fv
