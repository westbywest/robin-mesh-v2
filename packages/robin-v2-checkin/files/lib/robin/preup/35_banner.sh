#!/bin/sh

ROBIN_BUILD=$(cat /etc/robin_build)
BACKFIRE=$(cat /etc/openwrt_svn_rev)
ROBIN_VERSION="${BACKFIRE}_${ROBIN_BUILD}"

echo "r${ROBIN_VERSION}" > /etc/robin_version
# READONLY
#cat > /etc/banner << banner_end
#  ______         __     __         _______                __    
# |   __ \.-----.|  |--.|__|.-----.|   |   |.-----..-----.|  |--.
# |      <|  _  ||  _  ||  ||     ||       ||  -__||__ --||     |
# |___|__||_____||_____||__||__|__||__|_|__||_____||_____||__|__|
# Robin2-802.11n                                  
# bleeding edge, "r${BACKFIRE}_${ROBIN_BUILD}"
# --------------------------------------------------------------- 
# Powered by these open source projects:
# http://www.openwrt.org     http://www.open-mesh.org
# http://www.olsr.org        http://coova.org/
# ---------------------------------------------------------------
#banner_end
#
    