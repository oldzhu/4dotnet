################################################################################
#
#   dotnetsdk 
#
################################################################################

DOTNETSDK_VERSION = latest 
ifeq ($(BR2_PACKAGE_DOTNETSDK_TARGET_ARCH),"ARM")
	DOTNETSDK_SOURCE = dotnet-sdk-$(DOTNETSDK_VERSION)-linux-arm.tar.gz
else
	DOTNETSDK_SOURCE = dotnet-sdk-$(DOTNETSDK_VERSION)-linux-arm64.tar.gz
endif
DOTNETSDK_SITE = https://dotnetcli.blob.core.windows.net/dotnet/Sdk/master

define DOTNETSDK_BUILD_CMDS
    ls -lR $(@D)
endef

define DOTNETSDK_INSTALL_TARGET_CMDS
    rsync -auH $(@D)/ $(TARGET_DIR)/root/dotnet/
    ls -lR $(TARGET_DIR)/root/dotnet
endef

$(eval $(generic-package))
