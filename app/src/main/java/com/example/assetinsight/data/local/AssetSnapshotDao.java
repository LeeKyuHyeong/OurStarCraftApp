package com.example.assetinsight.data.local;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;

/**
 * 자산 스냅샷 DAO
 * - UPSERT 전략: 동일 날짜+카테고리 입력 시 덮어쓰기
 */
@Dao
public interface AssetSnapshotDao {

    /**
     * 스냅샷 저장 (UPSERT)
     * 동일한 date + categoryId가 존재하면 덮어쓰기
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void upsert(AssetSnapshot snapshot);

    /**
     * 여러 스냅샷 일괄 저장
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void upsertAll(List<AssetSnapshot> snapshots);

    /**
     * 특정 날짜의 모든 카테고리 스냅샷 조회
     */
    @Query("SELECT * FROM asset_snapshot WHERE date = :date")
    List<AssetSnapshot> getSnapshotsByDate(String date);

    /**
     * 특정 카테고리의 특정 날짜 또는 가장 가까운 과거 데이터 조회
     * (데이터 보간 로직의 핵심 쿼리)
     */
    @Query("SELECT * FROM asset_snapshot " +
           "WHERE categoryId = :categoryId AND date <= :targetDate " +
           "ORDER BY date DESC LIMIT 1")
    AssetSnapshot getClosestSnapshot(String categoryId, String targetDate);

    /**
     * 특정 날짜 기준 모든 카테고리의 가장 가까운 과거 금액 합계
     * (전체 자산 총액 계산용)
     */
    @Query("SELECT SUM(amount) FROM (" +
           "SELECT amount FROM asset_snapshot AS a " +
           "WHERE date = (SELECT MAX(date) FROM asset_snapshot " +
           "WHERE categoryId = a.categoryId AND date <= :targetDate) " +
           "GROUP BY categoryId)")
    Long getTotalAmountAtDate(String targetDate);

    /**
     * 특정 카테고리의 모든 기록 조회 (날짜순)
     */
    @Query("SELECT * FROM asset_snapshot WHERE categoryId = :categoryId ORDER BY date ASC")
    List<AssetSnapshot> getSnapshotsByCategory(String categoryId);

    /**
     * 모든 스냅샷 조회
     */
    @Query("SELECT * FROM asset_snapshot ORDER BY date DESC, categoryId ASC")
    List<AssetSnapshot> getAllSnapshots();

    /**
     * 특정 스냅샷 삭제
     */
    @Query("DELETE FROM asset_snapshot WHERE date = :date AND categoryId = :categoryId")
    void delete(String date, String categoryId);

    /**
     * 모든 스냅샷 삭제
     */
    @Query("DELETE FROM asset_snapshot")
    void deleteAll();

    /**
     * 특정 카테고리의 모든 스냅샷 삭제
     */
    @Query("DELETE FROM asset_snapshot WHERE categoryId = :categoryId")
    void deleteByCategory(String categoryId);

    /**
     * 등록된 카테고리 ID 목록 조회 (중복 제거)
     */
    @Query("SELECT DISTINCT categoryId FROM asset_snapshot ORDER BY categoryId")
    List<String> getAllCategoryIds();
}
