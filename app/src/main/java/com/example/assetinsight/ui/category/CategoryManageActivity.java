package com.example.assetinsight.ui.category;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.ItemTouchHelper;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.data.local.CategoryDao;
import com.example.assetinsight.databinding.ActivityCategoryManageBinding;
import com.example.assetinsight.databinding.DialogCategoryEditBinding;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.SecurityHelper;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class CategoryManageActivity extends AppCompatActivity {

    private ActivityCategoryManageBinding binding;
    private CategoryManageAdapter adapter;
    private CategoryDao categoryDao;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityCategoryManageBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SecurityHelper.enableScreenSecurity(this);

        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        // TODO: DB 암호화 키 관리
        AppDatabase db = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());
        db.ensureDefaultCategories();
        categoryDao = db.categoryDao();

        setupToolbar();
        setupRecyclerView();
        setupFab();
        loadCategories();
    }

    private void setupToolbar() {
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupRecyclerView() {
        adapter = new CategoryManageAdapter();
        adapter.setListener(new CategoryManageAdapter.OnCategoryActionListener() {
            @Override
            public void onEdit(Category category) {
                showEditDialog(category);
            }

            @Override
            public void onDelete(Category category) {
                showDeleteConfirmDialog(category);
            }

            @Override
            public void onOrderChanged(List<Category> newOrder) {
                updateCategoryOrder(newOrder);
            }
        });

        binding.rvCategories.setLayoutManager(new LinearLayoutManager(this));
        binding.rvCategories.setAdapter(adapter);

        // 드래그 앤 드롭
        ItemTouchHelper.SimpleCallback callback = new ItemTouchHelper.SimpleCallback(
                ItemTouchHelper.UP | ItemTouchHelper.DOWN, 0) {
            @Override
            public boolean onMove(@androidx.annotation.NonNull RecyclerView recyclerView,
                                  @androidx.annotation.NonNull RecyclerView.ViewHolder viewHolder,
                                  @androidx.annotation.NonNull RecyclerView.ViewHolder target) {
                adapter.moveItem(viewHolder.getAdapterPosition(), target.getAdapterPosition());
                return true;
            }

            @Override
            public void onSwiped(@androidx.annotation.NonNull RecyclerView.ViewHolder viewHolder, int direction) {
            }
        };

        ItemTouchHelper touchHelper = new ItemTouchHelper(callback);
        touchHelper.attachToRecyclerView(binding.rvCategories);
    }

    private void setupFab() {
        binding.fabAdd.setOnClickListener(v -> showEditDialog(null));
    }

    private void loadCategories() {
        executor.execute(() -> {
            List<Category> categories = categoryDao.getAllCategories();
            runOnUiThread(() -> adapter.submitList(categories));
        });
    }

    private void showEditDialog(Category category) {
        boolean isNew = category == null;

        DialogCategoryEditBinding dialogBinding = DialogCategoryEditBinding.inflate(
                LayoutInflater.from(this));

        if (!isNew) {
            dialogBinding.etCategoryName.setText(category.getName());
        }

        AlertDialog dialog = new MaterialAlertDialogBuilder(this)
                .setTitle(isNew ? R.string.category_add : R.string.category_edit)
                .setView(dialogBinding.getRoot())
                .setPositiveButton(R.string.btn_save, null)
                .setNegativeButton(R.string.btn_cancel, null)
                .create();

        dialog.setOnShowListener(d -> {
            dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(v -> {
                String name = dialogBinding.etCategoryName.getText() != null
                        ? dialogBinding.etCategoryName.getText().toString().trim()
                        : "";

                if (TextUtils.isEmpty(name)) {
                    dialogBinding.tilCategoryName.setError(getString(R.string.category_name_empty));
                    return;
                }

                dialogBinding.tilCategoryName.setError(null);

                executor.execute(() -> {
                    // 중복 체크
                    List<Category> existing = categoryDao.getAllCategories();
                    for (Category c : existing) {
                        if (c.getName().equals(name) && (isNew || !c.getId().equals(category.getId()))) {
                            runOnUiThread(() -> {
                                dialogBinding.tilCategoryName.setError(getString(R.string.category_name_duplicate));
                            });
                            return;
                        }
                    }

                    if (isNew) {
                        int maxOrder = categoryDao.getMaxSortOrder();
                        Category newCategory = new Category(
                                UUID.randomUUID().toString(),
                                name,
                                "ic_category_default",
                                maxOrder + 1,
                                false
                        );
                        categoryDao.insert(newCategory);
                    } else {
                        category.setName(name);
                        categoryDao.update(category);
                    }

                    runOnUiThread(() -> {
                        dialog.dismiss();
                        loadCategories();
                    });
                });
            });
        });

        dialog.show();
    }

    private void showDeleteConfirmDialog(Category category) {
        if (category.isDefault()) {
            Toast.makeText(this, R.string.category_delete_default_error, Toast.LENGTH_SHORT).show();
            return;
        }

        new MaterialAlertDialogBuilder(this)
                .setTitle(R.string.category_delete)
                .setMessage(R.string.category_delete_confirm)
                .setPositiveButton(R.string.btn_delete, (dialog, which) -> {
                    executor.execute(() -> {
                        categoryDao.delete(category);
                        // 관련 자산 스냅샷도 삭제
                        AppDatabase db = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());
                        db.assetSnapshotDao().deleteByCategory(category.getId());
                        runOnUiThread(this::loadCategories);
                    });
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    private void updateCategoryOrder(List<Category> newOrder) {
        executor.execute(() -> {
            for (int i = 0; i < newOrder.size(); i++) {
                categoryDao.updateSortOrder(newOrder.get(i).getId(), i);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
