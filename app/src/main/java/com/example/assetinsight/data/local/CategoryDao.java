package com.example.assetinsight.data.local;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

/**
 * 카테고리 DAO
 */
@Dao
public interface CategoryDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insert(Category category);

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insertAll(List<Category> categories);

    @Update
    void update(Category category);

    @Delete
    void delete(Category category);

    @Query("DELETE FROM category WHERE id = :id")
    void deleteById(String id);

    @Query("SELECT * FROM category ORDER BY sortOrder ASC")
    List<Category> getAllCategories();

    @Query("SELECT * FROM category WHERE id = :id")
    Category getCategoryById(String id);

    @Query("SELECT COUNT(*) FROM category")
    int getCategoryCount();

    @Query("SELECT MAX(sortOrder) FROM category")
    int getMaxSortOrder();

    @Query("SELECT * FROM category WHERE isDefault = 1")
    List<Category> getDefaultCategories();

    @Query("UPDATE category SET sortOrder = :sortOrder WHERE id = :id")
    void updateSortOrder(String id, int sortOrder);
}
