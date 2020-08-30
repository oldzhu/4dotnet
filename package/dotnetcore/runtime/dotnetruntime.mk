################################################################################
#
## dotnetruntime 
#
#################################################################################

DIAGNOSTICS_VERSION = origin/master
DIAGNOSTICS_SOURCE =
DIAGNOSTICS_SITE = git://github.com/dotnet/runtime.git
DIAGNOSTICS_INSTALL_STAGING = NO
DIAGNOSTICS_INSTALL_TARGET = YES

define DIAGNOSTICS_BUILD_CMDS

endif

define DIAGNOSTICS_INSTALL_TARGET_CMDS

endif

$(eval $(generic-package))
