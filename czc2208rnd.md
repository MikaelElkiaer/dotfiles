# czc2208rnd

## Install Microsoft Edge

```bash
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt-get update
sudo apt-get install microsoft-edge-stable
```

## Install font

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DejaVuSansMono.zip
unzip ~/Downloads/DejaVuSansMono.zip DejaVuSansMNerdFontMono-Regular.ttf
mv DejaVuSansMNerdFontMono-Regular.ttf ~/.local/share/fonts
fc-cache ~/.local/share/fonts
```
