#!/bin/sh
#  ____  _             _    __        __          _
# / ___|| |_ __ _ _ __| |_  \ \      / /_ _ _   _| |__   __ _ _ __
# \___ \| __/ _` | '__| __|  \ \ /\ / / _` | | | | '_ \ / _` | '__|
#  ___) | || (_| | |  | |_    \ V  V / (_| | |_| | |_) | (_| | |
# |____/ \__\__,_|_|   \__|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|
#                                           |___/
# by Young (2023)
# -----------------------------------------------------

# -----------------------------------------------------
# Quit all running waybar instances
# -----------------------------------------------------
killall waybar
sleep 0.2

waybar
