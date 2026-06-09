;#################################################################
;#                                                               #
;# Copyright (c) 2026 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
; TODO: remove commented out errors after final confirmation
paramNotGreaterThanZero() quit "PARAM_NOT_GREATER_THAN_ZERO,"
paramMissing() quit "PARAM_MISSING,"

fileError() quit "FILE_ERROR,"
fileNotFound() quit "FILE_NOT_FOUND,"

pathIsRoot() quit "PATH_IS_ROOT,"
fileNotExists() quit "FILE_NOT_EXISTS,"
pathNotExists() quit "PATH_NOT_EXISTS,"
paramNotPositive() quit "PARAM_NOT_POSITIVE,"
timeoutOccurred() quit "TIMEOUT_OCCURRED,"
paramIsEmpty() quit "PARAM_IS_EMPTY,"
internalError() quit "INTERNAL_ERROR,"
fileIsDir() quit "FILE_IS_DIR,"
invalidPath() quit "INVALID_PATH,"
pathAlreadyExists() quit "PATH_ALREADY_EXISTS,"
dirNotEmpty() quit "DIR_NOT_EMPTY,"

noJson() quit "NO_JSON,"
jsonParseError() quit "JSON_PARSE_ERROR,"
dirCreateError() quit "DIR_CREATE_ERROR,"
posixError() quit "POSIX_ERROR,"
statError() quit "STAT_ERROR,"
commandError() quit "COMMAND_ERROR,"
appNotFound() quit "APP_NOT_FOUND,"
signalError() quit "SIGNAL_ERROR,"
jsonSerializeError() quit "JSON_SERIALIZE_ERROR,"
mcodeNotFound() quit "MCODE_NOT_FOUND,"

poolNotRegistered() quit "POOL_NOT_REGISTERED,"
siguser2NotSupported() quit "SIGUSR2_NOT_SUPPORTED"