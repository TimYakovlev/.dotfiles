#!/usr/bin/env bash

xdg-user-dirs-update

sudo apt install -y i3-wm i3status suckless-tools dunst lightdm slick-greeter
sudo apt install -y xorg xinput xclip
sudo apt install -y build-essential
sudo apt install -y pulseaudio alsa-utils pavucontrol
sudo apt install -y curl neofetch feh whois unzip scrot htop mpv yt-dlp thunar

sudo systemctl enable lightdm

