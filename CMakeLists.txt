#################################################################
#                                                               #
# Copyright (c) 2025-2026 DnaSoft B.V. and/or its subsidiaries. #
# All rights reserved.                                          #
#                                                               #
#   This source code contains the intellectual property         #
#   of its copyright holder(s), and is made available           #
#   under a license.  If you do not know the terms of           #
#   the license, please stop and do not read further.           #
#                                                               #
#################################################################
# Prelim
cmake_minimum_required(VERSION 3.14)
include(FetchContent)
# The GIT_TAG below is, at the time of this writing, the latest commit in YDBCMake.
# It is fixed at that point to ensure reproducible builds.
# Keep this periodically up to date with future YDBCMake commits.
FetchContent_Declare(YDBCMake
	GIT_REPOSITORY	https://gitlab.com/YottaDB/Tools/YDBCMake.git
	GIT_TAG		1bf25f1a14c82e8348a024fb105a2e44e0645f9d
)
# The following sets ydbcmake_SOURCE_DIR
FetchContent_MakeAvailable(YDBCMake)
message(STATUS "YDBCMake Source Directory: ${ydbcmake_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${ydbcmake_SOURCE_DIR}/ydbcmake/")

if(EXISTS "${YOTTADB_M_PLUGIN_DIR}/_ydbgui.so")
	message(STATUS "Found YottaDB GUI plugin: ${YOTTADB_M_PLUGIN_DIR}/_ydbgui.so")
else()
	FetchContent_Declare(ydbgui
		GIT_REPOSITORY https://gitlab.com/YottaDB/UI/YDBGUI.git
		GIT_TAG        master
	)
	FetchContent_MakeAvailable(ydbgui)
endif()

project(MIND
	LANGUAGES M
	VERSION 0.17.0)
find_package(YOTTADB REQUIRED)

message(STATUS "Install Location: ${YOTTADB_M_PLUGIN_DIR}")

configure_file(/build/src/server/m/_mindVersion.m /build/src/server/m/_mindVersion.m @ONLY)
configure_file(mind.manifest.json.in mind.manifest.json @ONLY)

set(source_files
	/build/src/server/m/_mindTerminal.m
	/build/src/server/m/_mindVersion.m
	/build/src/server/m/call.m
	/build/src/server/m/init/_mind.m
	/build/src/server/m/init/_mindCmdLineParser.m
	/build/src/server/m/init/_mindConfigFileParser.m
	/build/src/server/m/init/_mindUserApiParser.m
	/build/src/server/m/init/_mindUsersParser.m
	/build/src/server/m/namespaces/_mindNSfs.m
	/build/src/server/m/namespaces/_mindNSglvn.m
	/build/src/server/m/namespaces/_mindNSprocess.m
	/build/src/server/m/namespaces/_mindNSserver.m
	/build/src/server/m/namespaces/_mindNSsession.m
	/build/src/server/m/shared/json/_mindJSON.m
	/build/src/server/m/shared/json/_mindJSONparse.m
	/build/src/server/m/shared/json/_mindJSONstringify.m
	/build/src/server/m/shared/_mindLogger.m
	/build/src/server/m/shared/_mindRESP3.m
	/build/src/server/m/shared/_mindUtils.m
	/build/src/server/m/socket-server/sessions/_mindServerSession.m
	/build/src/server/m/socket-server/sessions/_mindSessions.m
	/build/src/server/m/socket-server/_mindSocketServer.m
)

# .so file for plugin
add_ydb_library(mind SOURCES ${source_files})

# Install shared library
install_ydb_library(mind)

install(DIRECTORY config/ DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind)
install(FILES commands/mind DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind PERMISSIONS OWNER_EXECUTE)

# copy the manifest file to the plugin dir
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR})
if(ydb_icu_version)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR}/utf8)
endif()
