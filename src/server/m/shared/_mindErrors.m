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
paramNotGreaterThanZero() quit "S_PARAM_NOT_GREATER_THAN_ZERO,"
paramMissing() quit "S_PARAM_MISSING,"

fileError() quit "S_FILE_ERROR,"
fileNotFound() quit "S_FILE_NOT_FOUND,"

pathIsRoot() quit "S_PATH_IS_ROOT,"
fileNotExists() quit "S_FILE_NOT_EXISTS,"
pathNotExists() quit "S_PATH_NOT_EXISTS,"
paramNotPositive() quit "S_PARAM_NOT_POSITIVE,"
timeoutOccurred() quit "S_TIMEOUT_OCCURRED,"
paramIsEmpty() quit "S_PARAM_IS_EMPTY,"
internalError() quit "S_INTERNAL_ERROR,"
fileIsDir() quit "S_FILE_IS_DIR,"
invalidPath() quit "S_INVALID_PATH,"
pathAlreadyExists() quit "S_PATH_ALREADY_EXISTS,"
dirNotEmpty() quit "S_DIR_NOT_EMPTY,"

noJson() quit "S_NO_JSON,"
jsonParseError() quit "S_JSON_PARSE_ERROR,"
dirCreateError() quit "S_DIR_CREATE_ERROR,"
posixError() quit "S_POSIX_ERROR,"
statError() quit "S_STAT_ERROR,"
commandError() quit "S_COMMAND_ERROR,"
appNotFound() quit "S_APP_NOT_FOUND,"
signalError() quit "S_SIGNAL_ERROR,"
jsonSerializeError() quit "S_JSON_SERIALIZE_ERROR,"
mcodeNotFound() quit "S_MCODE_NOT_FOUND,"

poolNotRegistered() quit "S_POOL_NOT_REGISTERED,"
siguser2NotSupported() quit "S_SIGUSR2_NOT_SUPPORTED"
