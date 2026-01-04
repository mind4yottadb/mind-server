#################################################################
#                                                               #
# Copyright (c) 2022-2025 YottaDB LLC and/or its subsidiaries.  #
# All rights reserved.                                          #
#                                                               #
#   This source code contains the intellectual property	        #
#   of its copyright holder(s), and is made available           #
#   under a license.  If you do not know the terms of           #
#   the license, please stop and do not read further.           #
#                                                               #
#################################################################

FROM yottadb/yottadb:latest

# Extra's to run non-interactive Chrome
RUN apt-get update && apt-get install -y curl unzip wget cmake git gcc make \
			libssl-dev libconfig-dev libgcrypt-dev libgpgme-dev \
			libicu-dev libsodium-dev curl libcurl4-openssl-dev libnss3-tools \
            redis

# Install latest version of Node.js/NPM
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=22.19.0
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node --version
RUN npm --version


# Install npm testing packages
#COPY package.json /opt/mind/package.json
#RUN npm install --legacy-peer-deps # See https://github.com/prasanaworld/puppeteer-screen-recorder/issues/115

# Install Encryption Plugin
WORKDIR /tmp
ENV ydb_dist="/opt/yottadb/current"
ENV ydb_icu_version="70"
RUN git clone https://gitlab.com/YottaDB/Util/YDBEncrypt
RUN cd YDBEncrypt && make install

ENV ydb_xc_libcurl="/opt/yottadb/current/plugin/libcurl.xc"

# Create Certificates
#RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -O /usr/bin/mkcert && chmod 755 /usr/bin/mkcert
#RUN mkdir -p /YDBGUI/certs $HOME/.pki/nssdb
#RUN certutil -d sql:$HOME/.pki/nssdb -N --empty-password
#RUN mkcert -install -key-file /YDBGUI/certs/ydbgui.key -cert-file /YDBGUI/certs/ydbgui.pem localhost

# Set-up YottaDB Certificate Config
#COPY docker-configuration/ydbgui.ydbcrypt /opt/mind/certs/
#ENV ydb_crypt_config=/opt/mind/certs/ydbgui.ydbcrypt

# Node.js Certificate config
#ENV NODE_EXTRA_CA_CERTS=/root/.local/share/mkcert/rootCA.pem

# Initialize files for working directory
WORKDIR /opt/mind

ENV gtm_lct_stdnull=1
ENV gtm_lvnullsubs=2

#ENV ydb_routines='/opt/mind/o*(/opt/mind/m) /opt/yottadb/current/libyottadbutil.so'

# Install GUI
#COPY CMakeLists.txt /build/CMakeLists.txt
#COPY _ydbgui.manifest.json /build/_ydbgui.manifest.json
#COPY src/server/m /build/routines/
#RUN cd /build/ && mkdir build && cd build && cmake .. && make && make install

# Create dir structure and copy files
RUN mkdir /opt/mind/m /opt/mind/test /opt/mind/test/m /opt/mind/o $ydb_dist/plugin/etc/mind $ydb_dist/plugin/etc/mind/usercommands

COPY ./commands /opt/mind/

# setup shell initialization
RUN echo '. /opt/mind/dev.sh' >>/root/.bashrc

EXPOSE 10000
ENTRYPOINT ["sleep", "infinity"]

# to build the image
# docker image build --progress=plain -t mind .

# in windows: docker run -d --init --name=mind -p 10000:10000 -v C:\Users\stefa\WebstormProjects\mind/src/server/m:/opt/mind/m:rw mind
