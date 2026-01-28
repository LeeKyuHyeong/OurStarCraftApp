# ============================================
# Asset Insight ProGuard Rules
# ============================================

# 디버깅을 위한 라인 번호 유지
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ============================================
# Room Database
# ============================================
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class *
-dontwarn androidx.room.paging.**

# ============================================
# SQLCipher
# ============================================
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }
-dontwarn net.sqlcipher.**

# ============================================
# MPAndroidChart
# ============================================
-keep class com.github.mikephil.charting.** { *; }
-dontwarn com.github.mikephil.charting.**

# ============================================
# Data Classes (Entity, Model)
# ============================================
-keep class com.example.assetinsight.data.local.** { *; }
-keep class com.example.assetinsight.ui.dashboard.CategoryAssetItem { *; }
-keep class com.example.assetinsight.ui.dashboard.InsightData { *; }
-keep class com.example.assetinsight.ui.backup.BackupData { *; }

# ============================================
# Biometric
# ============================================
-keep class androidx.biometric.** { *; }

# ============================================
# JSON (org.json)
# ============================================
-keepclassmembers class * {
    @org.json.* <fields>;
}

# ============================================
# Enum 보존
# ============================================
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ============================================
# Serializable 보존
# ============================================
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ============================================
# ViewBinding
# ============================================
-keep class * implements androidx.viewbinding.ViewBinding {
    public static * inflate(android.view.LayoutInflater);
    public static * inflate(android.view.LayoutInflater, android.view.ViewGroup, boolean);
}

# ============================================
# 경고 무시
# ============================================
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
