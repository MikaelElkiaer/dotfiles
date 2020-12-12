## Oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/softmoth/zsh-vim-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vim-mode
```

## i3wm scripts
```
git clone git@github.com:MikaelElkiaer/i3-warp-mouse.git ~/Repositories/GitHub/i3-warp-mouse
git clone git@github.com:MikaelElkiaer/i3scripts.git ~/Repositories/GitHub/i3scripts
git clone git@github.com:gawen947/i3-quaketerm.git ~/Repositories/GitHub/i3-quaketerm
```

## Tungsten

1. Install xmlstarlet (e.g. `yay xmlstarlet`)
2. Get API key from http://developer.wolframalpha.com/portal/myapps/
3. Put it in `~/.wolfram_api_key`
4. Use `~/bin/rofi_run -t` or `~/bin/tungsten` directly
