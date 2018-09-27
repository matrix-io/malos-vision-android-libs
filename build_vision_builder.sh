#!/bin/bash
##########################################################
# @hpsaturn 20180806
#
# Prerequisits:
# docker image: https://github.com/sh1r0/caffe-android-lib
##########################################################

cp ../build_vision_libs.sh .
outputname=android_vision_libs
cd opencv
branch=`git describe --exact-match --abbrev=0`
cd ..

print_header(){
    echo ""
    echo "*****************************"
    echo "****   $1    *****"
    echo "*****************************"
    echo ""
}

print_details(){
  echo ""
  echo "DETAILS:"
  echo ""
  echo "config tools:"
  env | grep ANDROID
  echo ""
  echo "opencv branch:"
  echo "$branch"
  echo ""
  echo "output:"
  echo ""
  du -hs tmp/android_lib/*
  du -hs  ${outputname}_${branch}_$1_$DATE.tar.bz2
  echo ""
}

clean () {
  rm -rf ./android_lib
  rm -rf ./tmp
}

build_arch_linux () {
  rm -rf ./android_lib/*
  export ANDROID_ABI=$1
  ./build_vision_libs.sh
  cp -r android_lib/* tmp/android_lib/
  print_header $1 
}

build_arch () {
  clean
  mkdir ./android_lib
  mkdir -p ./tmp/android_lib
  build_arch_linux "$1"
  build_package "$1"
  print_details  "$1"
}

build_package () {
  echo ""
  echo "building package.."
  cd tmp/
  DATE=`date +%Y%m%d`
  tar jcf ../${outputname}_${branch}_$1_$DATE.tar.bz2 android_lib
  cd ..
}

build_all () {
  #build_arch "x86"
  #build_arch "x86_64"
  build_arch "armeabi"
  build_arch "armeabi-v7a"
  #build_arch "arm64-v8a"
}

#########################################################
######################## MAIN ###########################
#########################################################

if [ "$1" = "" ]; then
  build_all
else
  mkdir -p ./android_lib
  mkdir -p ./tmp/android_lib

  case "$1" in
    armeabi)
      print_header "  ARMEABI  "
      build_arch $1
      ;;
    armeabi-v7a)
      print_header "ARMEABI-V7A"
      build_arch $1
      ;;
    arm64-v8a)
      print_header " ARM64-V8A "
      build_arch $1
      ;;
    x86)
      print_header "   X86    "
      build_arch $1
      ;;
    x86_64)
      print_header "  X86_64   "
      build_arch $1
      ;;
    clean)
      clean
      ;;
    package)
      print_details $2
      build_package $2
      ;;
  esac
fi

exit 0


