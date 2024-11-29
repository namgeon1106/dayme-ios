#!/bin/sh

#  ci_post_clone.sh
#  Dayme
#
#  Created by 정동천 on 11/30/24.
#  

echo "Release.xcconfig 복원 시작"

# xcconfig 파일 생성 경로
CONFIG_FILE_PATH="/Volumes/workspace/repository/Dayme/Release.xcconfig"

# 환경 변수에서 값을 가져와서 xcconfig 파일에 추가하기
echo "SERVER_BASE_URL = $SERVER_BASE_URL" >> "$CONFIG_FILE_PATH"
echo "FIREBASE_CLIENT_ID = $FIREBASE_CLIENT_ID" >> "$CONFIG_FILE_PATH"
echo "KAKAO_APP_KEY = $KAKAO_APP_KEY" >> "$CONFIG_FILE_PATH"
echo "KEYCHAIN_ACCESS_TOKEN_KEY = $KEYCHAIN_ACCESS_TOKEN_KEY" >> "$CONFIG_FILE_PATH"
echo "KEYCHAIN_REFRESH_TOKEN_KEY = $KEYCHAIN_REFRESH_TOKEN_KEY" >> "$CONFIG_FILE_PATH"

# 생성된 *.xconfig 파일 내용 출력
cat "$CONFIG_FILE_PATH"

echo "Release.xcconfig 복원 완료"


echo "GoogleService-Info.plist 복원 시작"

# Boolean 값 변환
convert_bool() {
    if [ "$1" == "true" ]; then
        echo "<true/>"
    else
        echo "<false/>"
    fi
}

cat <<EOF > "/Volumes/workspace/repository/Dayme/Resource/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string>$(CLIENT_ID)</string>
    <key>REVERSED_CLIENT_ID</key>
    <string>$(REVERSED_CLIENT_ID)</string>
    <key>API_KEY</key>
    <string>$(API_KEY)</string>
    <key>GCM_SENDER_ID</key>
    <string>$(GCM_SENDER_ID)</string>
    <key>PLIST_VERSION</key>
    <string>$(PLIST_VERSION)</string>
    <key>BUNDLE_ID</key>
    <string>$(BUNDLE_ID)</string>
    <key>PROJECT_ID</key>
    <string>$(PROJECT_ID)</string>
    <key>STORAGE_BUCKET</key>
    <string>$(STORAGE_BUCKET)</string>
    <key>IS_ADS_ENABLED</key>
    `convert_bool ${IS_ADS_ENABLED}`
    <key>IS_ANALYTICS_ENABLED</key>
    `convert_bool ${IS_ANALYTICS_ENABLED}`
    <key>IS_APPINVITE_ENABLED</key>
    `convert_bool ${IS_APPINVITE_ENABLED}`
    <key>IS_GCM_ENABLED</key>
    `convert_bool ${IS_GCM_ENABLED}`
    <key>IS_SIGNIN_ENABLED</key>
    `convert_bool ${IS_SIGNIN_ENABLED}`
    <key>GOOGLE_APP_ID</key>
    <string>$(GOOGLE_APP_ID)</string>
</dict>
</plist>
EOF
echo "GoogleService-Info.plist 복원 완료"
