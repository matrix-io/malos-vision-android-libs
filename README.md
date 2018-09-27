# malos-vision-android-libs

Builder for MALOS C++ vision library dependencies on Android (multiarch). The current scripts build the next libraries:

- [X] boost
- [X] gflags
- [X] glog
- [X] lmdb
- [X] protobuf
- [X] protos_root
- [X] opencv
- [ ] snappy 
- [ ] leveldb

## Dependencies

Tested with `android-ndk-r15c` and `Android tools_r25.2.5`

## Building

``` bash
git submodule update --init --recursive
cd caffe-android-lib
../build_vision_builder.sh clean
../build_vision_builder.sh
```

## Output

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

