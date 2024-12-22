#!/bin/sh

#  ci_post_clone.sh
#  Dayme
#
#  Created by 정동천 on 11/30/24.
#  

echo "Release.xcconfig 복원 시작"

# xcconfig 파일 생성 경로
CONFIG_FILE_PATH="/Volumes/workspace/repository/Release.xcconfig"

# 환경 변수에서 값을 가져와서 xcconfig 파일에 추가하기
echo "SERVER_BASE_URL = $SERVER_BASE_URL" >> "$CONFIG_FILE_PATH"
echo "FIREBASE_CLIENT_ID = $FIREBASE_CLIENT_ID" >> "$CONFIG_FILE_PATH"
echo "KAKAO_APP_KEY = $KAKAO_APP_KEY" >> "$CONFIG_FILE_PATH"
echo "KEYCHAIN_ACCESS_TOKEN_KEY = $KEYCHAIN_ACCESS_TOKEN_KEY" >> "$CONFIG_FILE_PATH"
echo "KEYCHAIN_REFRESH_TOKEN_KEY = $KEYCHAIN_REFRESH_TOKEN_KEY" >> "$CONFIG_FILE_PATH"

# 생성된 *.xconfig 파일 내용 출력
cat "$CONFIG_FILE_PATH"

echo "Release.xcconfig 복원 완료"
