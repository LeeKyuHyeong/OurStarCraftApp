# ============================================
# Asset Insight Android Build Environment
# ============================================
FROM eclipse-temurin:17-jdk

LABEL maintainer="AssetInsight"
LABEL description="Android SDK build environment for Asset Insight"

# 환경 변수 설정
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# 필수 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Android SDK 설치
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# SDK 라이선스 동의
RUN yes | sdkmanager --licenses > /dev/null 2>&1

# 필요한 SDK 패키지 설치
RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"

# 작업 디렉토리 설정
WORKDIR /app

# Gradle 캐시 최적화를 위한 볼륨
VOLUME ["/root/.gradle"]

# 기본 명령어
CMD ["./gradlew", "assembleDebug"]
