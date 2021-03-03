###############################################################################
#
## dotnetruntime 
#
#################################################################################

#DOTNETRUNTIME_VERSION = origin/master
DOTNETRUNTIME_VERSION = origin/main
DOTNETRUNTIME_SITE = git://github.com/dotnet/runtime.git
#DOTNETRUNTIME_INSTALL_STAGING = NO
DOTNETRUNTIME_INSTALL_TARGET = YES

DOTNETRUNTIME_DEPENDENCIES += lldb
DOTNETRUNTIME_DEPENDENCIES += diagnostics

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
