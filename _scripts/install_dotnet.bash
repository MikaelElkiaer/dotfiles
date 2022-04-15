#!/bin/bash

wget https://dot.net/v1/dotnet-install.sh && chmod +x dotnet-install.sh
sudo ./dotnet-install.sh --channel 2.1 --version latest --install-dir /opt/dotnet
sudo ./dotnet-install.sh --channel 3.1 --version latest --install-dir /opt/dotnet
sudo ./dotnet-install.sh --channel 6.0 --version latest --install-dir /opt/dotnet
