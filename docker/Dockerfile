#
# Lightweight debian flask, react, bower, gulp
#

# Pull base image.
FROM debian:latest

# Apt update and install
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  sudo \
  python-pip \
  virtualenv \
  zip

#
# Install Nodejs
#
# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
#
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs

# Install Bower & Gulp
RUN npm install -g bower gulp

#
# Install Google Cloud SDK
#

RUN curl -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && tar xvfz google-cloud-sdk.tar.gz && rm google-cloud-sdk.tar.gz
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN google-cloud-sdk/bin/gcloud --quiet components update pkg-go pkg-python pkg-java preview alpha beta app app-engine-python
RUN google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true
ENV PATH /google-cloud-sdk/bin:$PATH
#ENV HOME /

#
# Install App Engine
#
RUN curl -o google_appengine.zip https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.24.zip && unzip google_appengine.zip && rm google_appengine.zip
ENV PATH /google_appengine:$PATH

#
# Passwordless sudo
#
# http://blog.stefanxo.com/2014/01/breaking-down-a-dockerfile/
#
RUN echo %sudo        ALL=NOPASSWD: ALL >> /etc/sudoers

#
# Set CI=true to stop bower prompting about analytics
#
# https://github.com/bower/bower/issues/1102#issuecomment-91148172
#
ENV CI=true

#WORKDIR /root
#COPY requirements.txt /root/
#RUN pip install -r requirements.txt

# this needs to be run in the home directory
#RUN npm install