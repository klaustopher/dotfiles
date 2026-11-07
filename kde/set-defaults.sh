#!/bin/sh

clear_kwin_shortcut() {
  # Fails without a running Plasma session; the config below applies on next login
  gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel \
    --method org.kde.KGlobalAccel.setForeignShortcut \
    "['kwin', '$1', 'KWin', '$1']" "@ai []" >/dev/null 2>&1

  kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "$1" "none,$2,$3"
}

# Free Meta+T and Meta+W for the Ghostty keybinds
clear_kwin_shortcut "Edit Tiles" "Meta+T" "Tiling-Editor ein-/ausschalten"
clear_kwin_shortcut "Overview" "Meta+W" "Übersicht umschalten"
