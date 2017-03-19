if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    echo "Preparing Code Signing certificate"
    $KEYCHAIN_PASSWORD="gsOX#$eZ#xPZYRTNSst9"
    export CERTIFICATE_P12=Certificate.p12;
    echo $SIGNING_CERTIFICATE | base64 — decode > $CERTIFICATE_P12;
    echo "Decoded p12"
    export KEYCHAIN=build.keychain;
    security create-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN;
    security default-keychain -s $KEYCHAIN;
    security unlock-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN;
    echo "Unlocked keychain"
    security import $CERTIFICATE_P12 -k $KEYCHAIN -P $CERTIFICATE_PASSWORD -T /usr/bin/codesign;
    echo "Imported signing certificate"
fi
