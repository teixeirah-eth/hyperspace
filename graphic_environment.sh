#!/usr/bin/bash

# Check if the script is not being run as root user
if [ "$(id -u)" = 0 ]; then
    echo "You MUST NOT execute this script as the root user!"
    exit 1
fi

# Try to get fast servers to download packages
sudo pacman -Syy reflector rsync
sudo reflector -c Brazil -a 8 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syyy


# Install packages
sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr xorg-fonts-misc i3-gaps rofi picom feh pulseaudio pulseaudio-alsa pavucontrol noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code jdk11-openjdk jdk8-openjdk maven curl wget zip unzip zsh zsh-completions

# Install paru aur helper
cd ~ || exit
mkdir ~/Downloads
cd ~/Downloads || mkdir Downloads
git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si

# Declare AUR Packages
declare -a aurpackages=(
"ttf-unifont"
"siji-git"
"ttf-symbola"
"libxft-bgra"
"spotify"
"polybar"
"archlinux-java"
"visual-studio-code-bin"
)

for x in "${aurpackages[@]}"; do
    paru --noconfirm --needed -S "$x"
done

#Install st
cd ~/repositories/my-arch/suckless/st || exit
sudo make install
cd ~ || exit

# Configura polybar dotfiles e etc
mkdir -p .config/{polybar,i3,fontconfig}
cp -v ~/repositories/my-arch/dotfiles/polybar/* ~/.config/polybar/
sudo chown teixeira:users .config/polybar/config
sudo chmod +x .config/polybar/launch.sh
cp -v ~/repositories/my-arch/dotfiles/.xinitrc ~/.xinitrc
cp -v ~/repositories/my-arch/dotfiles/i3/* ~/.config/i3/
cp -v ~/repositories/my-arch/dotfiles/fontconfig/* ~/.config/fontconfig/
mkdir -p ~/Pictures
cp -v ~/repositories/my-arch/pictures/* ~/Pictures/

# Install brave browser
cd ~ || exit
cd ~/Downloads || exit
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin || exit
makepkg -si
cd ~ || exit


printf "\e[1;32mSucesso na instalação!!! Reboot, log in and type startx.\e[0m"