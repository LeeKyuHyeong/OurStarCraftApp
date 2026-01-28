package com.example.assetinsight.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import timber.log.Timber;

/**
 * 날짜 계산, 비교 및 포맷팅 유틸리티
 */
public final class DateUtils {

    private static final String DATE_FORMAT_DB = "yyyy-MM-dd";
    private static final String DATE_FORMAT_DISPLAY = "yyyy년 M월 d일";
    private static final String DATE_FORMAT_MONTH = "M월";
    private static final String DATE_FORMAT_FULL = "yyyy-MM-dd HH:mm:ss";

    private static final SimpleDateFormat dbFormat = new SimpleDateFormat(DATE_FORMAT_DB, Locale.getDefault());
    private static final SimpleDateFormat displayFormat = new SimpleDateFormat(DATE_FORMAT_DISPLAY, Locale.KOREA);
    private static final SimpleDateFormat monthFormat = new SimpleDateFormat(DATE_FORMAT_MONTH, Locale.KOREA);
    private static final SimpleDateFormat fullFormat = new SimpleDateFormat(DATE_FORMAT_FULL, Locale.getDefault());

    private DateUtils() {
        // Utility class
    }

    /**
     * 오늘 날짜를 DB 형식(yyyy-MM-dd)으로 반환
     */
    public static String today() {
        return dbFormat.format(new Date());
    }

    /**
     * 현재 시간을 전체 형식으로 반환
     */
    public static String now() {
        return fullFormat.format(new Date());
    }

    /**
     * Date를 DB 형식 문자열로 변환
     */
    public static String toDbFormat(Date date) {
        return dbFormat.format(date);
    }

    /**
     * Date를 표시용 문자열로 변환 (yyyy년 M월 d일)
     */
    public static String toDisplayFormat(Date date) {
        return displayFormat.format(date);
    }

    /**
     * Date를 월 표시용 문자열로 변환 (M월)
     */
    public static String toMonthFormat(Date date) {
        return monthFormat.format(date);
    }

    /**
     * DB 형식 문자열을 Date로 변환
     */
    public static Date parseDbFormat(String dateString) {
        try {
            return dbFormat.parse(dateString);
        } catch (ParseException e) {
            Timber.e(e, "Failed to parse date: %s", dateString);
            return null;
        }
    }

    /**
     * DB 형식 문자열을 표시용 문자열로 변환
     */
    public static String dbToDisplay(String dbDateString) {
        Date date = parseDbFormat(dbDateString);
        return date != null ? toDisplayFormat(date) : dbDateString;
    }

    /**
     * 오늘 기준 N일 전 날짜 반환
     */
    public static String daysAgo(int days) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -days);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 오늘 기준 N개월 전 날짜 반환
     */
    public static String monthsAgo(int months) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -months);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 오늘 기준 N년 전 날짜 반환
     */
    public static String yearsAgo(int years) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.YEAR, -years);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 특정 날짜 기준 N일 전 날짜 반환
     */
    public static String daysAgoFrom(String baseDate, int days) {
        Date date = parseDbFormat(baseDate);
        if (date == null) return baseDate;

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DAY_OF_MONTH, -days);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 특정 날짜 기준 N개월 전 날짜 반환
     */
    public static String monthsAgoFrom(String baseDate, int months) {
        Date date = parseDbFormat(baseDate);
        if (date == null) return baseDate;

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, -months);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 특정 날짜 기준 N년 전 날짜 반환
     */
    public static String yearsAgoFrom(String baseDate, int years) {
        Date date = parseDbFormat(baseDate);
        if (date == null) return baseDate;

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.YEAR, -years);
        return dbFormat.format(cal.getTime());
    }

    /**
     * 두 날짜 비교 (date1이 date2보다 이전이면 음수, 같으면 0, 이후면 양수)
     */
    public static int compare(String date1, String date2) {
        Date d1 = parseDbFormat(date1);
        Date d2 = parseDbFormat(date2);

        if (d1 == null || d2 == null) {
            return date1.compareTo(date2);
        }

        return d1.compareTo(d2);
    }

    /**
     * date1이 date2보다 이전인지 확인
     */
    public static boolean isBefore(String date1, String date2) {
        return compare(date1, date2) < 0;
    }

    /**
     * date1이 date2보다 이후인지 확인
     */
    public static boolean isAfter(String date1, String date2) {
        return compare(date1, date2) > 0;
    }

    /**
     * 두 날짜가 같은지 확인
     */
    public static boolean isSameDay(String date1, String date2) {
        return compare(date1, date2) == 0;
    }

    /**
     * 해당 월의 마지막 날짜 반환
     */
    public static String getLastDayOfMonth(int year, int month) {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1); // month is 0-based
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        return dbFormat.format(cal.getTime());
    }

    /**
     * 특정 날짜가 속한 월의 마지막 날짜 반환
     */
    public static String getLastDayOfMonth(String dateString) {
        Date date = parseDbFormat(dateString);
        if (date == null) return dateString;

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        return dbFormat.format(cal.getTime());
    }
}
