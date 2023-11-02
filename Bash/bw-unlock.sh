#!/bin/bash

## relies on bitwarden cli

capture=$(bw unlock | sed -n '4p' | sed 's/$\sexport\sBW_SESSION=/''/')
export BW_SESSION=${capture}
bw sync
