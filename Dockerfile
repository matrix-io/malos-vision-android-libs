
FROM ubuntu:16.04

# Thanks to https://gist.github.com/wenzhixin/43cf3ce909c24948c6e7

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

ENV HOME=/opt
ENV ANDROID_HOME="$HOME/tools"
ENV ANDROID_SDK_TOOLS="$HOME/tools"
ENV NDK_HOME="$HOME/android-ndk-r15c"
ENV NDK_ROOT="$HOME/android-ndk-r15c"
ENV ANDROID_SDK_ROOT="$HOME/tools"
ENV ANDROID_NDK_HOME="$NDK_HOME"
ENV ANDROID_ABI=armeabi-v7a
ENV ANDROID_NDK="$NDK_HOME"
ENV GRADLE_HOME="$HOME/gradle-4.4"
ENV PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin"
ENV ANT_HOME="/opt/apache-ant-1.10.5"
ENV PATH=${PATH}:${ANT_HOME}/bin

RUN apt-get update && apt-get install --yes \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    devscripts \
    dh-systemd \
    fakeroot \
    git \
    libtool \
    libunicap2 \
    libunicap2-dev \
    libdc1394-22-dev \
    libdc1394-22 \
    libdc1394-utils \
    libv4l-0 \
    libv4l-dev \
    libssl-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    libpng-dev \
    libopenexr-dev \
    libeigen3-dev \
    libzmq3-dev \
    lintian \
    openssl \
    unzip \
    yasm

RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer

# Get SDK tools (link from https://developer.android.com/studio/index.html#downloads)
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
  wget -q --no-check-certificate http://dl-ssl.google.com/android/repository/tools_r25.2.5-linux.zip && \
  unzip tools*.zip >> /dev/null && rm tools*.zip 

# Get NDK (https://developer.android.com/ndk/downloads/index.html)
RUN cd ${HOME}/ && \
  wget -q --no-check-certificate https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip && \
  unzip android-ndk*zip >> /dev/null && \
  rm android-ndk*zip

# Get SDK main packages, platforms tools
RUN mkdir $ANDROID_HOME/licenses && \
  echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
  echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
  echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license && \
  $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" && \
  $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.2" "build-tools;25.0.3" && \
  $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-26" "platforms;android-25" "platforms;android-24" "platforms;android-23" "platforms;android-21" "platforms;android-19" && \
  $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository" && \
  $ANDROID_HOME/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" && \
  $ANDROID_HOME/tools/bin/sdkmanager "lldb;3.1" && \
  $ANDROID_HOME/tools/bin/sdkmanager "cmake;3.6.4111459" && \
  $ANDROID_HOME/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" 
# Get the Apache Ant
RUN cd  /opt && \
    wget -q --no-check-certificate https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.5-bin.zip && \
    unzip apache-ant-1.10.5-bin.zip && \
    rm apache-ant-1.10.5-bin.zip
# Get the dependencies needed and build the android-libs
RUN cd /opt && \ 
    git clone https://github.com/matrix-io/malos-vision-android-libs.git && \
    cd malos-vision-android-libs && \
    git clone https://github.com/hpsaturn/caffe-android-lib.git && \
    cd caffe-android-lib && git checkout av/maloslib && git clone https://github.com/matrix-io/matrix-malos-lib.git && git clone https://github.com/matrix-io/protocol-buffers.git matrixio_protos && \
    git submodule update --init --recursive && \
    ../builder.sh
# Set the environment variable for the libs built
ENV MALOS_ANDROID_LIBS=/opt/malos-vision-android-libs/caffe-android-lib/android_lib


COPY . /src
COPY ./local.properties.docker /src/local.properties


