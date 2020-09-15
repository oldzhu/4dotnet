################################################################################
#
# lldb
#
################################################################################

LLDB_VERSION = origin/master
LLDB_SITE = git://github.com/llvm/llvm-project.git
LLDB_SUPPORTS_IN_SOURCE_BUILD = NO
#LLDB_INSTALL_STAGING = YES
LLDB_SUBDIR=llvm

LLDB_MAKE_OPTS = lldb
LLDB_MAKE_OPTS += lldb-server

#LLDB_INSTALL_OPTS += lldb
#LLDB_INSTALL_OPTS += lldb-server
#LLDB_INSTALL_STAGING_OPTS += lldb
#LLDB_INSTALL_STAGING_OPTS += lldb-server
#LLDB_INSTALL_TARGET_OPTS += lldb
#LLDB_INSTALL_TARGET_OPTS += lldb-server

# LLVM >= 9.0 can use python3 to build.
HOST_LLDB_DEPENDENCIES = host-python3
LLDB_DEPENDENCIES = host-lldb

HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_PROJECTS="clang;lldb"
LLDB_CONF_OPTS += -DLLVM_ENABLE_PROJECTS="clang;lldb"

HOST_LLDB_CONF_OPTS += -DLLVM_CCACHE_BUILD=$(if $(BR2_CCACHE),ON,OFF)
LLDB_CONF_OPTS += -DLLVM_CCACHE_BUILD=$(if $(BR2_CCACHE),ON,OFF)

# This option prevents AddLLVM.cmake from adding $ORIGIN/../lib to
# binaries. Otherwise, llvm-config (host variant installed in STAGING)
# will try to use target's libc.
HOST_LLDB_CONF_OPTS += -DCMAKE_INSTALL_RPATH="$(HOST_DIR)/lib"

# Get target architecture
LLDB_TARGET_ARCH = $(call qstrip,$(BR2_PACKAGE_LLDB_TARGET_ARCH))

# Build backend for target architecture. This include backends like AMDGPU.
LLDB_TARGETS_TO_BUILD = $(LLDB_TARGET_ARCH)
HOST_LLDB_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(LLDB_TARGETS_TO_BUILD))"
LLDB_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(LLDB_TARGETS_TO_BUILD))"

# LLVM target to use for native code generation. This is required for JIT generation.
# It must be set to LLVM_TARGET_ARCH for host and target, otherwise we get
# "No available targets are compatible for this triple" with llvmpipe when host
# and target architectures are different.
HOST_LLDB_CONF_OPTS += -DLLVM_TARGET_ARCH=$(LLDB_TARGET_ARCH)
LLDB_CONF_OPTS += -DLLVM_TARGET_ARCH=$(LLDB_TARGET_ARCH)

# Use native llvm-tblgen from host-llvm (needed for cross-compilation)
LLDB_CONF_OPTS += -DLLVM_TABLEGEN=$(HOST_DIR)/bin/llvm-tblgen
LLDB_CONF_OPTS += -DLLDB_TABLEGEN=$(HOST_LLDB_BUILDDIR)/bin/lldb-tblgen
LLDB_CONF_OPTS += -DCLANG_TABLEGEN=$(HOST_LLDB_BUILDDIR)/bin/clang-tblgen

# Use native llvm-config from host-llvm (needed for cross-compilation)
LLDB_CONF_OPTS += -DLLVM_CONFIG_PATH=$(HOST_DIR)/bin/llvm-config

# BUILD_SHARED_LIBS has a misleading name. It is in fact an option for
# LLVM developers to build all LLVM libraries as separate shared libraries.
# For normal use of LLVM, it is recommended to build a single
# shared library, which is achieved by BUILD_SHARED_LIBS=OFF and
# LLVM_BUILD_LLVM_DYLIB=ON.
HOST_LLDB_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
LLDB_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

# Generate libLLVM.so. This library contains a default set of LLVM components
# that can be overwritten with "LLVM_DYLIB_COMPONENTS". The default contains
# most of LLVM and is defined in "tools/llvm-shlib/CMakelists.txt".
HOST_LLDB_CONF_OPTS += -DLLVM_BUILD_LLVM_DYLIB=ON
LLDB_CONF_OPTS += -DLLVM_BUILD_LLVM_DYLIB=ON

# LLVM_BUILD_LLVM_DYLIB to ON. We need to enable this option for the
# host as llvm-config for the host will be used in STAGING_DIR by packages
# linking against libLLVM and if this option is not selected, then llvm-config
# does not work properly. For example, it assumes that LLVM is built statically
# and cannot find libLLVM.so.
HOST_LLDB_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON
LLDB_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON

LLDB_CONF_OPTS += -DCMAKE_CROSSCOMPILING=1

# Disabled for the host since no host-libedit.
# Fall back to "Simple fgets-based implementation" of llvm line editor.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF

# We want to install llvm libraries and modules.
HOST_LLDB_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
LLDB_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# No backtrace package in Buildroot.
# https://documentation.backtrace.io
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=OFF

# Enable signal handlers overrides support.
HOST_LLDB_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON
LLDB_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON

# Disable ffi for now.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF

# Disable terminfo database (needs ncurses libtinfo.so)
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF

# Enable thread support
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON
LLDB_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON

# Enable optional host-zlib support for LLVM Machine Code (llvm-mc) to add
# compression/uncompression capabilities.
# Not needed on the target.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_ZLIB=ON
HOST_LLDB_DEPENDENCIES += host-zlib
LLDB_CONF_OPTS += -DLLVM_ENABLE_ZLIB=OFF

# libxml2 can be disabled as it is used for LLVM Windows builds where COFF
# files include manifest info
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBXML2=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBXML2=OFF

# Disable optional Z3Prover since there is no such package in Buildroot.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_Z3_SOLVER=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_Z3_SOLVER=OFF

# We don't use llvm for static only build, so enable PIC
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_PIC=ON
LLDB_CONF_OPTS += -DLLVM_ENABLE_PIC=ON

# Default is Debug build, which requires considerably more disk space and
# build time. Release build is selected for host and target because the linker
# can run out of memory in Debug mode.
HOST_LLDB_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LLDB_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Disable C++1y (ISO C++ 2014 standard)
# Disable C++1z (ISO C++ 2017 standard)
# Compile llvm with the C++11 (ISO C++ 2011 standard) which is the fallback.
HOST_LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_CXX1Y=OFF \
	-DLLVM_ENABLE_CXX1Z=OFF
LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_CXX1Y=OFF \
	-DLLVM_ENABLE_CXX1Z=OFF

# Disabled, requires sys/ndir.h header
# Disable debug in module
HOST_LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF
LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF

# Don't change the standard library to libc++.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF

# Don't use lld as a linker.
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF

# Generate code for the target. LLVM selects a target by looking at the
# toolchain tuple
HOST_LLDB_CONF_OPTS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(GNU_TARGET_NAME)
LLDB_CONF_OPTS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(GNU_TARGET_NAME)

# LLVM_HOST_TRIPLE has a misleading name, it is in fact the triple of the
# system where llvm is going to run on. We need to specify triple for native
# code generation on the target.
# This solves "No available targets are compatible for this triple" with llvmpipe
LLDB_CONF_OPTS += -DLLVM_HOST_TRIPLE=$(GNU_TARGET_NAME)

# The Go bindings have no CMake rules at the moment, but better remove the
# check preventively. Building the Go and OCaml bindings is yet unsupported.
HOST_LLDB_CONF_OPTS += \
	-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND \
	-DOCAMLFIND=OCAMLFIND-NOTFOUND

# Builds a release host tablegen that gets used during the LLVM build.
HOST_LLDB_CONF_OPTS += -DLLVM_OPTIMIZED_TABLEGEN=ON

# Keep llvm utility binaries for the host. llvm-tblgen is built anyway as
# CMakeLists.txt has add_subdirectory(utils/TableGen) unconditionally.
HOST_LLDB_CONF_OPTS += \
	-DLLVM_BUILD_UTILS=ON \
	-DLLVM_INCLUDE_UTILS=ON \
	-DLLVM_INSTALL_UTILS=ON
LLDB_CONF_OPTS += \
	-DLLVM_BUILD_UTILS=OFF \
	-DLLVM_INCLUDE_UTILS=OFF \
	-DLLVM_INSTALL_UTILS=OFF

HOST_LLDB_CONF_OPTS += \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_BUILD_TOOLS=ON

# We need to activate LLVM_INCLUDE_TOOLS, otherwise it does not generate
# libLLVM.so
LLDB_CONF_OPTS += \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_BUILD_TOOLS=OFF

ifeq ($(BR2_PACKAGE_LLVM_RTTI),y)
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_RTTI=ON
LLDB_CONF_OPTS += -DLLVM_ENABLE_RTTI=ON
else
HOST_LLDB_CONF_OPTS += -DLLVM_ENABLE_RTTI=OFF
LLDB_CONF_OPTS += -DLLVM_ENABLE_RTTI=OFF
endif

# Compiler-rt not in the source tree.
# llvm runtime libraries are not in the source tree.
# Polly is not in the source tree.
HOST_LLDB_CONF_OPTS += \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
	-DLLVM_BUILD_RUNTIME=OFF \
	-DLLVM_INCLUDE_RUNTIMES=OFF \
	-DLLVM_POLLY_BUILD=OFF
LLDB_CONF_OPTS += \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
	-DLLVM_BUILD_RUNTIME=OFF \
	-DLLVM_INCLUDE_RUNTIMES=OFF \
	-DLLVM_POLLY_BUILD=OFF

HOST_LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_WERROR=OFF
LLDB_CONF_OPTS += \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_WERROR=OFF

HOST_LLDB_CONF_OPTS += \
	-DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_BUILD_DOCS=OFF \
	-DLLVM_BUILD_TESTS=OFF \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_OCAMLDOC=OFF \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_GO_TESTS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF
LLDB_CONF_OPTS += \
	-DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_BUILD_DOCS=OFF \
	-DLLVM_BUILD_TESTS=OFF \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_OCAMLDOC=OFF \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_GO_TESTS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF

define LLDB_INSTALL_TARGET_CMDS
     $(INSTALL) -D -m 0755 $(LLDB_BUILDDIR)/bin/lldb $(TARGET_DIR)/usr/bin
     $(INSTALL) -D -m 0755 $(LLDB_BUILDDIR)/bin/lldb-server  $(TARGET_DIR)/usr/bin
     $(INSTALL) -D -m 0755 $(LLDB_BUILDDIR)/lib/libLLVM*.so $(TARGET_DIR)/usr/lib
     $(INSTALL) -D -m 0755 $(LLDB_BUILDDIR)/lib/libclang-cpp.so $(TARGET_DIR)/usr/lib
     $(INSTALL) -D -m 0755 $(LLDB_BUILDDIR)/lib/liblldb.so $(TARGET_DIR)/usr/lib
#     ln -rsf $(TARGET_DIR)/usr/lib/libclang-cpp.so.11git libclang-cpp.so
#     ln -rsf $(TARGET_DIR)/usr/lib/liblldb.so.11.0.0git liblldb.so.11git
#     ln -rsf $(TARGET_DIR)/usr/lib/liblldb.so.11.0.0git liblldb.so
endef

# Copy llvm-config (host variant) to STAGING_DIR
# llvm-config (host variant) returns include and lib directories
# for the host if it's installed in host/bin:
# output/host/bin/llvm-config --includedir
# output/host/include
# When installed in STAGING_DIR, llvm-config returns include and lib
# directories from STAGING_DIR.
# output/staging/usr/bin/llvm-config --includedir
# output/staging/usr/include
define HOST_LLDB_COPY_LLVM_CONFIG_TO_STAGING_DIR
	$(INSTALL) -D -m 0755 $(HOST_DIR)/bin/llvm-config \
		$(STAGING_DIR)/usr/bin/llvm-config
endef
HOST_LLDB_POST_INSTALL_HOOKS = HOST_LLDB_COPY_LLVM_CONFIG_TO_STAGING_DIR

# By default llvm-tblgen is built and installed on the target but it is
# not necessary. Also erase LLVMHello.so from /usr/lib
define LLDB_DELETE_LLVM_TBLGEN_TARGET
	rm -f $(TARGET_DIR)/usr/lib/liblldb.so.11.0.0git
endef
LLDB_POST_INSTALL_TARGET_HOOKS = LLDB_DELETE_LLVM_TBLGEN_TARGET

$(eval $(cmake-package))
$(eval $(host-cmake-package))
