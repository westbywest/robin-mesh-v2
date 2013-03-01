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

#OWRT_DIST_SVN_PATH = openwrt/trunk
OWRT_DIST_SVN_PATH = openwrt/branches/attitude_adjustment
#OWRT_DIST_REV = 29709
#OWRT_DIST_REV = 31639
OWRT_DIST_REV = 35267

OWRT_DIST_LOCAL_PATH = openwrt
OWRT_DIST_SVN_REV = $(shell svn info openwrt/ | tail -3 | head -1 | awk '{print $$4}')

PACKAGES = packages
PACKAGES_LOCAL_PATH = packages-build

#All packages worth using already included in OpenWRT AA
#PKG_LIST = coova-chilli fping iputils libmatrixssl-nothread nodogsplash olsrd uclibc++ wget-matrix
ROBIN_PKG = robin-v2 robin-v2-checkin

ROBIN_BUILD = $(shell svn info | tail -3 | head -1 | awk '{print $$4}')
		
PATCHES_PATH = patches
		
ifeq ($(ROBIN_BUILD),)
ROBIN_BUILD = 3
endif


all: owrt_checkout owrt_patches robin_checkout build_fw

owrt_checkout:
	svn co -r $(OWRT_DIST_REV) svn://svn.openwrt.org/$(OWRT_DIST_SVN_PATH) $(OWRT_DIST_LOCAL_PATH)
	touch $@

owrt_patches:
	#cp -v $(PATCHES_PATH)/network $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc/defconfig/bullet-m
	#cp -v $(PATCHES_PATH)/network $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc/defconfig/generic
	#cp -v $(PATCHES_PATH)/diag.sh $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/base-files/etc
	#cp -v $(PATCHES_PATH)/990-add_poe_passthrough.patch $(OWRT_DIST_LOCAL_PATH)/target/linux/ar71xx/patches-2.6.39
	cp -v $(PATCHES_PATH)/890_ath9k_advertize_beacon_int_infra_match.patch $(OWRT_DIST_LOCAL_PATH)/package/mac80211/patches/
	cp -v $(PATCHES_PATH)/891_ath9k_htc_advertize_allowed_vif_combinations.patch $(OWRT_DIST_LOCAL_PATH)/package/mac80211/patches/
	cp -v $(PATCHES_PATH)/892_ath9k_htc_remove_interface_combination_specific_checks.patch $(OWRT_DIST_LOCAL_PATH)/package/mac80211/patches/
	cp -v $(PATCHES_PATH)/060-tcp-ecn-dont-delay-ACKS-after-CE.patch $(OWRT_DIST_LOCAL_PATH)/target/linux/generic/patches-3.3
	cp -v $(PATCHES_PATH)/061-fq_codel-dont-reinit-flow-state.patch $(OWRT_DIST_LOCAL_PATH)/target/linux/generic/patches-3.3
	cp -v $(PATCHES_PATH)/900-leds-gpio-asm-include.patch $(OWRT_DIST_LOCAL_PATH)/target/linux/atheros/patches-3.3

	#copy passwd so default root pwd = r0b1nm35h
	mkdir -p $(OWRT_DIST_LOCAL_PATH)/files/etc
	cp -v $(PATCHES_PATH)/shadow $(OWRT_DIST_LOCAL_PATH)/files/etc
	chmod 644 $(OWRT_DIST_LOCAL_PATH)/files/etc/shadow
	touch $@
#
robin_checkout:
#	cp -fR $(PACKAGES)/ $(PACKAGES_LOCAL_PATH)

	if ! grep -q robin $(OWRT_DIST_LOCAL_PATH)/feeds.conf ; then
		$(shell echo "adding robin package feed ...")
		cd $(OWRT_DIST_LOCAL_PATH) && $(shell echo "src-link robin ../../packages" >> feeds.conf )
	fi
	cd $(OWRT_DIST_LOCAL_PATH) && $(shell ./scripts/feeds update -a )
	cd $(OWRT_DIST_LOCAL_PATH) && $(shell ./scripts/feeds install -a )
	cd $(OWRT_DIST_LOCAL_PATH) && $(shell ./scripts/feeds install robin )
	cd $(OWRT_DIST_LOCAL_PATH) && $(shell ./scripts/feeds install robin-v2-checkout )

	touch $@

apply_patches: 
	cp $(PATCHES_PATH)/default-config-backfire $(OWRT_DIST_LOCAL_PATH)/.config
	touch $@

standard_config: apply_patches
#	$(shell echo $(ROBIN_BUILD) > $(PACKAGES_LOCAL_PATH)/robin-v2-checkin/files/etc/robin_build)
#	$(shell echo $(OWRT_DIST_SVN_REV) > $(PACKAGES_LOCAL_PATH)/robin-v2-checkin/files/etc/openwrt_svn_rev)
	$(shell echo $(ROBIN_BUILD) > $(PACKAGES)/robin-v2-checkin/files/etc/robin_build)
	$(shell echo $(OWRT_DIST_SVN_REV) > $(PACKAGES)/robin-v2-checkin/files/etc/openwrt_svn_rev)
# not sure what this command does
#	$(shell sh update_version)


build_fw: standard_config
	cd $(OWRT_DIST_LOCAL_PATH) && make package/robin-v2-checkin
	cd $(OWRT_DIST_LOCAL_PATH) && make

clean:
	$(shell [ -d "$(OWRT_DIST_LOCAL_PATH)" ] && cd $(OWRT_DIST_LOCAL_PATH) && make clean)
	rm -rf versioning add_packages
