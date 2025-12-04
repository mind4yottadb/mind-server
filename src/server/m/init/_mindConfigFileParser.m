;#################################################################
;#                                                               #
;# Copyright (c) 2025 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
; This routine process the configuration file
;
parse
    new level
    ;
    set level=$zlevel
    ;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/mind.config2"
	open configFile:(read:EXCEPTION="goto configFileError")
	use configFile

	close configFile
    ;
continueAfterConfigFileError
    quit
    ;
    ;
configFileError
    ;
    use zpout
    write !,trm("red"),"WARNING: Error reading configuration file...",!
    write "Filename: ",configFile,!,"Error:",$zpiece($zstatus,",",6),trm("white"),!
    zgoto level:continueAfterConfigFileError