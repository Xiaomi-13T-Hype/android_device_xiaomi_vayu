#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8150-common
include device/xiaomi/sm8150-common/BoardConfigCommon.mk

# Device Path
DEVICE_PATH := device/xiaomi/vayu

# Assert
TARGET_OTA_ASSERT_DEVICE := vayu,msmnile

# Display
TARGET_SCREEN_DENSITY := 440

# Kernel
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/extracted/kernel
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
TARGET_FORCE_PREBUILT_KERNEL := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_INCLUDE_RECOVERY_DTBO := false
BOARD_KERNEL_SEPARATED_DTBO := false

# VINTF
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Disable Bazel for kernel build (use Make)
TARGET_KERNEL_USE_BAZEL := false
BOARD_SEPOLICY_DIRS += device/xiaomi/vayu/sepolicy

# Vendor prop from sm8150-common (inherited)
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop


# Allow prebuilt ELF libraries via PRODUCT_COPY_FILES
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true


# VINTF framework compatibility matrix for vayu-specific HALs
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/vintf/vayu_framework_compatibility_matrix.xml


