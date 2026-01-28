package com.example.assetinsight.ui.dashboard;

/**
 * 인사이트 데이터 클래스 (시점별 증감)
 */
public class InsightData {
    private final long currentAmount;
    private final long pastAmount;
    private final long changeAmount;
    private final double changePercent;
    private final boolean hasData;

    public InsightData(long currentAmount, long pastAmount) {
        this.currentAmount = currentAmount;
        this.pastAmount = pastAmount;
        this.changeAmount = currentAmount - pastAmount;

        if (pastAmount != 0) {
            this.changePercent = ((double) changeAmount / pastAmount) * 100;
            this.hasData = true;
        } else if (currentAmount != 0) {
            this.changePercent = 100.0;
            this.hasData = true;
        } else {
            this.changePercent = 0;
            this.hasData = false;
        }
    }

    public static InsightData noData() {
        return new InsightData(0, 0);
    }

    public long getCurrentAmount() {
        return currentAmount;
    }

    public long getPastAmount() {
        return pastAmount;
    }

    public long getChangeAmount() {
        return changeAmount;
    }

    public double getChangePercent() {
        return changePercent;
    }

    public boolean hasData() {
        return hasData;
    }

    public boolean isPositive() {
        return changeAmount >= 0;
    }
}
