#!/bin/bash
sudo emaint sync --auto
sudo emerge --ask --update --newuse --deep --verbose @world
sudo dispatch-conf
sudo emerge --ask --depclean

