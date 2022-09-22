rm ~/.packages
rm ~/.packages-aur
pacman -Qm > ~/.packages-aur
pacman -Qqett > ~/.packages
