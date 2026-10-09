#!/usr/bin/env sh

show_help() {
    echo "Usage: diagnostic.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  system           Display system metrics (CPU, Memory, Hostname)"
    echo "  disk <threshold> Check disk usage against percentage threshold (1-100)"
    echo "  network <host>   Check host connectivity and ping"
    echo "  help             Display this help message"
}

COMMAND="$1"

case "$COMMAND" in
    system)
        echo "=== System Status ==="
        echo "Hostname: $(hostname)"
        echo "Uptime:   $(uptime)"
        if [ -f /proc/meminfo ]; then
            echo "Memory:   $(free -h 2>/dev/null || grep MemTotal /proc/meminfo)"
        fi
        exit 0
        ;;
    disk)
        THRESHOLD="$2"
        if [ -z "$THRESHOLD" ] || ! [ "$THRESHOLD" -eq "$THRESHOLD" ] 2>/dev/null; then
            echo "Error: Disk threshold must be an integer (1-100)" >&2
            exit 2
        fi
        if [ "$THRESHOLD" -lt 1 ] || [ "$THRESHOLD" -gt 100 ]; then
            echo "Error: Threshold must be between 1 and 100" >&2
            exit 2
        fi
        
        USAGE=$(df -P / | tail -n 1 | awk '{print $5}' | tr -d '%')
        echo "Current disk usage: ${USAGE}% (Threshold: ${THRESHOLD}%)"
        
        if [ "$USAGE" -ge "$THRESHOLD" ]; then
            echo "WARNING: Disk usage exceeds threshold!"
            exit 1
        fi
        exit 0
        ;;
    network)
        HOST="$2"
        if [ -z "$HOST" ]; then
            echo "Error: Target host is required" >&2
            exit 2
        fi
        echo "Checking network connectivity to $HOST..."
        if ping -c 2 -W 2 "$HOST" >/dev/null 2>&1; then
            echo "SUCCESS: Host $HOST is reachable"
            exit 0
        else
            echo "ERROR: Could not reach $HOST" >&2
            exit 1
        fi
        ;;
    help|""|--help|-h)
        show_help
        exit 0
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'" >&2
        show_help
        exit 2
        ;;
esac