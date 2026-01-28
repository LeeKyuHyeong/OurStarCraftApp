package com.example.assetinsight.data.local;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

/**
 * SQLCipher 유틸리티 클래스
 * - 암호화 키 변환 및 관리
 */
public class SQLCipherUtils {

    private SQLCipherUtils() {
        // Utility class
    }

    /**
     * char[] 암호를 byte[]로 변환
     * 변환 후 원본 char[]는 보안을 위해 초기화됨
     */
    public static byte[] getKey(char[] passphrase) {
        CharBuffer charBuffer = CharBuffer.wrap(passphrase);
        ByteBuffer byteBuffer = StandardCharsets.UTF_8.encode(charBuffer);

        byte[] key = Arrays.copyOfRange(byteBuffer.array(),
                byteBuffer.position(), byteBuffer.limit());

        // 보안을 위해 버퍼 초기화
        Arrays.fill(charBuffer.array(), '\u0000');
        Arrays.fill(byteBuffer.array(), (byte) 0);

        return key;
    }

    /**
     * 바이트 배열 보안 초기화
     */
    public static void clearKey(byte[] key) {
        if (key != null) {
            Arrays.fill(key, (byte) 0);
        }
    }

    /**
     * 문자 배열 보안 초기화
     */
    public static void clearPassphrase(char[] passphrase) {
        if (passphrase != null) {
            Arrays.fill(passphrase, '\u0000');
        }
    }
}
