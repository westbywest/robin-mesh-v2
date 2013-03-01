#!/bin/sh
# ubnt generic

DIVERSITY=0
RXANTENNA=1
TXANTENNA=1
OUTDOOR=0

# READONLY
uci batch <<-EOF_antenna
#	set wireless.wifi0.diversity=$DIVERSITY
#	set wireless.wifi0.rxantenna=$RXANTENNA
#	set wireless.wifi0.txantenna=$TXANTENNA
#	set wireless.wifi0.outdoor=$OUTDOOR
#	commit wireless
EOF_antenna
#
