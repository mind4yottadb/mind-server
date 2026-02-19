#################################################################
#                                                               #
# Copyright (c) 2022-2025 YottaDB LLC and/or its subsidiaries.  #
# All rights reserved.                                          #
#                                                               #
#	This source code contains the intellectual property	        #
#	of its copyright holder(s), and is made available	        #
#	under a license.  If you do not know the terms of	        #
#	the license, please stop and do not read further.	        #
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

project(MIND M)
find_package(YOTTADB REQUIRED)

message(STATUS "Install Location: ${YOTTADB_M_PLUGIN_DIR}")

if(EXISTS "${YOTTADB_M_PLUGIN_DIR}/_ydbgui.so")
	message(STATUS "Found YottaDB GUI plugin: ${YOTTADB_M_PLUGIN_DIR}/_ydbgui.so")
else()
	FetchContent_Declare(ydbgui
		GIT_REPOSITORY https://gitlab.com/YottaDB/UI/YDBGUI.git
		GIT_TAG        master
	)
	FetchContent_MakeAvailable(ydbgui)
endif()

set(source_files
	src/server/m/init/_mind.m
	routines/_ydbgui.m
	routines/_ydbguiGde.m
	routines/_ydbguiRegions.m
	routines/_ydbguiRest.m
	routines/_ydbguiUtils.m
	routines/_ydbguiLocks.m
	routines/_ydbguiGlobals.m
	routines/_ydbguiRoutines.m
	routines/_ydbguiMaintenance.m
	routines/_ydbguiReplication.m
	routines/_ydbguiOcto.m
	routines/_ydbguiStatsServer.m
	routines/_ydbguiStatsGenerator.m
	routines/_ydbguiWsServer.m
)

# .so file for plugin
add_ydb_library(mind SOURCES ${source_files})

# Install shared library
install_ydb_library(mind)

install(DIRECTORY config/ DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind
	PATTERN "test" EXCLUDE
	PATTERN "debug" EXCLUDE)

# copy the manifest file to the plugin dir
install(FILES mind.manifest.json DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind)
install(FILES mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR})
if(ydb_icu_version)
	install(FILES mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR}/utf8)
endif()
