#!/system/bin/sh
# Project Raco - Anya Flowstate Thermal Bypass Daemon (-274°C)
# Automatically enforces and locks thermal zones into disabled state when ANYA=1

while true; do
    ANYA_STATE=$(grep '^ANYA ' /data/ProjectRaco/raco.txt 2>/dev/null | awk '{print $2}' | tr -d '\r')
    if [ "$ANYA_STATE" = "1" ]; then
        # Force all thermal zones into disabled mode (-274000 mC in of-thermal)
        for tz in /sys/class/thermal/thermal_zone*; do
            if [ -f "$tz/mode" ]; then
                cur_mode=$(cat "$tz/mode" 2>/dev/null)
                if [ "$cur_mode" != "disabled" ]; then
                    chmod 0664 "$tz/mode" 2>/dev/null
                    echo disabled > "$tz/mode" 2>/dev/null
                fi
            fi
        done

        # Suppress userland thermal management services
        for svc in thermald mi_thermald thermal-engine; do
            if [ "$(getprop init.svc.$svc 2>/dev/null)" = "running" ]; then
                stop "$svc" 2>/dev/null
            fi
        done
    fi
    sleep 3
done
