################################################################################
#
## dotnet-monitor 
#
#################################################################################

ifeq ($(BR2_PACKAGE_DOTNET-MONITOR_CUSTOM_GIT),y)
#DOTNET-MONITOR_VERSION = origin/master
DOTNET-MONITOR_VERSION = $(call qstrip,$(BR2_PACKAGE_DOTNET-MONITOR_CUSTOM_REPO_VERSION))
DOTNET-MONITOR_SITE = $(call qstrip,$(BR2_PACKAGE_DOTNET-MONITOR_CUSTOM_REPO_URL))
DOTNET-MONITOR_SITE_METHOD=git 
else
DOTNET-MONITOR_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_PACKAGE_DOTNET-MONITOR_CUSTOM_TARBALL_LOCATION))
DOTNET-MONITOR_SOURCE = $(notdir $(DOTNET-MONITOR_CUSTOM_TARBALL_LOCATION))
DOTNET-MONITOR_VERSION = $(basename $(basename $(DOTNET-MONITOR_SOURCE)))
DOTNET-MONITOR_SITE = $(patsubst %/,%,$(dir $(DOTNET-MONITOR_CUSTOM_TARBALL_LOCATION)))
endif


DOTNET-MONITOR_INSTALL_TARGET = YES

DOTNET-MONITOR_DEPENDENCIES += dotnetruntime

define DOTNET-MONITOR_CONFIGURE_CMDS
	$(DOTNET-MONITOR_PKGDIR)/config_dotnet-monitor.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNET-MONITOR_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNET-MONITOR_PKGDIR) $(TARGET_DIR)
endef

define DOTNET-MONITOR_BUILD_CMDS
$(DOTNET-MONITOR_PKGDIR)/build_dotnet-monitor.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNET-MONITOR_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNET-MONITOR_PKGDIR) $(TARGET_DIR)
endef

define DOTNET-MONITOR_INSTALL_TARGET_CMDS
	$(DOTNET-MONITOR_PKGDIR)/install_dotnet-monitor.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DOTNET-MONITOR_TARGET_ARCH) $(@D) $(STAGING_DIR) $(DOTNET-MONITOR_PKGDIR) $(TARGET_DIR)
endef

$(eval $(generic-package))
