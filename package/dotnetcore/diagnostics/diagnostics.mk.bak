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

ifeq ($(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH),"ARM64")
define DIAGNOSTICS_CONFIGURE_CMDS
	patch -d $(@D)/eng -p0 -u -b build.sh -i $(DIAGNOSTICS_PKGDIR)/diag_eng_build.sh.mypatch
	cp $(HOST_DIR)/lib/gcc/aarch64-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $(STAGING_DIR)/usr/lib, \
# patch -u -b $(@D)/eng/cross/toolchain.cmake -i $(DIAGNOSTICS_PKGDIR)/toolchain.cmake.patch
# sed -i '557s/*/if\ [\ $${PIPESTATUS[0]}\ !=\ 0\ ];\ then/' $(@D)/eng/build.sh
endef
else
define DIAGNOSTICS_CONFIGURE_CMDS
        patch -d $(@D)/eng -p0 -u -b build.sh -i $(DIAGNOSTICS_PKGDIR)/diag_eng_build.sh.mypatch
        cp $(HOST_DIR)/lib/gcc/arm-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $(STAGING_DIR)/usr/lib
endef
endif

define DIAGNOSTICS_BUILD_CMDS
	$(DIAGNOSTICS_PKGDIR)/build_diag.sh $(BUILD_DIR) $(HOST_DIR) $(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH) $(@D) $(STAGING_DIR)
endef

ifeq ($(BR2_PACKAGE_DIAGNOSTICS_TARGET_ARCH),"ARM64")
define DIAGNOSTICS_INSTALL_TARGET_CMDS
	ls $(@D)
	mkdir -p $(TARGET_DIR)/root/.dotnet/sos
	cp $(@D)/artifacts/bin/Linux.aarch64.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
	$(TARGET_DIR)/root/.dotnet/sos
endef
else
define DIAGNOSTICS_INSTALL_TARGET_CMDS
        ls $(@D)
        mkdir -p $(TARGET_DIR)/root/.dotnet/sos
        cp $(@D)/artifacts/bin/Linux.arm.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
        $(TARGET_DIR)/root/.dotnet/sos
endef
endif

$(eval $(generic-package))
