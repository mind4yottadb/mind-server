#################################################################
#                                                               #
# Copyright (c) 2022-2025 YottaDB LLC and/or its subsidiaries.  #
# All rights reserved.                                          #
#                                                               #
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
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

if(EXISTS "${YOTTADB_INCLUDE_DIRS}/plugin/libsodium.so")
	set(sodium_ALREADY_INSTALLED TRUE)
else()
	find_package(PkgConfig QUIET)
	if (PKG_CONFIG_FOUND)
		enable_language(C)
		pkg_check_modules(sodium_PKG QUIET libsodium)
		if (sodium_PKG_FOUND)
			FetchContent_Declare(YDBsodium
				GIT_REPOSITORY	https://gitlab.com/YottaDB/Util/YDBsodium.git
				GIT_TAG		master
			)
			FetchContent_MakeAvailable(YDBsodium)
			message(STATUS "YDBsodium Source Directory: ${ydbsodium_SOURCE_DIR}")
		endif()
	endif()
endif()

if(sodium_ALREADY_INSTALLED)
	message(STATUS "libsodium already installed. Usernames/passwords will be available.")
elseif(NOT PKG_CONFIG_FOUND OR NOT sodium_PKG_FOUND)
	message(STATUS "Could not find libsodium. Cannot use usernames/passwords.")
else()
	message(STATUS "Installing libsodium YottaDB plugin. Usernames/passwords will be available.")
endif()

project(YDBGUI M)
find_package(YOTTADB REQUIRED)

message(STATUS "Install Location: ${YOTTADB_M_PLUGIN_DIR}")

if(EXISTS "${YOTTADB_M_PLUGIN_DIR}/_ydbmwebserver.so")
	message(STATUS "Found YottaDB Web Server plugin: ${YOTTADB_M_PLUGIN_DIR}/_ydbmwebserver.so")
else()
	FetchContent_Declare(mwebserver
		GIT_REPOSITORY https://gitlab.com/YottaDB/Util/YDB-Web-Server.git
		GIT_TAG        master
	)
	FetchContent_MakeAvailable(mwebserver)
endif()

if(EXISTS "${YOTTADB_C_PLUGIN_DIR}/libcurl.so")
	message(STATUS "Found YottaDB libcurl plugin: ${YOTTADB_C_PLUGIN_DIR}/libcurl.so")
else()
	enable_language(C)
	FetchContent_Declare(ydbcurl
		GIT_REPOSITORY https://gitlab.com/YottaDB/Util/YDBCurl.git
		GIT_TAG        master
	)
	FetchContent_MakeAvailable(ydbcurl)
endif()

if(EXISTS "${YOTTADB_M_PLUGIN_DIR}/_ydbposix.so")
	message(STATUS "Found YDBPosix plugin: ${YOTTADB_M_PLUGIN_DIR}/_ydbposix.so")
else()
	enable_language(C)
	FetchContent_Declare(YDBPosix
		GIT_REPOSITORY https://gitlab.com/YottaDB/Util/YDBPosix.git
		GIT_TAG	       9e585e81b8eca3fb64b7db531e7d12bbcccf708a
		)
	FetchContent_MakeAvailable(YDBPosix)
endif()

set(source_files
	routines/_ydbweburl.m
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
add_ydb_library(_ydbgui SOURCES ${source_files})

# Install shared library
install_ydb_library(_ydbgui)

install(DIRECTORY wwwroot/ DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/ydbgui
	PATTERN "test" EXCLUDE
	PATTERN "debug" EXCLUDE)

# copy the manifest file to the plugin dir
install(FILES _ydbgui.manifest.json DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/ydbgui)
install(FILES _ydbgui.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR})
if(ydb_icu_version)
	install(FILES _ydbgui.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR}/utf8)
endif()
