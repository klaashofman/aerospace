#!/bin/bash
# Open a new Terminal.app window in the working directory of the focused terminal.
# Falls back to a plain new window when the focused app is not Terminal/iTerm2.
# Set DRY_RUN=1 to print the directory instead of opening a window.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

tty=""
case "$(aerospace list-windows --focused --format '%{app-name}')" in
    Terminal) tty=$(osascript -e 'tell application "Terminal" to get tty of selected tab of front window') ;;
    iTerm2)   tty=$(osascript -e 'tell application "iTerm2" to tell current session of current window to get tty') ;;
esac

dir=""
if [ -n "$tty" ]; then
    # Last foreground ('+' in STAT) process on the tty; its cwd is where the user is
    pid=$(ps -t "${tty#/dev/}" -o pid=,stat= | awk '$2 ~ /\+/ { p = $1 } END { print p }')
    [ -n "$pid" ] && dir=$(lsof -a -p "$pid" -d cwd -Fn | sed -n 's/^n//p')
fi

if [ -n "${DRY_RUN:-}" ]; then
    echo "${dir:-<none>}"
elif [ -d "$dir" ]; then
    open -a Terminal "$dir"
else
    osascript -e 'tell application "Terminal" to tell (do script) to activate'
fi
