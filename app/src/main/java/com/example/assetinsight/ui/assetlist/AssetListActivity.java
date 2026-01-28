package com.example.assetinsight.ui.assetlist;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.data.repository.AssetRepository;
import com.example.assetinsight.databinding.ActivityAssetListBinding;
import com.example.assetinsight.ui.input.InputActivity;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.SecurityHelper;
import com.google.android.material.chip.Chip;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class AssetListActivity extends AppCompatActivity {

    private ActivityAssetListBinding binding;
    private AssetRepository repository;
    private AppDatabase database;
    private AssetListAdapter adapter;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private final Map<String, String> categoryNames = new HashMap<>();
    private List<Category> categories = new ArrayList<>();
    private String selectedCategoryId = null; // null = 전체

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityAssetListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SecurityHelper.enableScreenSecurity(this);

        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        database = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());
        repository = new AssetRepository(this, DatabaseKeyManager.getKey());

        setupToolbar();
        setupRecyclerView();
        loadCategories();
    }

    private void setupToolbar() {
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupRecyclerView() {
        adapter = new AssetListAdapter();
        adapter.setOnAssetClickListener(this::onAssetClick);
        adapter.setOnAssetDeleteListener(this::onAssetDelete);

        binding.rvAssets.setLayoutManager(new LinearLayoutManager(this));
        binding.rvAssets.setAdapter(adapter);
    }

    private void loadCategories() {
        showLoading(true);

        executor.execute(() -> {
            categories = database.categoryDao().getAllCategories();

            categoryNames.clear();
            for (Category category : categories) {
                categoryNames.put(category.getId(), category.getName());
            }

            runOnUiThread(() -> {
                adapter.setCategoryNames(categoryNames);
                setupFilterChips();
                loadAssets();
            });
        });
    }

    private void setupFilterChips() {
        // 기존 칩 유지 (전체)
        binding.chipAll.setOnCheckedChangeListener((chip, isChecked) -> {
            if (isChecked) {
                selectedCategoryId = null;
                loadAssets();
            }
        });

        // 카테고리별 칩 추가
        for (Category category : categories) {
            Chip chip = new Chip(this);
            chip.setText(category.getName());
            chip.setCheckable(true);
            chip.setId(View.generateViewId());

            chip.setOnCheckedChangeListener((buttonView, isChecked) -> {
                if (isChecked) {
                    selectedCategoryId = category.getId();
                    loadAssets();
                }
            });

            binding.chipGroupFilter.addView(chip);
        }
    }

    private void loadAssets() {
        showLoading(true);

        if (selectedCategoryId == null) {
            // 전체 조회
            repository.getAllSnapshots(snapshots -> {
                runOnUiThread(() -> {
                    updateList(snapshots);
                    showLoading(false);
                });
            });
        } else {
            // 카테고리별 조회
            repository.getSnapshotsByCategory(selectedCategoryId, snapshots -> {
                // 날짜 내림차순 정렬
                List<AssetSnapshot> sorted = new ArrayList<>(snapshots);
                sorted.sort((a, b) -> b.getDate().compareTo(a.getDate()));

                runOnUiThread(() -> {
                    updateList(sorted);
                    showLoading(false);
                });
            });
        }
    }

    private void updateList(List<AssetSnapshot> snapshots) {
        adapter.submitList(snapshots);

        if (snapshots == null || snapshots.isEmpty()) {
            binding.rvAssets.setVisibility(View.GONE);
            binding.emptyView.setVisibility(View.VISIBLE);
        } else {
            binding.rvAssets.setVisibility(View.VISIBLE);
            binding.emptyView.setVisibility(View.GONE);
        }
    }

    private void showLoading(boolean show) {
        binding.progressBar.setVisibility(show ? View.VISIBLE : View.GONE);
    }

    private void onAssetClick(AssetSnapshot snapshot) {
        // InputActivity로 이동하여 수정
        Intent intent = new Intent(this, InputActivity.class);
        intent.putExtra("edit_date", snapshot.getDate());
        intent.putExtra("edit_category_id", snapshot.getCategoryId());
        intent.putExtra("edit_amount", snapshot.getAmount());
        intent.putExtra("edit_memo", snapshot.getMemo());
        startActivity(intent);
    }

    private void onAssetDelete(AssetSnapshot snapshot) {
        String categoryName = categoryNames.getOrDefault(snapshot.getCategoryId(), "");

        new AlertDialog.Builder(this)
                .setTitle(R.string.asset_list_delete_title)
                .setMessage(getString(R.string.asset_list_delete_confirm, categoryName, snapshot.getDate()))
                .setPositiveButton(R.string.btn_delete, (dialog, which) -> {
                    repository.deleteSnapshot(snapshot.getDate(), snapshot.getCategoryId(), () -> {
                        runOnUiThread(() -> {
                            Toast.makeText(this, R.string.asset_list_delete_success, Toast.LENGTH_SHORT).show();
                            loadAssets();
                        });
                    });
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 수정 후 돌아왔을 때 목록 새로고침
        if (adapter != null && !categoryNames.isEmpty()) {
            loadAssets();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
