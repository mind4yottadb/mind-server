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
; Portions of this code have the following copyright
;#################################################################
;#                                                               #
;# Copyright (c) 2024 YottaDB LLC and/or its subsidiaries.       #
;# All rights reserved.                                          #
;#                                                               #
;#  This source code contains the intellectual property	         #
;#  of its copyright holder(s), and is made available            #
;#  under a license.  If you do not know the terms of            #
;#  the license, please stop and do not read further.            #
;#                                                               #
;#################################################################
;
; -------------------------------------------
; add(params)
;
; Creates a new entry
;
; params("type")                    "A" (API) "S" (socket) or "H" (helper process)
; params("pid")						OPTIONAL (used only by the helper)
; params("driverName")              OPTIONAL
; params("driverVersion")           OPTIONAL
; params("ipNumber")                OPTIONAL
; params("description")             OPTIONAL
; -------------------------------------------
add(params)
	new pid
	;
	set pid=$get(params("pid"),$job)
	;
	set ^%mindSessions(pid,"connectTime")=$ZUT
	set ^%mindSessions(pid,"type")=params("type")
	set ^%mindSessions(pid,"commandsCount")=0
	set ^%mindSessions(pid,"driverName")=$select($zlength($get(params("driverName"))):params("driverName"),1:"N/A")
	set ^%mindSessions(pid,"driverVersion")=$select($zlength($get(params("driverVersion"))):params("driverVersion"),1:"N/A")
	set ^%mindSessions(pid,"ipNumber")=$select($zlength($get(params("ipNumber"))):params("ipNumber"),1:"N/A")
	set ^%mindSessions(pid,"description")=$select($zlength($get(params("description"))):params("description"),1:"N/A")
	;
	; increment the counter if type '= "H"
	set:^%mindSessions(pid,"type")'="H" ret=$increment(^%mindSessions("S"))
	;
	quit
	;
	;
; -------------------------------------------
; edit(params)
;
; params("driverName")              OPTIONAL
; params("driverVersion")           OPTIONAL
; params("ipNumber")                OPTIONAL
; params("description")             OPTIONAL
; -------------------------------------------
edit(params)
	;
	set ^%mindSessions($job,"driverName")=$select($zlength($get(params("driverName"))):params("driverName"),1:"N/A")
	set ^%mindSessions($job,"driverVersion")=$select($zlength($get(params("driverVersion"))):params("driverVersion"),1:"N/A")
	set ^%mindSessions($job,"ipNumber")=$select($zlength($get(params("ipNumber"))):params("ipNumber"),1:"N/A")
	set ^%mindSessions($job,"description")=$select($zlength($get(params("description"))):params("description"),1:"N/A")
	;
	quit
	;
	;
; -------------------------------------------
; delete()
;
; Delete the entry for the current PID
; -------------------------------------------
delete()
	new ret
	;
	set ret=$increment(^%mindSessions("S"),-1)
	kill ^%mindSessions($job)
	;
	quit
	;
	;
; -------------------------------------------
; initialize()
;
; initialize the SESSIONS global
; -------------------------------------------
initialize()
	;
	kill ^%mindSessions
	set ^%mindSessions=0
	;
	quit
	;
	;
	;
	;
	;
	;
