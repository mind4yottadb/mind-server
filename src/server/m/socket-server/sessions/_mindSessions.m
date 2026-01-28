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
; Portions of this code have the following copyright:
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
; params("type")                    
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
	set ^%mindSessions(pid,"type")=$get(params("type"))
	set ^%mindSessions(pid,"driverName")=$select($zlength($get(params("driverName"))):params("driverName"),1:"N/A")
	set ^%mindSessions(pid,"driverVersion")=$select($zlength($get(params("driverVersion"))):params("driverVersion"),1:"N/A")
	set ^%mindSessions(pid,"ipNumber")=$select($zlength($get(params("ipNumber"))):params("ipNumber"),1:"N/A")
	set ^%mindSessions(pid,"description")=$select($zlength($get(params("description"))):params("description"),1:"N/A")
	;
	; increment the counter if type '= "H"
	set:^%mindSessions(pid,"type")'="H" ret=$increment(^%mindSessions)
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
; params("username")             OPTIONAL
; -------------------------------------------
edit(params)
	;
	set:$data(params("driverName")) ^%mindSessions($job,"driverName")=params("driverName")
	set:$data(params("driverVersion")) ^%mindSessions($job,"driverVersion")=params("driverVersion")
	set:$data(params("ipNumber")) ^%mindSessions($job,"ipNumber")=params("ipNumber")
	set:$data(params("description")) ^%mindSessions($job,"description")=params("description")
	set:$data(params("username")) ^%mindSessions($job,"username")=params("username")
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
	set ret=$increment(^%mindSessions,-1)
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
