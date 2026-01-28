package com.example.assetinsight;

import android.app.Application;

import timber.log.Timber;

/**
 * 전역 애플리케이션 설정 및 Timber 로깅 초기화
 */
public class AssetInsightApp extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        // Timber 초기화 - Debug 빌드에서만 로그 출력
        if (isDebugBuild()) {
            Timber.plant(new Timber.DebugTree());
            Timber.d("Timber initialized in DEBUG mode");
        }
        // Release 빌드에서는 로그 출력하지 않음 (보안)
    }

    private boolean isDebugBuild() {
        return (getApplicationInfo().flags & android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE) != 0;
    }
}
