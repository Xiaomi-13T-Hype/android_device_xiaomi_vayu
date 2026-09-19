#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_HAS_FM := true
TARGET_HAS_IR := true

# Inherit from sm8150-common
$(call inherit-product, device/xiaomi/sm8150-common/msmnile.mk)

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Camera
PRODUCT_PACKAGES += \
    libpiex_shim

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/camera/camera_cnf.txt:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera_cnf.txt

# Fingerprint
PRODUCT_PACKAGES += \
    libkeymaster_messages.vendor \
    vendor.xiaomi.hardware.fx.tunnel@1.0.vendor

# Init
$(call soong_config_set,xiaomi_msmnile,variant_lib,//$(LOCAL_PATH):libvariant_xiaomi_vayu)

# Overlays
PRODUCT_PACKAGES += \
    ApertureOverlayDevice \
    FrameworkResOverlayDevice \
    LineageSDKOverlayDevice \
    LineageSettingsOverlayDevice \
    SettingsOverlayDevice \
    SystemUIOverlayDevice

# QDCM
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/qdcm/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 30

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit from vendor blobs

#Maintainer
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lunaris.maintainer=Xiaomi-13T-Hype | モトテーパー


# SELinux policies for vayu

# Fingerprint vayu: only Xiaomi AIDL service (hardware/xiaomi)
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi

PRODUCT_PACKAGES_REMOVE += \
    android.hardware.biometrics.fingerprint-service.default \
    android.hardware.biometrics.fingerprint-service.lineage \
    android.hardware.biometrics.fingerprint@2.0-service \
    android.hardware.biometrics.fingerprint@2.1-service \
    android.hardware.biometrics.fingerprint@2.2-service.example \
    android.hardware.biometrics.fingerprint@2.3-service.xiaomi

# Proprietary vendor blobs
$(call inherit-product, vendor/xiaomi/vayu/vayu-vendor.mk)
