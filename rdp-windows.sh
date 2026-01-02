#!/bin/bash

# Detect display scale from Hyprland
HYPR_SCALE=$(hyprctl monitors -j | jq -r '.[] | select (.focused == true) | .scale')
SCALE_PERCENT=$(echo "$HYPR_SCALE" | awk '{print int($1 * 100)}')

RDP_SCALE=""
if [ "$SCALE_PERCENT" -ge 170 ]; then
  RDP_SCALE="/scale:180"
elif [ "$SCALE_PERCENT" -ge 130 ]; then
  RDP_SCALE="/scale:140"
fi
# If scale is less than 130%, don't set any scale (use default 100)

# FreeRDP 配置
RDP_HOST="127.0.0.1"
RDP_PORT="3389"
RDP_USER="yy"
RDP_PASS="yy"
RDP_TITLE="Windows11"

# 核心：拆解所有参数为数组（关键！避免空格/特殊字符解析错误）
RDP_ARGS=(
  "/u:$RDP_USER"                         # 用户名（带引号的写法可省略，数组自动处理空格）
  "/p:$RDP_PASS"                         # 密码
  "/v:$RDP_HOST:$RDP_PORT"               # 主机+端口（自动拼接）
  "/kbd:remap:0x3a=0x1d,remap:0x1d=0x3a" # 交换 Caps/Ctrl
  # "/kbd:remap:0x5b=0xff,remap:0x5c=0xff"                 # 彻底屏蔽远程 Win 键
  "-grab-keyboard"                                       # -: 禁止独占，让 Win 留在 Linux. +: 独占
  "/sound"                                               # 音频输出
  "/microphone"                                          # 麦克风输入
  "/cert:ignore"                                         # 忽略证书错误（替代旧版 /cert-ignore）
  "/title:$RDP_TITLE"                                    # 窗口标题
  "/dynamic-resolution"                                  # 动态分辨率
  "/floatbar:sticky:off,default:visible,show:fullscreen" # 浮动栏配置
  "$RDP_SCALE"                                           # 缩放参数（外部变量）
)

echo "${RDP_ARGS[@]}"

# 后台运行 FreeRDP，不占用终端
nohup sdl-freerdp3 "${RDP_ARGS[@]}" >/tmp/rdp-session.log 2>&1 &
# 记录 PID 便于后续管理（如关闭）
echo $! >/tmp/rdp-session.pid
hyprctl reload
