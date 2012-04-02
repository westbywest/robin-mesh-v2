include $(TOPDIR)/rules.mk

PKG_NAME:=robin
PKG_REV:=2
PKG_VERSION:=v$(PKG_REV)
PKG_RELEASE:=11n
#PKG_BRANCH=test

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/robin-v2/Default
  URL:=http://www.robin-mesh.org/
  MAINTAINER:=Antonio Anselmi <tony.anselmi@gmail.com>
endef

define Package/robin
	SECTION:=net
	CATEGORY:=Network
	TITLE:=ROBIN Mesh Network
endef

define Package/robin/description
	zero-config mesh network
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/robin/install
	$(INSTALL_DIR) $(1)
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,robin))
