package com.example.assetinsight.ui.settings;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.assetinsight.BuildConfig;
import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.databinding.ActivitySettingsBinding;
import com.example.assetinsight.ui.backup.BackupRestoreActivity;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.PreferenceManager;
import com.example.assetinsight.util.SecurityHelper;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SettingsActivity extends AppCompatActivity {

    private ActivitySettingsBinding binding;
    private PreferenceManager prefManager;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivitySettingsBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        prefManager = new PreferenceManager(this);

        // 화면 보안 (설정에 따라)
        if (prefManager.isScreenSecurityEnabled()) {
            SecurityHelper.enableScreenSecurity(this);
        }

        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        setupToolbar();
        loadSettings();
        setupListeners();
    }

    private void setupToolbar() {
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void loadSettings() {
        // 보안 설정
        binding.switchBiometric.setChecked(prefManager.isBiometricEnabled());
        binding.switchScreenSecurity.setChecked(prefManager.isScreenSecurityEnabled());

        // 표시 설정
        binding.tvCurrencyValue.setText(prefManager.getCurrencyDisplayName());
        updateThemeText();

        // 앱 버전
        binding.tvVersion.setText(BuildConfig.VERSION_NAME);
    }

    private void updateThemeText() {
        String[] themeNames = getResources().getStringArray(R.array.theme_options);
        int themeIndex = prefManager.getThemeIndex();
        binding.tvThemeValue.setText(themeNames[themeIndex]);
    }

    private void setupListeners() {
        // 생체인증 스위치
        binding.switchBiometric.setOnCheckedChangeListener((buttonView, isChecked) -> {
            prefManager.setBiometricEnabled(isChecked);
        });

        // 화면 보안 스위치
        binding.switchScreenSecurity.setOnCheckedChangeListener((buttonView, isChecked) -> {
            prefManager.setScreenSecurityEnabled(isChecked);
            if (isChecked) {
                SecurityHelper.enableScreenSecurity(this);
            } else {
                SecurityHelper.disableScreenSecurity(this);
            }
        });

        // 통화 설정
        binding.itemCurrency.setOnClickListener(v -> showCurrencyDialog());

        // 테마 설정
        binding.itemTheme.setOnClickListener(v -> showThemeDialog());

        // 백업/복원
        binding.itemBackup.setOnClickListener(v -> {
            Intent intent = new Intent(this, BackupRestoreActivity.class);
            startActivity(intent);
        });

        // 데이터 초기화
        binding.itemResetData.setOnClickListener(v -> showResetDataDialog());
    }

    private void showCurrencyDialog() {
        int currentIndex = prefManager.getCurrencyIndex();

        new AlertDialog.Builder(this)
                .setTitle(R.string.settings_currency)
                .setSingleChoiceItems(PreferenceManager.CURRENCY_NAMES, currentIndex, (dialog, which) -> {
                    prefManager.setCurrency(PreferenceManager.CURRENCY_CODES[which]);
                    binding.tvCurrencyValue.setText(PreferenceManager.CURRENCY_NAMES[which]);
                    dialog.dismiss();
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    private void showThemeDialog() {
        String[] themeNames = getResources().getStringArray(R.array.theme_options);
        int currentIndex = prefManager.getThemeIndex();

        new AlertDialog.Builder(this)
                .setTitle(R.string.settings_theme)
                .setSingleChoiceItems(themeNames, currentIndex, (dialog, which) -> {
                    int themeMode = PreferenceManager.THEME_VALUES[which];
                    prefManager.setTheme(themeMode);
                    AppCompatDelegate.setDefaultNightMode(themeMode);
                    updateThemeText();
                    dialog.dismiss();
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    private void showResetDataDialog() {
        new AlertDialog.Builder(this)
                .setTitle(R.string.settings_reset_data)
                .setMessage(R.string.settings_reset_data_confirm)
                .setPositiveButton(R.string.settings_reset_data_btn, (dialog, which) -> {
                    showFinalResetConfirmDialog();
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    private void showFinalResetConfirmDialog() {
        new AlertDialog.Builder(this)
                .setTitle(R.string.settings_reset_data_final_title)
                .setMessage(R.string.settings_reset_data_final_message)
                .setPositiveButton(R.string.settings_reset_data_btn, (dialog, which) -> {
                    resetAllData();
                })
                .setNegativeButton(R.string.btn_cancel, null)
                .show();
    }

    private void resetAllData() {
        executor.execute(() -> {
            try {
                AppDatabase db = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());
                db.assetSnapshotDao().deleteAll();
                // 카테고리는 유지하고 기본 카테고리 보장
                db.ensureDefaultCategories();

                runOnUiThread(() -> {
                    Toast.makeText(this, R.string.settings_reset_data_success, Toast.LENGTH_SHORT).show();
                });
            } catch (Exception e) {
                runOnUiThread(() -> {
                    Toast.makeText(this, R.string.settings_reset_data_error, Toast.LENGTH_SHORT).show();
                });
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
