#
# GitLab CI: Android v0.5
# TODO: Add emulators here 
#

FROM ubuntu:16.04
MAINTAINER Drew Ousenko

ENV VERSION_BUILD_TOOLS "26.0.2"
ENV VERSION_TARGET_SDK "26"

# Prepare System
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends curl html2text openjdk-8-jdk libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 unzip git-all && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Download SDK (command line tools from https://developer.android.com/studio/index.html)
# sha256 444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0
# 26.0.1 version
ADD https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip

# Configure PATH
ENV ANDROID_HOME "/sdk"
ENV PATH "${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# Accept License
RUN mkdir -p $ANDROID_HOME/licenses/ && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license


# Install SDK Package
RUN sdkmanager "platform-tools" --verbose && \
    sdkmanager "platforms;android-${VERSION_TARGET_SDK}" --verbose && \
    sdkmanager "build-tools;${VERSION_BUILD_TOOLS}" --verbose && \
    sdkmanager "extras;android;m2repository" --verbose && \
    sdkmanager "extras;google;m2repository" --verbose && \
    sdkmanager "extras;google;google_play_services" --verbose && \
    sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" --verbose
