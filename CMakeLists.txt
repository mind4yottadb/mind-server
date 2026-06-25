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

project(MIND
	LANGUAGES M
	VERSION 0.29.0)
find_package(YOTTADB REQUIRED)

set(test_mode false CACHE BOOL)
set(tls false CACHE BOOL)
set(so_only false CACHE BOOL)

message("test_mode=${test_mode}")
message("test_mode=$CACHE{test_mode}")
message("tls=${tls}")
message("so_only=${so_only}")

# Install YDBEncrypt library
if(NOT so_only)
    if(tls)
        message("tls=${tls}")
        if(NOT EXISTS "${YOTTADB_C_PLUGIN_DIR}/libgtmtls.so")
            execute_process(COMMAND git clone https://gitlab.com/YottaDB/Util/YDBEncrypt.git
             WORKING_DIRECTORY .
             COMMAND_ECHO STDOUT
             )
            execute_process(COMMAND make install
             WORKING_DIRECTORY YDBEncrypt
             COMMAND_ECHO STDOUT
             )
        else()
            message(STATUS "Found YDBEncrypt plugin")
        endif()
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
endif()

message(STATUS "Install Location: ${YOTTADB_M_PLUGIN_DIR}")

configure_file(src/server/m/_mindVersion.m src/server/m/init/_mindVersion.m @ONLY)
configure_file(_mind.manifest.json ${CMAKE_CURRENT_BINARY_DIR}/_mind.manifest.json @ONLY)

set(source_files
	src/server/m/_mindTerminal.m
	src/server/m/init/_mindVersion.m
	src/server/m/call.m
	src/server/m/init/_mind.m
	src/server/m/init/_mindCmdLineParser.m
	src/server/m/init/_mindConfigFileParser.m
	src/server/m/init/_mindUserApiParser.m
	src/server/m/init/_mindUsersParser.m
	src/server/m/init/_mindUserApiViewer.m
	src/server/m/namespaces/_mindNSfs.m
	src/server/m/namespaces/_mindNSglvn.m
	src/server/m/namespaces/_mindNSprocess.m
	src/server/m/namespaces/_mindNSserver.m
	src/server/m/namespaces/_mindNSsession.m
	src/server/m/namespaces/_mindNSuapi.m
	src/server/m/shared/json/_mindJSON.m
	src/server/m/shared/json/_mindJSONparse.m
	src/server/m/shared/json/_mindJSONstringify.m
	src/server/m/shared/_mindLogger.m
	src/server/m/shared/_mindRESP3.m
	src/server/m/shared/_mindUtils.m
	src/server/m/socket-server/sessions/_mindServerSession.m
	src/server/m/socket-server/sessions/_mindSessions.m
	src/server/m/socket-server/_mindSocketServer.m
)

# .so file for plugin
add_ydb_library(_mind SOURCES ${source_files})

# Install shared library
install_ydb_library(_mind)

if(NOT so_only)
    install(FILES config/mind.conf DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind)
    install(FILES config/users.json DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind)
    if(tls)
        install(FILES config/mind.ydbcrypt DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind)
    endif()

    install(FILES commands/mind DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind PERMISSIONS OWNER_EXECUTE)
    install(FILES commands/mind-vehu-vista DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind PERMISSIONS OWNER_EXECUTE)
    install(DIRECTORY DESTINATION ${YOTTADB_PLUGIN_PREFIX}/etc/mind/uApi)

    if(test_mode)
        install(DIRECTORY test DESTINATION /opt/mind/test)
    endif()
endif()

# copy the manifest file to the plugin dir
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/_mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR})
if(ydb_icu_version)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/_mind.manifest.json DESTINATION ${YOTTADB_M_PLUGIN_DIR}/utf8)
endif()
