for word in $(cat ~/.packages-aur); do yay -S -needed word || true; done
for word in $(cat ~/.packages); do yay -S -needed $word || true; don || true; done
