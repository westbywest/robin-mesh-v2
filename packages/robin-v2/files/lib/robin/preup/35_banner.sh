#!/bin/sh

ROBIN_BUILD=$(cat /etc/robin_build)
BACKFIRE=$(cat /etc/openwrt_svn_rev)

echo "r${ROBIN_BUILD}" > /etc/robin_version

cat > /etc/banner << banner_end
  ______         __     __         _______                __    
 |   __ \.-----.|  |--.|__|.-----.|   |   |.-----..-----.|  |--.
 |      <|  _  ||  _  ||  ||     ||       ||  -__||__ --||     |
 |___|__||_____||_____||__||__|__||__|_|__||_____||_____||__|__|
 Robin2-802.11n                                  
 bleeding edge, r$ROBIN_BUILD - Openwrt backfire, r$BACKFIRE
 --------------------------------------------------------------- 
 Powered by these open source projects:
 http://www.openwrt.org     http://www.open-mesh.org
 http://www.olsr.org        http://coova.org/
 ---------------------------------------------------------------
banner_end
#
    