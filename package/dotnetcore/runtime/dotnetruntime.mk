################################################################################
#
## dotnetruntime 
#
#################################################################################

DOTNETRUNTIME_VERSION = origin/master
DOTNETRUNTIME_SITE = git://github.com/dotnet/runtime.git
DOTNETRUNTIME_INSTALL_STAGING = NO
DOTNETRUNTIME_INSTALL_TARGET = YES

define DOTNETRUNTIME_BUILD_CMDS

endef

define DOTNETRUNTIME_INSTALL_CMDS

endef

$(eval $(generic-package))
