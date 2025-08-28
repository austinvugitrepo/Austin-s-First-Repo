#!/bin/bash

#requires gentoolkit

sudo emaint sync --auto
sudo emerge --ask --update --newuse --deep --verbose @world
sudo dispatch-conf
sudo emerge --ask --depclean
sudo eclean -d distfiles
sudo eclean-pkg
