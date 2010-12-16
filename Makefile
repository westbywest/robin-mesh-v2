#
# Copyright (C) 2010 Antonio Anselmi <tony.anselmi@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public
# License as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA
#


OWRT_DIST_SVN_PATH = openwrt/branches/backfire
OWRT_DIST_LOCAL_PATH = openwrt
OWRT_DIST_SVN_REV = $(shell svn info openwrt/ | tail -3 | head -1 | awk '{print $$4}')

PACKAGES = packages
PKG_LIST = coova-chilli fping iputils libmatrixssl-nothread nodogsplash olsrd uclibc++ wget-matrix
ROBIN_PKG = robin-v2

ROBIN_BUILD = $(shell svn info | tail -3 | head -1 | awk '{print $$4}')
		
PATCHES_PATH = patches
		
ifeq ($(ROBIN_BUILD),)
ROBIN_BUILD = 3
endif


all: owrt_checkout apply_owrt_patches add_packages build_fw

owrt_checkout:
	svn co svn://svn.openwrt.org/$(OWRT_DIST_SVN_PATH) $(OWRT_DIST_LOCAL_PATH)
	#svn co -r 23581 svn://svn.openwrt.org/$(OWRT_DIST_SVN_PATH) $(OWRT_DIST_LOCAL_PATH)
	touch $@

apply_owrt_patches:
	cp $(PATCHES_PATH)/network $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc/defconfig/bullet-m
	cp $(PATCHES_PATH)/network $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc/defconfig/generic
	cp $(PATCHES_PATH)/diag.sh $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc
	cp $(PATCHES_PATH)/990-add_poe_passthrough.patch $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/patches-2.6.32
	touch $@
#
add_packages:
	cd $(OWRT_DIST_LOCAL_PATH)/package && $(foreach PACKAGE, $(PKG_LIST), ln -sf ../../$(PACKAGES)/$(PACKAGE) .;)
	cd $(OWRT_DIST_LOCAL_PATH)/package && $(foreach PACKAGE, $(ROBIN_PKG), ln -sf ../../$(PACKAGES)/$(PACKAGE) .;)
	touch $@

versioning: 
	$(shell echo $(ROBIN_BUILD) > $(PACKAGES)/robin-v2/files/etc/robin_build)
	$(shell echo $(OWRT_DIST_SVN_REV) > $(PACKAGES)/robin-v2/files/etc/openwrt_svn_rev)
	touch $@

standard_config: versioning
	cp $(PATCHES_PATH)/robin-v2-default-config $(OWRT_DIST_LOCAL_PATH)/.config

build_fw: standard_config
	#cd $(OWRT_DIST_LOCAL_PATH) && make package/robin-v2-clean
	cd $(OWRT_DIST_LOCAL_PATH) && make

clean:
	$(shell [ -d "$(OWRT_DIST_LOCAL_PATH)" ] && cd $(OWRT_DIST_LOCAL_PATH) && make clean)
	rm -rf versioning add_packages
