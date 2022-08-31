#!/bin/bash

nmcli c modify $WIRED 802-3-ethernet.wake-on-lan magic
sudo sed -i "s/#?\(WOL_DISABLE=\)[YN]/\1Y/" /etc/tlp.conf
