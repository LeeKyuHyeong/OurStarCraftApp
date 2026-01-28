package com.example.assetinsight.ui.input;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.data.repository.AssetRepository;
import com.example.assetinsight.databinding.ActivityInputBinding;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.SecurityHelper;
import com.google.android.material.datepicker.MaterialDatePicker;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class InputActivity extends AppCompatActivity {

    private ActivityInputBinding binding;
    private AssetRepository repository;
    private AppDatabase database;

    private String selectedDate;
    private String selectedCategoryId;

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일", Locale.KOREA);
    private final DecimalFormat amountFormat = new DecimalFormat("#,###");

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    // 카테고리 목록 (DB에서 로드)
    private List<Category> categories = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityInputBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // 화면 보안 활성화
        SecurityHelper.enableScreenSecurity(this);

        ViewCompat.setOnApplyWindowInsetsListener(binding.main, (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        // TODO: DB 암호화 키 관리 - 현재는 임시 키 사용
        database = AppDatabase.getInstance(this, DatabaseKeyManager.getKey());
        database.ensureDefaultCategories();
        repository = new AssetRepository(this, DatabaseKeyManager.getKey());

        setupToolbar();
        setupDatePicker();
        setupAmountInput();
        setupSaveButton();

        // 카테고리 로드 후 드롭다운 설정
        loadCategories();

        // 오늘 날짜로 초기화
        setDate(System.currentTimeMillis());
    }

    private void setupToolbar() {
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupDatePicker() {
        binding.etDate.setOnClickListener(v -> showDatePicker());
        binding.tilDate.setEndIconOnClickListener(v -> showDatePicker());
    }

    private void showDatePicker() {
        MaterialDatePicker<Long> datePicker = MaterialDatePicker.Builder.datePicker()
                .setTitleText(getString(R.string.input_date))
                .setSelection(MaterialDatePicker.todayInUtcMilliseconds())
                .build();

        datePicker.addOnPositiveButtonClickListener(this::setDate);
        datePicker.show(getSupportFragmentManager(), "DATE_PICKER");
    }

    private void setDate(long timestamp) {
        Date date = new Date(timestamp);
        selectedDate = dateFormat.format(date);
        binding.etDate.setText(displayDateFormat.format(date));

        // 날짜 변경 시 기존 기록 확인
        checkExistingRecord();
    }

    private void loadCategories() {
        executor.execute(() -> {
            categories = database.categoryDao().getAllCategories();

            List<String> categoryNames = new ArrayList<>();
            for (Category category : categories) {
                categoryNames.add(category.getName());
            }

            runOnUiThread(() -> setupCategoryDropdown(categoryNames));
        });
    }

    private void setupCategoryDropdown(List<String> categoryNames) {
        ArrayAdapter<String> adapter = new ArrayAdapter<>(
                this,
                android.R.layout.simple_dropdown_item_1line,
                categoryNames
        );
        binding.actvCategory.setAdapter(adapter);

        binding.actvCategory.setOnItemClickListener((parent, view, position, id) -> {
            if (position < categories.size()) {
                selectedCategoryId = categories.get(position).getId();
                checkExistingRecord();
            }
        });
    }

    private void setupAmountInput() {
        binding.etAmount.addTextChangedListener(new TextWatcher() {
            private String current = "";

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {}

            @Override
            public void afterTextChanged(Editable s) {
                if (s.toString().equals(current)) return;

                binding.etAmount.removeTextChangedListener(this);

                String cleanString = s.toString().replaceAll("[,]", "");
                if (!cleanString.isEmpty()) {
                    try {
                        long parsed = Long.parseLong(cleanString);
                        String formatted = amountFormat.format(parsed);
                        current = formatted;
                        binding.etAmount.setText(formatted);
                        binding.etAmount.setSelection(formatted.length());
                    } catch (NumberFormatException e) {
                        // 숫자가 아닌 경우 무시
                    }
                }

                binding.etAmount.addTextChangedListener(this);
            }
        });
    }

    private void setupSaveButton() {
        binding.btnSave.setOnClickListener(v -> saveSnapshot());
    }

    private void checkExistingRecord() {
        if (selectedDate == null || selectedCategoryId == null) {
            binding.cardExisting.setVisibility(View.GONE);
            return;
        }

        repository.getClosestSnapshot(selectedCategoryId, selectedDate, snapshot -> {
            runOnUiThread(() -> {
                if (snapshot != null && snapshot.getDate().equals(selectedDate)) {
                    // 정확히 같은 날짜의 기록이 있음
                    binding.cardExisting.setVisibility(View.VISIBLE);
                    binding.tvExistingAmount.setText(formatAmount(snapshot.getAmount()));

                    if (!TextUtils.isEmpty(snapshot.getMemo())) {
                        binding.tvExistingMemo.setText(snapshot.getMemo());
                        binding.tvExistingMemo.setVisibility(View.VISIBLE);
                    } else {
                        binding.tvExistingMemo.setVisibility(View.GONE);
                    }
                } else {
                    binding.cardExisting.setVisibility(View.GONE);
                }
            });
        });
    }

    private void saveSnapshot() {
        // 유효성 검사
        if (selectedCategoryId == null) {
            binding.tilCategory.setError(getString(R.string.input_error_category));
            return;
        }
        binding.tilCategory.setError(null);

        String amountStr = binding.etAmount.getText().toString().replaceAll("[,]", "");
        if (TextUtils.isEmpty(amountStr)) {
            binding.tilAmount.setError(getString(R.string.input_error_amount));
            return;
        }
        binding.tilAmount.setError(null);

        long amount;
        try {
            amount = Long.parseLong(amountStr);
        } catch (NumberFormatException e) {
            binding.tilAmount.setError(getString(R.string.input_error_amount));
            return;
        }

        String memo = binding.etMemo.getText() != null
                ? binding.etMemo.getText().toString().trim()
                : null;

        // 스냅샷 저장
        AssetSnapshot snapshot = new AssetSnapshot(selectedDate, selectedCategoryId, amount, memo);
        repository.saveSnapshot(snapshot, () -> {
            runOnUiThread(() -> {
                Toast.makeText(this, R.string.input_save_success, Toast.LENGTH_SHORT).show();
                finish();
            });
        });
    }

    private String formatAmount(long amount) {
        NumberFormat format = NumberFormat.getCurrencyInstance(Locale.KOREA);
        return format.format(amount);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
