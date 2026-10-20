#!/system/bin/sh

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

MODDIR=${0%/*}

# Execute the Raco core service in the background
/system/bin/linker64 $MODDIR/CoreSys/raco_service $MODDIR &

# Explicitly apply thermal bypass and daemon suppression if configured
KOBO_ENABLED=$(grep '^INCLUDE_KOBO ' /data/ProjectRaco/raco.txt | awk '{print $2}' | tr -d '\r')
if [ "$KOBO_ENABLED" = "1" ]; then
    /system/bin/linker64 $MODDIR/Compiled/kobo &
fi

ANYA_ENABLED=$(grep '^ANYA ' /data/ProjectRaco/raco.txt | awk '{print $2}' | tr -d '\r')
if [ "$ANYA_ENABLED" = "1" ]; then
    /system/bin/linker64 $MODDIR/Compiled/anya melfissa &
    for tz in /sys/class/thermal/thermal_zone*; do
        if [ -f "$tz/mode" ]; then
            chmod 0664 "$tz/mode" 2>/dev/null
            echo disabled > "$tz/mode" 2>/dev/null
        fi
    done
fi

# Launch Anya Flowstate thermal bypass daemon to lock -274°C permanently
if [ -f "$MODDIR/CoreSys/thermal_flowstate.sh" ]; then
    sh "$MODDIR/CoreSys/thermal_flowstate.sh" &
fi

# Ensure all 8 cores online permanently and unlock sysfs permissions
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable 2>/dev/null
echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable 2>/dev/null
echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/enable 2>/dev/null
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 2>/dev/null
echo 3 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 2>/dev/null
echo 1 > /sys/devices/system/cpu/cpu7/core_ctl/min_cpus 2>/dev/null
for i in 0 1 2 3 4 5 6 7; do
    echo 1 > /sys/devices/system/cpu/cpu$i/online 2>/dev/null
done
chmod 0664 /sys/devices/system/cpu/cpu*/cpufreq/scaling_* 2>/dev/null
chmod 0664 /sys/devices/system/cpu/cpufreq/policy*/scaling_* 2>/dev/null
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 2>/dev/null
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 2>/dev/null
chmod 0664 /sys/class/kgsl/kgsl-3d0/max_gpuclk 2>/dev/null



# Execute Ayunda Rusdi (Screen Modifiers) if configured
AYUNDA_RUSDI=$(grep '^AYUNDA_RUSDI ' /data/ProjectRaco/raco.txt | awk '{print $2}')
if [ "$AYUNDA_RUSDI" = "1" ]; then
    sh "$MODDIR/CoreSys/AyundaRusdi.sh" &
fi

# Forcefully auto-grant and enable the Game Assistant Accessibility Service
GAME_ASSISTANT=$(grep '^GAME_ASSISTANT ' /data/ProjectRaco/raco.txt | awk '{print $2}')
if [ "$GAME_ASSISTANT" = "1" ]; then
    su -c "settings put secure accessibility_enabled 1"
    su -c "CURRENT=\$(settings get secure enabled_accessibility_services); if [ \"\$CURRENT\" = \"null\" ] || [ -z \"\$CURRENT\" ]; then settings put secure enabled_accessibility_services com.kanagawa.yamada.project.raco/.GameAssistantService; else echo \"\$CURRENT\" | grep -q \"com.kanagawa.yamada.project.raco/.GameAssistantService\" || settings put secure enabled_accessibility_services \"\$CURRENT:com.kanagawa.yamada.project.raco/.GameAssistantService\"; fi" &
fi

# RSWAP Boot Initialization
RSWAP_ENABLED=$(grep '^RSWAP ' /data/ProjectRaco/raco.txt | awk '{print $2}' | tr -d '\r')
if [ "$RSWAP_ENABLED" = "1" ]; then
    if [ ! -f /data/ProjectRaco/RSWAP ]; then
        RSWAP_SIZE=$(grep '^RSWAP_SIZE ' /data/ProjectRaco/raco.txt | awk '{print $2}' | tr -d '\r')
        if [ -z "$RSWAP_SIZE" ]; then RSWAP_SIZE="4"; fi
        fallocate -l ${RSWAP_SIZE}G /data/ProjectRaco/RSWAP
    fi
    if [ -f /data/ProjectRaco/RSWAP ]; then
        chmod 0600 /data/ProjectRaco/RSWAP
        mkswap /data/ProjectRaco/RSWAP
        /system/bin/linker64 $MODDIR/Compiled/rswap on
        echo 100 > /proc/sys/vm/swappiness
        echo $(( $(cat /proc/sys/vm/min_free_kbytes) * 12 / 10 )) > /proc/sys/vm/min_free_kbytes
    fi
fi

# Wait briefly to ensure services are started
sleep 2

# Send Startup Notification
SILENT_NOTIF=$(grep '^SILENT_NOTIF ' /data/ProjectRaco/raco.txt | awk '{print $2}')
if [ "$SILENT_NOTIF" = "0" ]; then
    LEGACY_NOTIF=$(grep '^LEGACY_NOTIF ' /data/ProjectRaco/raco.txt | awk '{print $2}')
    if [ "$LEGACY_NOTIF" = "1" ]; then
        su -lp 2000 -c "cmd notification post -S bigtext -t 'Project Raco' 'TagRaco' 'Project Raco - オンライン'" &
    else
        su -lp 2000 -c "cmd notification post -S bigtext -t 'Project Raco' -i file:///data/local/tmp/logo.png -I file:///data/local/tmp/logo.png 'TagRaco' 'Project Raco - オンライン'" &
    fi
fi