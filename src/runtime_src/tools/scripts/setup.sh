#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2019-2021 Xilinx, Inc. All rights reserved.
#
# Script to setup environment for XRT
# This script is installed in /opt/xilinx/xrt and must
# be sourced from that location

# Check OS version requirement
OSDIST=`lsb_release -i |awk -F: '{print tolower($2)}' | tr -d ' \t'`
OSREL=`lsb_release -r |awk -F: '{print tolower($2)}' |tr -d ' \t' | awk -F. '{print $1*100+$2}'`

if [[ $OSDIST == "ubuntu" ]]; then
    if (( $OSREL < 1604 )); then
        echo "ERROR: Ubuntu release version must be 16.04 or later"
        return 1
    fi
fi

if [[ $OSDIST == "centos" ]] || [[ $OSDIST == "redhat"* ]]; then
    if (( $OSREL < 704 )); then
        echo "ERROR: Centos or RHEL release version must be 7.4 or later"
        return 1
    fi
fi

XILINX_XRT=$(readlink -f $(dirname ${BASH_SOURCE[0]:-${(%):-%x}}))

if [[ $XILINX_XRT != *"/opt/xilinx/xrt" ]]; then
    echo "Invalid location: $XILINX_XRT"
    echo "This script must be sourced from XRT install directory"
    return 1
fi

# Enable autocompletion for the xbutil and xbmgmt commands
source $XILINX_XRT/share/completions/xbutil-bash-completion
source $XILINX_XRT/share/completions/xbmgmt-bash-completion

# To use the newest version of the XRT tools, either uncomment or set 
# the following environment variable in your profile:
#   export XRT_TOOLS_NEXTGEN=true

export XILINX_XRT
export LD_LIBRARY_PATH=$XILINX_XRT/lib:$LD_LIBRARY_PATH
export PATH=$XILINX_XRT/bin:$PATH
export PYTHONPATH=$XILINX_XRT/python:$PYTHONPATH

echo "XILINX_XRT        : $XILINX_XRT"
echo "PATH              : $PATH"
echo "LD_LIBRARY_PATH   : $LD_LIBRARY_PATH"
echo "PYTHONPATH        : $PYTHONPATH"
