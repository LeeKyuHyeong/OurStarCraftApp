package com.example.assetinsight.ui.backup;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.databinding.ActivityBackupRestoreBinding;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.SecurityHelper;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;

import org.json.JSONException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class BackupRestoreActivity extends AppCompatActivity {

    private ActivityBackupRestoreBinding binding;
    private AppDatabase database;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HHmmss", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일 HH:mm", Locale.KOREA);

    // 백업 파일 생성 런처
    private final ActivityResultLauncher<Intent> createFileLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == RESULT_OK && result.getData() != null) {
                    Uri uri = result.getData().getData();
                    if (uri != null) {
                        performBackup(uri);
                    }
                }
            }
    );

    // 복원 파일 선택 런처
    private final ActivityResultLauncher<Intent> openFileLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == RESULT_OK && result.getData() != null) {
                    Uri uri = result.getData().getData();
                    if (uri != null) {
                        confirmRestore(uri);
                    }
                }
            }
    );

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityBackupRestoreBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SecurityHelper.enableScreenSecurity(this);

        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        // TODO: DB 암호화 키 관리
        database = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());

        setupToolbar();
        setupButtons();
        updateStats();
    }

    private void setupToolbar() {
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupButtons() {
        binding.btnBackup.setOnClickListener(v -> startBackup());
        binding.btnRestore.setOnClickListener(v -> startRestore());
    }

    private void updateStats() {
        executor.execute(() -> {
            int categoryCount = database.categoryDao().getCategoryCount();
            List<AssetSnapshot> snapshots = database.assetSnapshotDao().getAllSnapshots();
            int snapshotCount = snapshots.size();

            runOnUiThread(() -> {
                binding.tvCategoryCount.setText(String.valueOf(categoryCount));
                binding.tvSnapshotCount.setText(String.valueOf(snapshotCount));
            });
        });
    }

    private void startBackup() {
        String filename = "AssetInsight_" + dateFormat.format(new Date()) + ".json";

        Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/json");
        intent.putExtra(Intent.EXTRA_TITLE, filename);

        createFileLauncher.launch(intent);
    }

    private void performBackup(Uri uri) {
        binding.progressBar.setVisibility(android.view.View.VISIBLE);

        executor.execute(() -> {
            try {
                // 데이터 수집
                List<Category> categories = database.categoryDao().getAllCategories();
                List<AssetSnapshot> snapshots = database.assetSnapshotDao().getAllSnapshots();

                String backupDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
                        .format(new Date());

                BackupData backupData = new BackupData(backupDate, categories, snapshots);
                String json = backupData.toJson();

                // 파일 쓰기
                try (OutputStream os = getContentResolver().openOutputStream(uri)) {
                    if (os != null) {
                        os.write(json.getBytes());
                    }
                }

                runOnUiThread(() -> {
                    binding.progressBar.setVisibility(android.view.View.GONE);
                    Toast.makeText(this, R.string.backup_success, Toast.LENGTH_SHORT).show();
                });

            } catch (JSONException | IOException e) {
                runOnUiThread(() -> {
                    binding.progressBar.setVisibility(android.view.View.GONE);
                    Toast.makeText(this, getString(R.string.backup_error, e.getMessage()),
                            Toast.LENGTH_LONG).show();
                });
            }
        });
    }

    private void startRestore() {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/json");

        openFileLauncher.launch(intent);
    }

    private void confirmRestore(Uri uri) {
        executor.execute(() -> {
            try {
                // 파일 읽기 및 미리보기
                String json = readFile(uri);
                BackupData backupData = BackupData.fromJson(json);

                String message = getString(R.string.restore_confirm_message,
                        backupData.getBackupDate(),
                        backupData.getCategories().size(),
                        backupData.getSnapshots().size());

                runOnUiThread(() -> {
                    new MaterialAlertDialogBuilder(this)
                            .setTitle(R.string.restore_confirm_title)
                            .setMessage(message)
                            .setPositiveButton(R.string.btn_restore, (dialog, which) -> {
                                performRestore(backupData);
                            })
                            .setNegativeButton(R.string.btn_cancel, null)
                            .show();
                });

            } catch (JSONException | IOException e) {
                runOnUiThread(() -> {
                    Toast.makeText(this, getString(R.string.restore_error, e.getMessage()),
                            Toast.LENGTH_LONG).show();
                });
            }
        });
    }

    private void performRestore(BackupData backupData) {
        binding.progressBar.setVisibility(android.view.View.VISIBLE);

        executor.execute(() -> {
            try {
                // 기존 데이터 삭제
                database.assetSnapshotDao().deleteAll();
                // 기본 카테고리가 아닌 것만 삭제
                for (Category category : database.categoryDao().getAllCategories()) {
                    if (!category.isDefault()) {
                        database.categoryDao().delete(category);
                    }
                }

                // 카테고리 복원
                database.categoryDao().insertAll(backupData.getCategories());

                // 스냅샷 복원
                database.assetSnapshotDao().upsertAll(backupData.getSnapshots());

                runOnUiThread(() -> {
                    binding.progressBar.setVisibility(android.view.View.GONE);
                    Toast.makeText(this, R.string.restore_success, Toast.LENGTH_SHORT).show();
                    updateStats();
                });

            } catch (Exception e) {
                runOnUiThread(() -> {
                    binding.progressBar.setVisibility(android.view.View.GONE);
                    Toast.makeText(this, getString(R.string.restore_error, e.getMessage()),
                            Toast.LENGTH_LONG).show();
                });
            }
        });
    }

    private String readFile(Uri uri) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (InputStream is = getContentResolver().openInputStream(uri);
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
