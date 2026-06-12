################################################################################
#
# gdb-sos — GDB SOS plugin for .NET Core managed debugging
#
################################################################################

GDB_SOS_VERSION = origin/main
GDB_SOS_SITE = https://github.com/oldzhu/gdbsos.git
GDB_SOS_SITE_METHOD = git

GDB_SOS_DEPENDENCIES += gdb
GDB_SOS_DEPENDENCIES += dotnetruntime

define GDB_SOS_BUILD_CMDS
	$(GDB_SOS_PKGDIR)/build_gdbsos.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETRUNTIME_TARGET_ARCH) $(@D) $(STAGING_DIR) $(GDB_SOS_PKGDIR) $(TARGET_DIR)
endef

define GDB_SOS_INSTALL_TARGET_CMDS
	$(GDB_SOS_PKGDIR)/install_gdbsos.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNETRUNTIME_TARGET_ARCH) $(@D) $(STAGING_DIR) $(GDB_SOS_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
