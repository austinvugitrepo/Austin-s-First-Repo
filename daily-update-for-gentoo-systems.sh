#!/bin/bash
sudo emaint sync --auto
sudo emerge --ask --update --newuse --deep --verbose @world
sudo emerge --ask --depclean
sudo dispatch-conf
