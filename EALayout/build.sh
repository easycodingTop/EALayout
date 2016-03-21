
TargetName=EALayout

rm -rf $TargetName.framework 

xcodebuild -configuration "Release" -target $TargetName -sdk iphoneos clean build
xcodebuild -configuration "Release" -target $TargetName -sdk iphonesimulator clean build

lipo -create build/Release-iphoneos/$TargetName.framework/$TargetName build/Release-iphonesimulator/$TargetName.framework/$TargetName -output __TempFile

mv __TempFile build/Release-iphoneos/$TargetName.framework/$TargetName

cp -rf  build/Release-iphoneos/$TargetName.framework .

rm -rf build

rm -rf ./$TargetName.framework/Modules

rm -rf ./$TargetName.framework/_CodeSignature

