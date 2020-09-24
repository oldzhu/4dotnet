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

define DIAGNOSTICS_BUILD_CMDS
export PATH=$(BUILD_DIR)/host-lldb-origin_master/llvm/buildroot-build/bin:$$PATH:$(HOST_DIR)/bin;export TOOLCHAIN=arm-buildroot-linux-gnueabihf;$(@D)/build.sh --architecture $(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH) --rootfs  $(STAGING_DIR) /p:EnableSourceLink=false
endef

define DIAGNOSTICS_INSTALL_TARGET_CMDS
	ls $(@D)
	mkdir -p $(TARGET_DIR)/root/.dotnet/sos
	cp $(@D)/artifacts/bin/Linux.arm.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} $(TARGET_DIR)/root/.dotnet/sos
endef

$(eval $(generic-package))
