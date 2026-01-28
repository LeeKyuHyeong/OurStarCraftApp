package com.example.assetinsight.data.local;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * 카테고리 엔티티
 * - 사용자 정의 자산 카테고리 관리
 */
@Entity(tableName = "category")
public class Category {

    @PrimaryKey
    @NonNull
    private String id;

    @NonNull
    private String name;

    private String icon; // 아이콘 리소스 이름

    private int sortOrder; // 정렬 순서

    private boolean isDefault; // 기본 카테고리 여부

    public Category(@NonNull String id, @NonNull String name, String icon, int sortOrder, boolean isDefault) {
        this.id = id;
        this.name = name;
        this.icon = icon;
        this.sortOrder = sortOrder;
        this.isDefault = isDefault;
    }

    @NonNull
    public String getId() {
        return id;
    }

    public void setId(@NonNull String id) {
        this.id = id;
    }

    @NonNull
    public String getName() {
        return name;
    }

    public void setName(@NonNull String name) {
        this.name = name;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
}
