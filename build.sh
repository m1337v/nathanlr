#!/bin/sh

set -e

# Clean previous build
rm -rf build 2>/dev/null || true

echo "Building IPA"

xcodebuild clean build \
  -scheme NathanLR \
  -configuration Release \
  -derivedDataPath build/DerivedData \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

echo "done building"

cd build/DerivedData/Build/Products/Release-iphoneos

rm -rf Payload nathanlr.tipa
mkdir Payload
mv NathanLR.app Payload

codesign -f -s - \
  --entitlements ../../../../../usprebooter/usprebooter.entitlements \
  --identifier com.nathan.nathanlr \
  Payload/NathanLR.app/NathanLR

cp ../../../../../bins/* Payload/NathanLR.app/

zip -vr nathanlr.tipa Payload/ -x "*.DS_Store"

rm -rf Payload

cd ../../../../../

echo "IPA created at build/DerivedData/Build/Products/Release-iphoneos/nathanlr.tipa"
