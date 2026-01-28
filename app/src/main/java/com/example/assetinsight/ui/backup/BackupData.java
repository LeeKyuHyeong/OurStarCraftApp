package com.example.assetinsight.ui.backup;

import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.local.Category;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * 백업 데이터 구조
 */
public class BackupData {
    private static final int BACKUP_VERSION = 1;

    private String backupDate;
    private int version;
    private List<Category> categories;
    private List<AssetSnapshot> snapshots;

    public BackupData(String backupDate, List<Category> categories, List<AssetSnapshot> snapshots) {
        this.backupDate = backupDate;
        this.version = BACKUP_VERSION;
        this.categories = categories;
        this.snapshots = snapshots;
    }

    public String getBackupDate() {
        return backupDate;
    }

    public int getVersion() {
        return version;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public List<AssetSnapshot> getSnapshots() {
        return snapshots;
    }

    /**
     * JSON 문자열로 변환
     */
    public String toJson() throws JSONException {
        JSONObject root = new JSONObject();
        root.put("backupDate", backupDate);
        root.put("version", version);

        // 카테고리
        JSONArray categoriesArray = new JSONArray();
        for (Category category : categories) {
            JSONObject catObj = new JSONObject();
            catObj.put("id", category.getId());
            catObj.put("name", category.getName());
            catObj.put("icon", category.getIcon());
            catObj.put("sortOrder", category.getSortOrder());
            catObj.put("isDefault", category.isDefault());
            categoriesArray.put(catObj);
        }
        root.put("categories", categoriesArray);

        // 스냅샷
        JSONArray snapshotsArray = new JSONArray();
        for (AssetSnapshot snapshot : snapshots) {
            JSONObject snapObj = new JSONObject();
            snapObj.put("date", snapshot.getDate());
            snapObj.put("categoryId", snapshot.getCategoryId());
            snapObj.put("amount", snapshot.getAmount());
            snapObj.put("memo", snapshot.getMemo());
            snapshotsArray.put(snapObj);
        }
        root.put("snapshots", snapshotsArray);

        return root.toString(2);
    }

    /**
     * JSON 문자열에서 파싱
     */
    public static BackupData fromJson(String json) throws JSONException {
        JSONObject root = new JSONObject(json);

        String backupDate = root.getString("backupDate");

        // 카테고리
        List<Category> categories = new ArrayList<>();
        JSONArray categoriesArray = root.getJSONArray("categories");
        for (int i = 0; i < categoriesArray.length(); i++) {
            JSONObject catObj = categoriesArray.getJSONObject(i);
            Category category = new Category(
                    catObj.getString("id"),
                    catObj.getString("name"),
                    catObj.optString("icon", "ic_category_default"),
                    catObj.getInt("sortOrder"),
                    catObj.getBoolean("isDefault")
            );
            categories.add(category);
        }

        // 스냅샷
        List<AssetSnapshot> snapshots = new ArrayList<>();
        JSONArray snapshotsArray = root.getJSONArray("snapshots");
        for (int i = 0; i < snapshotsArray.length(); i++) {
            JSONObject snapObj = snapshotsArray.getJSONObject(i);
            AssetSnapshot snapshot = new AssetSnapshot(
                    snapObj.getString("date"),
                    snapObj.getString("categoryId"),
                    snapObj.getLong("amount"),
                    snapObj.optString("memo", null)
            );
            snapshots.add(snapshot);
        }

        return new BackupData(backupDate, categories, snapshots);
    }
}
