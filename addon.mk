# Copy files

define addon-copy-to-system
$(shell python "$(LOCAL_PATH)/copy_files.py" "$(LOCAL_PATH)/$(1)/" "$(2)" "$(PLATFORM_SDK_VERSION)")
endef


PRODUCT_COPY_FILES += $(call addon-copy-to-system,system,bin) \

PRODUCT_COPY_FILES += $(call addon-copy-to-system,system,lib) \
