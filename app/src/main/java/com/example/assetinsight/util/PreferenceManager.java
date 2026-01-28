package com.example.assetinsight.util;

import android.content.Context;
import android.content.SharedPreferences;

import androidx.appcompat.app.AppCompatDelegate;

/**
 * 앱 설정 관리 클래스
 */
public class PreferenceManager {

    private static final String PREF_NAME = "asset_insight_prefs";

    // 보안 설정
    private static final String KEY_BIOMETRIC_ENABLED = "biometric_enabled";
    private static final String KEY_SCREEN_SECURITY_ENABLED = "screen_security_enabled";

    // 표시 설정
    private static final String KEY_CURRENCY = "currency";
    private static final String KEY_THEME = "theme";

    // 기본값
    public static final boolean DEFAULT_BIOMETRIC_ENABLED = true;
    public static final boolean DEFAULT_SCREEN_SECURITY_ENABLED = true;
    public static final String DEFAULT_CURRENCY = "KRW";
    public static final int DEFAULT_THEME = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM;

    // 통화 옵션
    public static final String[] CURRENCY_CODES = {"KRW", "USD", "EUR", "JPY", "CNY"};
    public static final String[] CURRENCY_NAMES = {"KRW (₩)", "USD ($)", "EUR (€)", "JPY (¥)", "CNY (¥)"};
    public static final String[] CURRENCY_SYMBOLS = {"₩", "$", "€", "¥", "¥"};

    // 테마 옵션
    public static final int[] THEME_VALUES = {
            AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM,
            AppCompatDelegate.MODE_NIGHT_NO,
            AppCompatDelegate.MODE_NIGHT_YES
    };

    private final SharedPreferences prefs;

    public PreferenceManager(Context context) {
        prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
    }

    // 생체인증 설정
    public boolean isBiometricEnabled() {
        return prefs.getBoolean(KEY_BIOMETRIC_ENABLED, DEFAULT_BIOMETRIC_ENABLED);
    }

    public void setBiometricEnabled(boolean enabled) {
        prefs.edit().putBoolean(KEY_BIOMETRIC_ENABLED, enabled).apply();
    }

    // 화면 보안 설정
    public boolean isScreenSecurityEnabled() {
        return prefs.getBoolean(KEY_SCREEN_SECURITY_ENABLED, DEFAULT_SCREEN_SECURITY_ENABLED);
    }

    public void setScreenSecurityEnabled(boolean enabled) {
        prefs.edit().putBoolean(KEY_SCREEN_SECURITY_ENABLED, enabled).apply();
    }

    // 통화 설정
    public String getCurrency() {
        return prefs.getString(KEY_CURRENCY, DEFAULT_CURRENCY);
    }

    public void setCurrency(String currency) {
        prefs.edit().putString(KEY_CURRENCY, currency).apply();
    }

    public String getCurrencySymbol() {
        String currency = getCurrency();
        for (int i = 0; i < CURRENCY_CODES.length; i++) {
            if (CURRENCY_CODES[i].equals(currency)) {
                return CURRENCY_SYMBOLS[i];
            }
        }
        return "₩";
    }

    public String getCurrencyDisplayName() {
        String currency = getCurrency();
        for (int i = 0; i < CURRENCY_CODES.length; i++) {
            if (CURRENCY_CODES[i].equals(currency)) {
                return CURRENCY_NAMES[i];
            }
        }
        return CURRENCY_NAMES[0];
    }

    public int getCurrencyIndex() {
        String currency = getCurrency();
        for (int i = 0; i < CURRENCY_CODES.length; i++) {
            if (CURRENCY_CODES[i].equals(currency)) {
                return i;
            }
        }
        return 0;
    }

    // 테마 설정
    public int getTheme() {
        return prefs.getInt(KEY_THEME, DEFAULT_THEME);
    }

    public void setTheme(int themeMode) {
        prefs.edit().putInt(KEY_THEME, themeMode).apply();
    }

    public int getThemeIndex() {
        int theme = getTheme();
        for (int i = 0; i < THEME_VALUES.length; i++) {
            if (THEME_VALUES[i] == theme) {
                return i;
            }
        }
        return 0;
    }

    // 테마 적용
    public void applyTheme() {
        AppCompatDelegate.setDefaultNightMode(getTheme());
    }

    // 모든 설정 초기화
    public void resetAll() {
        prefs.edit().clear().apply();
    }
}
