################################################################################
#
## diagnostics 
#
#################################################################################

DIAGNOSTICS_VERSION = origin/master
#DIAGNOSTICS_SOURCE =
DIAGNOSTICS_SITE = git://github.com/dotnet/diagnostics.git
#DIAGNOSTICS_SITE_METHOD = git
#DIAGNOSTICS_INSTALL_STAGING = YES 
DIAGNOSTICS_INSTALL_TARGET = YES

DIAGNOSTICS_DEPENDENCIES += lldb

define DIAGNOSTICS_CONFIGURE_CMDS
	$(DIAGNOSTICS_PKGDIR)/config_diag.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DIAGNOSTICS_PKGDIR) $(TARGET_DIR)
endef

define DIAGNOSTICS_BUILD_CMDS
$(DIAGNOSTICS_PKGDIR)/build_diag.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DIAGNOSTICS_PKGDIR) $(TARGET_DIR)
endef

define DIAGNOSTICS_INSTALL_TARGET_CMDS
	$(DIAGNOSTICS_PKGDIR)/install_diag.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DIAGNOSTICS_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
