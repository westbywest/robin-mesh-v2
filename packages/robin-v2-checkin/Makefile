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

include $(TOPDIR)/rules.mk

PKG_NAME:=robin-v2-checkin
PKG_REV:=2
PKG_VERSION:=v$(PKG_REV)
PKG_RELEASE:=11n
#PKG_BRANCH=test
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_olsrd CONFIG_PACKAGE_olsrd-mod-mdns \
	BUSYBOX_CONFIG_TRACEROUTE CONFIG_BUSYBOX_CONFIG_HEXDUMP

include $(INCLUDE_DIR)/package.mk

define Package/robin-v2-checkin
	SECTION:=net
	CATEGORY:=Network
	DEFAULT:=y
	TITLE:=ROBIN Mesh Network Dashboard Checkin
	DEPENDS:=+dnsmasq +olsrd +coova-chilli +tcpdump-mini +fping +wget +uhttpd
    URL:=http://wiki-robin.meshroot.com/
    MAINTAINER:=Antonio Anselmi <tony.anselmi@gmail.com>, et al
endef

# nodogsplash dependency commented out

define Package/robin-v2-checkin/description
	Dashboard checkin tool for Robin zero-config mesh network
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/robin-v2-checkin/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,robin-v2-checkin))
