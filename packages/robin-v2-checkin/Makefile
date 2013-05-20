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
PKG_REV:=2.1
PKG_VERSION:=v$(PKG_REV)
PKG_RELEASE:=11n
#PKG_BRANCH=test
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_olsrd CONFIG_PACKAGE_olsrd-mod-mdns \
	BUSYBOX_CONFIG_TRACEROUTE CONFIG_BUSYBOX_CONFIG_HEXDUMP

include $(INCLUDE_DIR)/package.mk

define Package/robin-v2-checkin/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ROBIN Mesh Network Dashboard Checkin
  URL:=http://wiki-robin.meshroot.com/
  MAINTAINER:=Antonio Anselmi <tony.anselmi@gmail.com>, et al
  DEPENDS:=+dnsmasq +tcpdump-mini +fping +curl +uhttpd +wireless-tools
endef

# nodogsplash dependency commented out

define Package/robin-v2-checkin/Default/description
 Dashboard checkin tool for ROBIN zero-config mesh network.
endef

define Package/robin-v2-checkin
$(call Package/robin-v2-checkin/Default)
  TITLE+= (full)
  DEPENDS:=+olsrd +coova-chilli
endef

define Package/robin-v2-checkin/description
$(call Package/robin-v2-checkin/Default/description)
 .
 This package contains the full ROBIN Dashboard checkin install.
endef

define Package/robin-v2-checkin-mini
$(call Package/robin-v2-checkin/Default)
 TITLE+= (minimal)
 DEPENDS:=+olsrd
endef

define Package/robin-v2-checkin-mini/description
$(call Package/robin-v2-checkin/Default/description)
 .
 This package contains only a minimal ROBIN Dashboard checkin install.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/robin-v2-checkin/install
	mkdir -p $(1)/bin
	$(CP) ./files/bin/* $(1)/bin
	mkdir -p $(1)/etc
	$(CP) ./files/etc/* $(1)/etc
	mkdir -p $(1)/lib/robin
	$(CP) ./files/lib/robin/callbacks $(1)/lib/robin
	mkdir -p $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/10_node_status $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/15_cpu_stats $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/20_current_gateway $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/29_chilli_query_logout $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/30_coova_users_usage $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/30_nds_users_usage $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/30_nocp_users_usage $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/40_network_transfer_rate $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/45_neighbors $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/50_RSSI $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/plugin.list.full $(1)/lib/robin/checkin/plugin.list
	$(CP) ./files/lib/robin/checkin-functions.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/dnsmasq-callbacks.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/endboot $(1)/lib/robin
	mkdir -p $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/100_mtu $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/100_nds_delayer $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/140_smtp_redirect $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/150_logger_rules $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/151_logger_filter $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/160_core_rules $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/170_dns_queries_redirection $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/200_icmp_traceroute_block $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/220_drop_101_IP_leases $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/240_strict_mesh $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/250_network_healthy $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/300_forwarder $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/plugin.list.full $(1)/lib/robin/firewall/plugin.list
	$(CP) ./files/lib/robin/inet-test.sh $(1)/lib/robin 
	$(CP) ./files/lib/robin/iwag-test.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/jobs $(1)/lib/robin
	$(CP) ./files/lib/robin/last-hop.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/limited-mesh.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/plugins.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/postup $(1)/lib/robin
	mkdir -p $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/00_installation_check.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/10_hw_watchdog.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/15_wake-slowly.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/20_network.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/22_rseolv_conf.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/30_time_zone.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/35_banner.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/40_blank_flags.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/45_boot_log.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/50_set_channel.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/55_detect_role.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/60_settings.sh.full $(1)/lib/robin/preup/60_settings.sh
	$(CP) ./files/lib/robin/preup/72_country_code.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/90_hostname.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/90_olsrd_version.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/plugin.list $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/sched-reboot.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/settime.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/strict-mesh.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/tts-check.sh $(1)/lib/robin
	mkdir -p $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/10_wifi $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/20_memory $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/30_udhcpc $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/40_olsrd $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/50_captive_portal $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/60_dnsmasq $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/70_repeater_to_gateway $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/80_gateway_to_inet $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/plugin.list.full $(1)/lib/robin/watchout/plugin.list
	mkdir -p $(1)/sbin
	$(CP) ./files/sbin/* $(1)/sbin
	mkdir -p $(1)/usr/lib
	$(CP) ./files/usr/lib/* $(1)/usr/lib
	mkdir -p $(1)/usr/share
	$(CP) ./files/usr/share/* $(1)/usr/share
	mkdir -p $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-chilli.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-cp_switch.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-ethers.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-general.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-iprules.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-management.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-mesh.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-node.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-nodes.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-nodog.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-olsr.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-radio.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-txpower.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-wifi.sh $(1)/usr/sbin
	mkdir -p $(1)/www
	$(CP) ./files/www/* $(1)/www
endef

define Package/robin-v2-checkin-mini/install
	mkdir -p $(1)/bin      
	$(CP) ./files/bin/* $(1)/bin
	mkdir -p $(1)/etc
	$(CP) ./files/etc/* $(1)/etc
	mkdir -p $(1)/lib/robin
	$(CP) ./files/lib/robin/callbacks $(1)/lib/robin
	mkdir -p $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/10_node_status $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/15_cpu_stats $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/20_current_gateway $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/30_nocp_users_usage $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/40_network_transfer_rate $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/45_neighbors $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/50_RSSI $(1)/lib/robin/checkin
	$(CP) ./files/lib/robin/checkin/plugin.list.minimal $(1)/lib/robin/checkin/plugin.list
	$(CP) ./files/lib/robin/checkin-functions.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/dnsmasq-callbacks.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/endboot $(1)/lib/robin
	mkdir -p $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/100_mtu $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/140_smtp_redirect $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/150_logger_rules $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/151_logger_filter $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/160_core_rules $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/170_dns_queries_redirection $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/200_icmp_traceroute_block $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/220_drop_101_IP_leases $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/240_strict_mesh $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/250_network_healthy $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/300_forwarder $(1)/lib/robin/firewall
	$(CP) ./files/lib/robin/firewall/plugin.list.minimal $(1)/lib/robin/firewall/plugin.list
	$(CP) ./files/lib/robin/inet-test.sh $(1)/lib/robin 
	$(CP) ./files/lib/robin/iwag-test.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/jobs $(1)/lib/robin
	$(CP) ./files/lib/robin/last-hop.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/limited-mesh.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/plugins.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/postup $(1)/lib/robin
	mkdir -p $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/00_installation_check.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/10_hw_watchdog.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/15_wake-slowly.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/20_network.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/22_rseolv_conf.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/30_time_zone.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/35_banner.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/40_blank_flags.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/45_boot_log.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/50_set_channel.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/55_detect_role.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/60_settings.sh.minimal $(1)/lib/robin/preup/60_settings.sh
	$(CP) ./files/lib/robin/preup/72_country_code.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/90_hostname.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/90_olsrd_version.sh $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/preup/plugin.list $(1)/lib/robin/preup
	$(CP) ./files/lib/robin/sched-reboot.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/settime.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/strict-mesh.sh $(1)/lib/robin
	$(CP) ./files/lib/robin/tts-check.sh $(1)/lib/robin
	mkdir -p $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/10_wifi $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/20_memory $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/30_udhcpc $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/40_olsrd $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/60_dnsmasq $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/70_repeater_to_gateway $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/80_gateway_to_inet $(1)/lib/robin/watchout
	$(CP) ./files/lib/robin/watchout/plugin.list.minimal $(1)/lib/robin/watchout/plugin.list
	mkdir -p $(1)/sbin
	$(CP) ./files/sbin/* $(1)/sbin
	mkdir -p $(1)/usr/lib
	$(CP) ./files/usr/lib/* $(1)/usr/lib
	mkdir -p $(1)/usr/share
	$(CP) ./files/usr/share/* $(1)/usr/share
	mkdir -p $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-ethers.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-general.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-iprules.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-management.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-mesh.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-node.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-nodes.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-olsr.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-radio.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-txpower.sh $(1)/usr/sbin
	$(CP) ./files/usr/sbin/update-wifi.sh $(1)/usr/sbin
	mkdir -p $(1)/www
	$(CP) ./files/www/* $(1)/www
endef

$(eval $(call BuildPackage,robin-v2-checkin))
$(eval $(call BuildPackage,robin-v2-checkin-mini))
