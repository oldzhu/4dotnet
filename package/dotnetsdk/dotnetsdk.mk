################################################################################
#
#   dotnetsdk 
#
################################################################################

DOTNETSDK_VERSION = master

ifeq ($(DOTNETSDK_VERSION),master)
ifeq ($(BR2_PACKAGE_DOTNETSDK_TARGET_ARCH),"ARM")
	DOTNETSDK_SOURCE = dotnet-sdk-linux-arm.tar.gz
else
	DOTNETSDK_SOURCE = dotnet-sdk-linux-arm64.tar.gz
endif
else
ifeq ($(BR2_PACKAGE_DOTNETSDK_TARGET_ARCH),"ARM")
	DOTNETSDK_SOURCE = dotnet-sdk-latest-linux-arm.tar.gz
else
	DOTNETSDK_SOURCE = dotnet-sdk-latest-linux-arm64.tar.gz
endif
endif

ifeq ($(DOTNETSDK_VERSION),master)
	DOTNETSDK_SITE = https://aka.ms/dotnet/net5/dev/Sdk
else
	DOTNETSDK_SITE = https://dotnetcli.blob.core.windows.net/dotnet/Sdk/release/$(DOTNETSDK_VERSION)
endif

define DOTNETSDK_BUILD_CMDS
    $(DOTNETSDK_PKGDIR)/syncsrc.sh $(@D)
#    ls -lR $(@D)
endef

define DOTNETSDK_INSTALL_TARGET_CMDS
    rsync -auH --exclude '.stamp_*' --exclude '.files-*' --exclude '.applied_patches_list' --exclude 'src' $(@D)/ $(TARGET_DIR)/root/dotnet/
    rsync -auH --exclude 'installer' --exclude 'mono' --exclude 'tests' $(@D)/src/src $(TARGET_DIR)/root/dotnet/
    echo 'PermitRootLogin yes' >> $(TARGET_DIR)/etc/ssh/sshd_config
    echo 'PermitEmptyPasswords yes' >> $(TARGET_DIR)/etc/ssh/sshd_config
#    ls -lR $(TARGET_DIR)/root/dotnet
endef

$(eval $(generic-package))
