#!/bin/bash

#requires gentoolkit

sudo emaint sync --auto
sudo emerge --ask --update --newuse --deep --verbose @world
sudo dispatch-conf
sudo emerge --ask --depclean
sudo eclean -d distfiles
sudo eclean-pkg

#if you have doas uncomment and delete sudo portion

#doas emaint sync --auto
#doas emerge --ask --update --newuse --deep --verbose @world
#doas dispatch-conf
#doas emerge --ask --depclean
#doas eclean -d distfiles
#doas eclean-pkg


