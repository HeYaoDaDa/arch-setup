#!/bin/bash
# 获取当前组名
CURRENT=$(busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 CurrentInputMethodGroup | awk '{print $2}' | tr -d '"')

# 假设你有两个组：Default 和 Rime
if [ "$CURRENT" == "Default" ]; then
    busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 SwitchInputMethodGroup s "Rime"
else
    busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 SwitchInputMethodGroup s "Default"
fi
