include $(TOPDIR)/rules.mk

PKG_NAME:=robin-v2
PKG_REV:=3000
PKG_VERSION:=r$(PKG_REV)
PKG_RELEASE:=11n
#PKG_BRANCH=test

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/robin-v2/Default
  URL:=http://www.robin-mesh.org/
  MAINTAINER:=Antonio Anselmi <tony.anselmi@gmail.com>
endef

define Package/robin-v2
	SECTION:=net
	CATEGORY:=Network
	TITLE:=ROBIN Mesh Network
endef

define Package/robin-v2/description
	zero-config mesh network
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/robin-v2/install
	$(INSTALL_DIR) $(1)
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,robin-v2))
