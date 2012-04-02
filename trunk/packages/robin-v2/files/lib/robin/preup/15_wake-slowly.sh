#!/bin/sh

WAIT_TIME=$(uci get management.enable.wake_slowly)
sleep $WAIT_TIME

