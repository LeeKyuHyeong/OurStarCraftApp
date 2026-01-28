package com.example.assetinsight.util;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import com.google.android.material.snackbar.Snackbar;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * UI 관련 편의 확장 함수 및 유틸리티
 */
public final class ViewExtensions {

    private static final DecimalFormat AMOUNT_FORMAT = new DecimalFormat("#,###");
    private static final NumberFormat CURRENCY_FORMAT = NumberFormat.getCurrencyInstance(Locale.KOREA);
    private static final NumberFormat PERCENT_FORMAT = NumberFormat.getPercentInstance(Locale.KOREA);

    static {
        PERCENT_FORMAT.setMaximumFractionDigits(1);
    }

    private ViewExtensions() {
        // Utility class
    }

    // ============================================
    // View 가시성 관련
    // ============================================

    /**
     * View를 VISIBLE로 설정
     */
    public static void show(View view) {
        if (view != null) {
            view.setVisibility(View.VISIBLE);
        }
    }

    /**
     * View를 GONE으로 설정
     */
    public static void hide(View view) {
        if (view != null) {
            view.setVisibility(View.GONE);
        }
    }

    /**
     * View를 INVISIBLE로 설정
     */
    public static void invisible(View view) {
        if (view != null) {
            view.setVisibility(View.INVISIBLE);
        }
    }

    /**
     * 조건에 따라 View 가시성 설정
     */
    public static void showIf(View view, boolean condition) {
        if (view != null) {
            view.setVisibility(condition ? View.VISIBLE : View.GONE);
        }
    }

    /**
     * View가 보이는지 확인
     */
    public static boolean isVisible(View view) {
        return view != null && view.getVisibility() == View.VISIBLE;
    }

    // ============================================
    // 키보드 관련
    // ============================================

    /**
     * 키보드 숨기기
     */
    public static void hideKeyboard(View view) {
        if (view != null) {
            InputMethodManager imm = (InputMethodManager) view.getContext()
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) {
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
            }
        }
    }

    /**
     * 키보드 보이기
     */
    public static void showKeyboard(View view) {
        if (view != null) {
            view.requestFocus();
            InputMethodManager imm = (InputMethodManager) view.getContext()
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) {
                imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);
            }
        }
    }

    // ============================================
    // 금액 포맷팅
    // ============================================

    /**
     * 금액을 콤마 포맷으로 변환 (예: 1,000,000)
     */
    public static String formatAmount(long amount) {
        return AMOUNT_FORMAT.format(amount);
    }

    /**
     * 금액을 통화 포맷으로 변환 (예: ₩1,000,000)
     */
    public static String formatCurrency(long amount) {
        return CURRENCY_FORMAT.format(amount);
    }

    /**
     * 금액 변화를 부호와 함께 포맷 (예: +₩100,000, -₩50,000)
     */
    public static String formatAmountChange(long change) {
        String sign = change >= 0 ? "+" : "";
        return sign + CURRENCY_FORMAT.format(change);
    }

    /**
     * 퍼센트 포맷으로 변환 (예: 10.5%)
     */
    public static String formatPercent(double percent) {
        return PERCENT_FORMAT.format(percent / 100);
    }

    /**
     * 퍼센트 변화를 부호와 함께 포맷 (예: +10.5%, -5.2%)
     */
    public static String formatPercentChange(double change) {
        String sign = change >= 0 ? "+" : "";
        return sign + String.format(Locale.KOREA, "%.1f%%", change);
    }

    /**
     * 금액 문자열에서 숫자만 추출
     */
    public static long parseAmount(String amountString) {
        if (amountString == null || amountString.isEmpty()) {
            return 0;
        }
        String cleanString = amountString.replaceAll("[^0-9]", "");
        try {
            return Long.parseLong(cleanString);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    // ============================================
    // 메시지 표시
    // ============================================

    /**
     * Toast 메시지 표시 (짧은)
     */
    public static void showToast(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }

    /**
     * Toast 메시지 표시 (긴)
     */
    public static void showToastLong(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
    }

    /**
     * Toast 메시지 표시 (리소스 ID)
     */
    public static void showToast(Context context, int resId) {
        Toast.makeText(context, resId, Toast.LENGTH_SHORT).show();
    }

    /**
     * Snackbar 메시지 표시
     */
    public static void showSnackbar(View view, String message) {
        Snackbar.make(view, message, Snackbar.LENGTH_SHORT).show();
    }

    /**
     * Snackbar 메시지 표시 (액션 포함)
     */
    public static void showSnackbar(View view, String message, String actionText, View.OnClickListener action) {
        Snackbar.make(view, message, Snackbar.LENGTH_LONG)
                .setAction(actionText, action)
                .show();
    }

    // ============================================
    // 클릭 방지 (중복 클릭 방지)
    // ============================================

    private static long lastClickTime = 0;
    private static final long CLICK_INTERVAL = 500; // 500ms

    /**
     * 중복 클릭 방지 체크
     * @return true면 클릭 허용, false면 중복 클릭
     */
    public static boolean isSafeClick() {
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastClickTime < CLICK_INTERVAL) {
            return false;
        }
        lastClickTime = currentTime;
        return true;
    }

    /**
     * 안전한 클릭 리스너 설정 (중복 클릭 방지)
     */
    public static void setOnSafeClickListener(View view, View.OnClickListener listener) {
        if (view != null) {
            view.setOnClickListener(v -> {
                if (isSafeClick()) {
                    listener.onClick(v);
                }
            });
        }
    }
}
