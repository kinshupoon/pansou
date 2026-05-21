#!/bin/sh
basedir=$(cd $(dirname $0) && pwd)
APP="$basedir/pansou"
ENV_FILE="$basedir/.env"
LOG="$basedir/pansou.log"
MAX_LINES=500

cd "$basedir" || exit 1

# ===== 加载环境变量 =====
set -a
. "$ENV_FILE"
set +a

# ===== 防止日志爆盘（关键）=====
if [ -f "$LOG" ]; then
    tail -n $MAX_LINES "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi

# ===== 检查进程 =====
if pgrep -f "$APP" > /dev/null; then
    echo "$APP 已经运行"
    exit 0
fi

echo "$(date '+%F %T') restart pansou" |tee -a "$LOG"

# ===== 启动 =====
nohup env \
PORT="$PORT" \
CHANNELS="$CHANNELS" \
ENABLED_PLUGINS="$ENABLED_PLUGINS" \
"$APP" >> "$LOG" 2>&1 &