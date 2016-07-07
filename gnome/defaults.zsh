#!/usr/bin/env zsh

# gnome GTK3 window button-layout on the left (Mac style)
exec gsettings set org.gnome.desktop.wm.preferences button-layout 'close:';
# same as the above for GTK2 apps (ie: google chrome)
exec gconftool-2 --set /apps/metacity/general/button_layout --type string "close,maximize,minimize:";
