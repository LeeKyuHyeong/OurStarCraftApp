package com.example.assetinsight.data.local;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.Index;

/**
 * 자산 스냅샷 엔티티
 * - 날짜별 각 카테고리의 자산 금액을 기록
 * - Composite Primary Key: date + categoryId
 */
@Entity(
    tableName = "asset_snapshot",
    primaryKeys = {"date", "categoryId"},
    indices = {
        @Index(value = {"categoryId", "date"})
    }
)
public class AssetSnapshot {

    @NonNull
    private String date; // yyyy-MM-dd 형식

    @NonNull
    private String categoryId;

    private long amount;

    private String memo;

    public AssetSnapshot(@NonNull String date, @NonNull String categoryId, long amount, String memo) {
        this.date = date;
        this.categoryId = categoryId;
        this.amount = amount;
        this.memo = memo;
    }

    @NonNull
    public String getDate() {
        return date;
    }

    public void setDate(@NonNull String date) {
        this.date = date;
    }

    @NonNull
    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(@NonNull String categoryId) {
        this.categoryId = categoryId;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
