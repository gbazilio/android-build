FROM openjdk:8

ENV SDK_MANAGER_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/usr/local/android-sdk"

RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_MANAGER_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager \ 
    "build-tools;27.0.3" \
    "build-tools;28.0.2" \
    "platforms;android-27" \
    "platforms;android-28" \
    "platform-tools"

RUN $ANDROID_HOME/tools/bin/sdkmanager \ 
    "system-images;android-19;google_apis;armeabi-v7a"

RUN $ANDROID_HOME/tools/bin/sdkmanager \ 
    "emulator"

RUN echo no | \
    $ANDROID_HOME/tools/bin/avdmanager \
    create avd \
    -n test-avd \
    -k "system-images;android-19;google_apis;armeabi-v7a"

RUN mkdir /app_workdir
WORKDIR /app_workdir