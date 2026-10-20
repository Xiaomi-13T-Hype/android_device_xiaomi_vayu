#!/system/bin/sh

# Lunaris AOSP - Preinstalled Modules Setup (Project Raco & SUSFS)
LOG_TAG="PreinstalledModules"
log -t "$LOG_TAG" "Starting preinstalled modules check..."

# Wait until /data is decrypted and accessible
while [ ! -d /data/system ]; do
    sleep 2
done

# Ensure KernelSU folders and core binaries exist for sucompat
mkdir -p /data/adb/modules
mkdir -p /data/adb/ksu/bin
mkdir -p /data/adb/ksu/lib
chmod 755 /data/adb
chmod 755 /data/adb/modules
chmod 755 /data/adb/ksu
chmod 755 /data/adb/ksu/bin
chmod 755 /data/adb/ksu/lib

# Deploy ksud binary for kernel sucompat (/data/adb/ksud)
if [ ! -f /data/adb/ksud ]; then
    log -t "$LOG_TAG" "Deploying ksud binary to /data/adb/ksud..."
    if [ -f /product/bin/ksud ]; then
        cp -f /product/bin/ksud /data/adb/ksud
    elif [ -f /product/app/SukiSU/lib/arm64/libksud.so ]; then
        cp -f /product/app/SukiSU/lib/arm64/libksud.so /data/adb/ksud
    fi
    chmod 0755 /data/adb/ksud
    chown 0:0 /data/adb/ksud
fi

# Ensure ksud symlink in /data/adb/ksu/bin
if [ ! -e /data/adb/ksu/bin/ksud ] && [ -f /data/adb/ksud ]; then
    ln -sf /data/adb/ksud /data/adb/ksu/bin/ksud
fi

# Ensure libadbroot.so in /data/adb/ksu/lib/
if [ ! -f /data/adb/ksu/lib/libadbroot.so ] && [ -f /product/app/SukiSU/lib/arm64/libadbroot.so ]; then
    cp -f /product/app/SukiSU/lib/arm64/libadbroot.so /data/adb/ksu/lib/libadbroot.so
    chmod 0755 /data/adb/ksu/lib/libadbroot.so
    chown 0:0 /data/adb/ksu/lib/libadbroot.so
fi

# 1. Project Raco Module
if [ ! -d /data/adb/modules/ProjectRaco ]; then
    log -t "$LOG_TAG" "Installing Project Raco module to /data/adb/modules/ProjectRaco..."
    cp -af /product/etc/preinstalled_modules/ProjectRaco /data/adb/modules/
    chmod -R 755 /data/adb/modules/ProjectRaco
    rm -f /data/adb/modules/ProjectRaco/disable
else
    # Keep service scripts updated from product
    cp -f /product/etc/preinstalled_modules/ProjectRaco/service.sh /data/adb/modules/ProjectRaco/service.sh 2>/dev/null
    cp -af /product/etc/preinstalled_modules/ProjectRaco/CoreSys /data/adb/modules/ProjectRaco/ 2>/dev/null
    chmod -R 755 /data/adb/modules/ProjectRaco
fi

# Setup Project Raco persistent config
mkdir -p /data/ProjectRaco
chmod 755 /data/ProjectRaco
if [ ! -f /data/ProjectRaco/raco.txt ]; then
    log -t "$LOG_TAG" "Creating /data/ProjectRaco/raco.txt with SOC 2..."
    cp /product/etc/preinstalled_modules/ProjectRaco/raco.txt /data/ProjectRaco/raco.txt
    sed -i 's/^SOC .*/SOC 2/' /data/ProjectRaco/raco.txt
fi
if [ ! -f /data/ProjectRaco/WhitelistKillAll.txt ]; then
    cp /product/etc/preinstalled_modules/ProjectRaco/WhitelistKillAll.txt /data/ProjectRaco/WhitelistKillAll.txt
fi

# 2. SUSFS Module
if [ ! -d /data/adb/modules/susfs4ksu ]; then
    log -t "$LOG_TAG" "Installing SUSFS module to /data/adb/modules/susfs4ksu..."
    cp -af /product/etc/preinstalled_modules/susfs4ksu /data/adb/modules/
    chmod -R 755 /data/adb/modules/susfs4ksu
    cp -f /data/adb/modules/susfs4ksu/tools/ksu_susfs_arm64 /data/adb/ksu/bin/ksu_susfs
    cp -f /data/adb/modules/susfs4ksu/tools/sus_su_arm64 /data/adb/ksu/bin/sus_su
    chmod 755 /data/adb/ksu/bin/ksu_susfs
    chmod 755 /data/adb/ksu/bin/sus_su
    touch /data/adb/modules/susfs4ksu/update
fi

# 3. KernelSU Default Allowlist
if [ ! -f /data/adb/ksu/.allowlist ] && [ -f /product/etc/preinstalled_modules/ksu_allowlist ]; then
    log -t "$LOG_TAG" "Installing pre-configured KernelSU allowlist..."
    cp -f /product/etc/preinstalled_modules/ksu_allowlist /data/adb/ksu/.allowlist
    chmod 644 /data/adb/ksu/.allowlist
fi

# 4. N0Kontzzz Kernel Manager permissions & AppOps auto-grant
(
    while [ "$(getprop sys.boot_completed)" != "1" ]; do
        sleep 2
    done
    if pm list packages | grep -q "id.nkz.nokontzzzmanager"; then
        log -t "$LOG_TAG" "Configuring N0Kontzzz Kernel Manager runtime permissions & AppOps..."
        pm grant id.nkz.nokontzzzmanager android.permission.READ_EXTERNAL_STORAGE 2>/dev/null
        pm grant id.nkz.nokontzzzmanager android.permission.WRITE_EXTERNAL_STORAGE 2>/dev/null
        pm grant id.nkz.nokontzzzmanager android.permission.POST_NOTIFICATIONS 2>/dev/null
        appops set id.nkz.nokontzzzmanager SYSTEM_ALERT_WINDOW allow 2>/dev/null
        appops set id.nkz.nokontzzzmanager MANAGE_EXTERNAL_STORAGE allow 2>/dev/null
        appops set id.nkz.nokontzzzmanager GET_USAGE_STATS allow 2>/dev/null
        dumpsys deviceidle whitelist +id.nkz.nokontzzzmanager 2>/dev/null
    fi

    # 5. Direct Project Raco service launcher
    if ! pgrep -f "raco_service" >/dev/null 2>&1; then
        log -t "$LOG_TAG" "Starting Project Raco service..."
        if [ -f /data/adb/modules/ProjectRaco/service.sh ]; then
            sh /data/adb/modules/ProjectRaco/service.sh &
        elif [ -f /product/etc/preinstalled_modules/ProjectRaco/service.sh ]; then
            sh /product/etc/preinstalled_modules/ProjectRaco/service.sh &
        fi
    fi
) &

log -t "$LOG_TAG" "Preinstalled modules setup completed."
