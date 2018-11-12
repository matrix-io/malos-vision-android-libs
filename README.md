# malos-vision-android-libs

Builder for MALOS C++ vision library dependencies on Android (multiarch). The current scripts build the next libraries:

- [X] boost
- [X] gflags
- [X] glog
- [X] lmdb
- [X] protobuf
- [x] protobuf-host
- [X] crossguid
- [X] opencv
- [X] libzmq
- [X] matrixio_protos
- [X] matrix-malos-lib
- [ ] snappy 
- [ ] leveldb

## Dependencies

Tested with `android-ndk-r15c` and `Android tools_r25.2.5`. Please check also the `OpenCV` version. Current tests are in 3.4.3

## Docker Building

In order to build easily you will need `docker-compose` installed

``` bash
git clone https://github.com/matrix-io/malos-vision-android-libs.git
cd malos-vision-android-libs
docker-compose up --build libs-builder
```

## Local Building

``` bash
git clone https://github.com/matrix-io/malos-vision-android-libs.git
cd malos-vision-android-libs
git submodule update --init --recursive
cd caffe-android-lib
../builder.sh clean
../builder.sh armeabi-v7a
```

## Output

the output packages are generated in root directory:

``` bash
android_vision_libs_3.1.0_armeabi_20180927.tar.bz2
android_vision_libs_3.1.0_armeabi-v7a_20180927.tar.bz2
```

## Troubleshooting

if you get error on compile some libraries dependencies please try change in `caffe-android-lib/config.sh`:

``` bash
#ANDROID_ABI="armeabi-v7a-hard-softfp with NEON" to
ANDROID_ABI="armeabi-v7a"
```

