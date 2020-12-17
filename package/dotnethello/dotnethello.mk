###############################################################################
#
## dotnethello 
#
#################################################################################

DOTNETHELLO_VERSION = 1.0
DOTNETHELLO_SITE = ~/4dotnet/package/dotnethello/src
DOTNETHELLO_SITE_METHOD = local
DOTNETHELLO_INSTALL_STAGING = NO
DOTNETHELLO_INSTALL_TARGET = YES

define DOTNETHELLO_CONFIGURE_CMDS
	$(DOTNETHELLO_PKGDIR)/config_dotnethello.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETHELLO_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETHELLO_PKGDIR) $(TARGET_DIR)
endef

define DOTNETHELLO_BUILD_CMDS
	$(DOTNETHELLO_PKGDIR)/build_dotnethello.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETHELLO_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETHELLO_PKGDIR) $(TARGET_DIR)
endef

define DOTNETHELLO_INSTALL_TARGET_CMDS
	$(DOTNETHELLO_PKGDIR)/install_dotnethello.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETHELLO_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNETHELLO_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
