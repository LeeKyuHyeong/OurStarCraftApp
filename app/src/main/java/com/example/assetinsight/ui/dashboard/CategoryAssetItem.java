package com.example.assetinsight.ui.dashboard;

/**
 * 카테고리별 자산 아이템 데이터 클래스
 */
public class CategoryAssetItem {
    private final String categoryId;
    private final String categoryName;
    private final long amount;
    private final String lastUpdatedDate;
    private final double percentOfTotal;

    public CategoryAssetItem(String categoryId, String categoryName, long amount,
                             String lastUpdatedDate, double percentOfTotal) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.amount = amount;
        this.lastUpdatedDate = lastUpdatedDate;
        this.percentOfTotal = percentOfTotal;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public long getAmount() {
        return amount;
    }

    public String getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    public double getPercentOfTotal() {
        return percentOfTotal;
    }
}
