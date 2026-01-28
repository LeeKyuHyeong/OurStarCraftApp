package com.example.assetinsight.data.repository;

import android.content.Context;

import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.local.AssetSnapshotDao;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 자산 데이터 Repository
 * - 데이터 소스 결정 및 비즈니스 로직 중재
 * - 비동기 처리를 위한 ExecutorService 활용
 */
public class AssetRepository {

    private final AssetSnapshotDao dao;
    private final ExecutorService executor;

    public AssetRepository(Context context, char[] passphrase) {
        AppDatabase db = AppDatabase.getInstance(context, passphrase);
        this.dao = db.assetSnapshotDao();
        this.executor = Executors.newSingleThreadExecutor();
    }

    /**
     * 스냅샷 저장 (비동기)
     */
    public void saveSnapshot(AssetSnapshot snapshot, Runnable onComplete) {
        executor.execute(() -> {
            dao.upsert(snapshot);
            if (onComplete != null) {
                onComplete.run();
            }
        });
    }

    /**
     * 여러 스냅샷 일괄 저장 (비동기)
     */
    public void saveSnapshots(List<AssetSnapshot> snapshots, Runnable onComplete) {
        executor.execute(() -> {
            dao.upsertAll(snapshots);
            if (onComplete != null) {
                onComplete.run();
            }
        });
    }

    /**
     * 특정 날짜의 스냅샷 조회 (콜백)
     */
    public void getSnapshotsByDate(String date, DataCallback<List<AssetSnapshot>> callback) {
        executor.execute(() -> {
            List<AssetSnapshot> result = dao.getSnapshotsByDate(date);
            callback.onResult(result);
        });
    }

    /**
     * 특정 카테고리의 특정 시점 또는 가장 가까운 과거 데이터 조회
     */
    public void getClosestSnapshot(String categoryId, String targetDate,
                                   DataCallback<AssetSnapshot> callback) {
        executor.execute(() -> {
            AssetSnapshot result = dao.getClosestSnapshot(categoryId, targetDate);
            callback.onResult(result);
        });
    }

    /**
     * 특정 날짜 기준 전체 자산 총액 조회
     */
    public void getTotalAmountAtDate(String targetDate, DataCallback<Long> callback) {
        executor.execute(() -> {
            Long result = dao.getTotalAmountAtDate(targetDate);
            callback.onResult(result != null ? result : 0L);
        });
    }

    /**
     * 모든 카테고리 ID 조회
     */
    public void getAllCategoryIds(DataCallback<List<String>> callback) {
        executor.execute(() -> {
            List<String> result = dao.getAllCategoryIds();
            callback.onResult(result);
        });
    }

    /**
     * 특정 카테고리의 모든 기록 조회
     */
    public void getSnapshotsByCategory(String categoryId, DataCallback<List<AssetSnapshot>> callback) {
        executor.execute(() -> {
            List<AssetSnapshot> result = dao.getSnapshotsByCategory(categoryId);
            callback.onResult(result);
        });
    }

    /**
     * 모든 스냅샷 조회
     */
    public void getAllSnapshots(DataCallback<List<AssetSnapshot>> callback) {
        executor.execute(() -> {
            List<AssetSnapshot> result = dao.getAllSnapshots();
            callback.onResult(result);
        });
    }

    /**
     * 스냅샷 삭제
     */
    public void deleteSnapshot(String date, String categoryId, Runnable onComplete) {
        executor.execute(() -> {
            dao.delete(date, categoryId);
            if (onComplete != null) {
                onComplete.run();
            }
        });
    }

    /**
     * 비동기 결과 콜백 인터페이스
     */
    public interface DataCallback<T> {
        void onResult(T result);
    }
}
