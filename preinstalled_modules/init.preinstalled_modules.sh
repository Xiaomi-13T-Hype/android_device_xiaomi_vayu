#!/system/bin/sh

# Lunaris AOSP - Preinstalled Modules Setup (Project Raco & SUSFS)
LOG_TAG="PreinstalledModules"
log -t "$LOG_TAG" "Starting preinstalled modules check..."

# Wait until /data is decrypted and accessible
while [ ! -d /data/system ]; do
    sleep 2
done

# Ensure KernelSU folders exist
mkdir -p /data/adb/modules
mkdir -p /data/adb/ksu/bin
chmod 755 /data/adb
chmod 755 /data/adb/modules
chmod 755 /data/adb/ksu
chmod 755 /data/adb/ksu/bin

# 1. Project Raco Module
if [ ! -d /data/adb/modules/ProjectRaco ]; then
    log -t "$LOG_TAG" "Installing Project Raco module to /data/adb/modules/ProjectRaco..."
    cp -af /product/etc/preinstalled_modules/ProjectRaco /data/adb/modules/
    chmod -R 755 /data/adb/modules/ProjectRaco
    touch /data/adb/modules/ProjectRaco/update
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

log -t "$LOG_TAG" "Preinstalled modules setup completed."
