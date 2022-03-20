###############################################################################
#
## dotnetruntime 
#
#################################################################################
ifeq ($(BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_GIT),y)
#DOTNETRUNTIME_VERSION = origin/master
DOTNETRUNTIME_VERSION = $(call qstrip,$(BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_REPO_VERSION))
DOTNETRUNTIME_SITE = $(call qstrip,$(BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_REPO_URL))
DOTNETRUNTIME_SITE_METHOD=git
else
DOTNETRUNTIME_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_TARBALL_LOCATION))
DOTNETRUNTIME_SOURCE = $(notdir $(DOTNETRUNTIME_CUSTOM_TARBALL_LOCATION))
DOTNETRUNTIME_VERSION = $(basename $(basename $(DOTNETRUNTIME_SOURCE)))
DOTNETRUNTIME_SITE = $(patsubst %/,%,$(dir $(DOTNETRUNTIME_CUSTOM_TARBALL_LOCATION)))
endif

#DOTNETRUNTIME_INSTALL_STAGING = NO
DOTNETRUNTIME_INSTALL_TARGET = YES

DOTNETRUNTIME_DEPENDENCIES += lldb

define DOTNETRUNTIME_CONFIGURE_CMDS
	$(DOTNETRUNTIME_PKGDIR)/config_dotnetruntime.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETRUNTIME_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETRUNTIME_PKGDIR) $(TARGET_DIR)
endef

define DOTNETRUNTIME_BUILD_CMDS
	$(DOTNETRUNTIME_PKGDIR)/build_dotnetruntime.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETRUNTIME_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETRUNTIME_PKGDIR) $(TARGET_DIR)
endef

define DOTNETRUNTIME_INSTALL_TARGET_CMDS
	$(DOTNETRUNTIME_PKGDIR)/install_dotnetruntime.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETRUNTIME_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETRUNTIME_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
