package com.example.assetinsight.util;

import com.example.assetinsight.BuildConfig;

/**
 * 데이터베이스 암호화 키 관리
 * - local.properties에서 로드된 키를 BuildConfig를 통해 접근
 * - Release 빌드에서는 난독화되어 보호됨
 */
public final class DatabaseKeyManager {

    private DatabaseKeyManager() {
        // Utility class
    }

    /**
     * DB 암호화 키 반환
     * @return char[] 형태의 암호화 키
     */
    public static char[] getKey() {
        return BuildConfig.DB_KEY.toCharArray();
    }

    /**
     * DB 암호화 키를 안전하게 삭제
     * @param key 삭제할 키 배열
     */
    public static void clearKey(char[] key) {
        if (key != null) {
            java.util.Arrays.fill(key, '\u0000');
        }
    }
}
