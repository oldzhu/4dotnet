################################################################################
#
## clrmd 
#
#################################################################################

ifeq ($(BR2_PACKAGE_CLRMD_CUSTOM_GIT),y)
#CLRMD_VERSION = origin/master
CLRMD_VERSION = $(call qstrip,$(BR2_PACKAGE_CLRMD_CUSTOM_REPO_VERSION))
CLRMD_SITE = $(call qstrip,$(BR2_PACKAGE_CLRMD_CUSTOM_REPO_URL))
else
CLRMD_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_PACKAGE_CLRMD_CUSTOM_TARBALL_LOCATION))
CLRMD_SOURCE = $(notdir $(CLRMD_CUSTOM_TARBALL_LOCATION))
CLRMD_VERSION = $(basename $(basename $(CLRMD_SOURCE)))
CLRMD_SITE = $(patsubst %/,%,$(dir $(CLRMD_CUSTOM_TARBALL_LOCATION)))
endif


CLRMD_INSTALL_TARGET = YES

CLRMD_DEPENDENCIES += lldb
CLRMD_DEPENDENCIES += dotnetruntime

define CLRMD_CONFIGURE_CMDS
	$(CLRMD_PKGDIR)/config_clrmd.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_CLRMD_TARGET_ARCH) $(@D) $(STAGING_DIR) $(CLRMD_PKGDIR) $(TARGET_DIR)
endef

define CLRMD_BUILD_CMDS
$(CLRMD_PKGDIR)/build_clrmd.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_CLRMD_TARGET_ARCH) $(@D) $(STAGING_DIR) $(CLRMD_PKGDIR) $(TARGET_DIR)
endef

define CLRMD_INSTALL_TARGET_CMDS
	$(CLRMD_PKGDIR)/install_clrmd.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_CLRMD_TARGET_ARCH) $(@D) $(STAGING_DIR) $(CLRMD_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
