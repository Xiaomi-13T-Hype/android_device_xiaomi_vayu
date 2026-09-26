# Leica Camera Mod for vayu
LOCAL_PATH := device/xiaomi/vayu/leica-camera

PRODUCT_PACKAGES += \
    MiuiCamera

# Framework jars
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/framework/vendor.xiaomi.hardware.misys-V1.0-java.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/vendor.xiaomi.hardware.misys-V1.0-java.jar \
    $(LOCAL_PATH)/framework/vendor.xiaomi.hardware.misys-V2.0-java.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/vendor.xiaomi.hardware.misys-V2.0-java.jar \
    $(LOCAL_PATH)/framework/vendor.xiaomi.hardware.misys.V3_0.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/vendor.xiaomi.hardware.misys.V3_0.jar \
    $(LOCAL_PATH)/framework/vendor.xiaomi.hardware.misys-V4.0-java.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/vendor.xiaomi.hardware.misys-V4.0-java.jar

# Permissions and config XMLs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/permissions/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-miuicamera.xml \
    $(LOCAL_PATH)/etc/permissions/vendor.xiaomi.hardware.misys-V1.0-java-permission.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/vendor.xiaomi.hardware.misys-V1.0-java-permission.xml \
    $(LOCAL_PATH)/etc/permissions/vendor.xiaomi.hardware.misys-V2.0-java-permission.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/vendor.xiaomi.hardware.misys-V2.0-java-permission.xml \
    $(LOCAL_PATH)/etc/permissions/vendor.xiaomi.hardware.misys.V3_0-permission.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/vendor.xiaomi.hardware.misys.V3_0-permission.xml \
    $(LOCAL_PATH)/etc/permissions/vendor.xiaomi.hardware.misys-V4.0-java-permission.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/vendor.xiaomi.hardware.misys-V4.0-java-permission.xml \
    $(LOCAL_PATH)/etc/default-permissions/miuicamera-permissions.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/miuicamera-permissions.xml \
    $(LOCAL_PATH)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml \
    $(LOCAL_PATH)/etc/public.libraries-xiaomi.txt:$(TARGET_COPY_OUT_SYSTEM)/etc/public.libraries-xiaomi.txt

# Shared libraries (32-bit & 64-bit)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/lib/libgui_shim_miuicamera.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libgui_shim_miuicamera.so \
    $(LOCAL_PATH)/lib64/libgui_shim_miuicamera.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libgui_shim_miuicamera.so \
    $(LOCAL_PATH)/lib64/libcamera_mianode_jni.xiaomi.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libcamera_mianode_jni.xiaomi.so \
    $(LOCAL_PATH)/lib64/vendor.xiaomi.hardware.campostproc@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/vendor.xiaomi.hardware.campostproc@1.0.so \
    $(LOCAL_PATH)/lib64/libcamera_algoup_jni.xiaomi.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libcamera_algoup_jni.xiaomi.so


# Properties required by Leica Camera
PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.mod_device=vayu_global
