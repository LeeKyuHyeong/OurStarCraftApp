package com.example.assetinsight.ui.category;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.data.repository.AssetRepository;
import com.example.assetinsight.databinding.ActivityCategoryDetailBinding;
import com.example.assetinsight.ui.input.InputActivity;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.util.PreferenceManager;
import com.example.assetinsight.util.SecurityHelper;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicLong;

public class CategoryDetailActivity extends AppCompatActivity {

    public static final String EXTRA_CATEGORY_ID = "category_id";
    public static final String EXTRA_CATEGORY_NAME = "category_name";

    private ActivityCategoryDetailBinding binding;
    private AssetRepository repository;
    private CategoryRecordAdapter adapter;
    private PreferenceManager prefManager;

    private String categoryId;
    private String categoryName;

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일", Locale.KOREA);
    private final NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);
    private final NumberFormat percentFormat = NumberFormat.getInstance(Locale.KOREA);

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityCategoryDetailBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        prefManager = new PreferenceManager(this);
        if (prefManager.isScreenSecurityEnabled()) {
            SecurityHelper.enableScreenSecurity(this);
        }

        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        // Intent에서 카테고리 정보 가져오기
        categoryId = getIntent().getStringExtra(EXTRA_CATEGORY_ID);
        categoryName = getIntent().getStringExtra(EXTRA_CATEGORY_NAME);

        if (categoryId == null) {
            finish();
            return;
        }

        repository = new AssetRepository(this, DatabaseKeyManager.getKey());
        percentFormat.setMaximumFractionDigits(1);

        setupToolbar();
        setupChart();
        setupRecyclerView();
        setupFab();
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadData();
    }

    private void setupToolbar() {
        binding.toolbar.setTitle(categoryName != null ? categoryName : "");
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupChart() {
        binding.lineChart.setDescription(null);
        binding.lineChart.setDrawGridBackground(false);
        binding.lineChart.setTouchEnabled(true);
        binding.lineChart.setDragEnabled(true);
        binding.lineChart.setScaleEnabled(false);
        binding.lineChart.setPinchZoom(false);
        binding.lineChart.getLegend().setEnabled(false);
        binding.lineChart.getAxisRight().setEnabled(false);
        binding.lineChart.getAxisLeft().setTextColor(ContextCompat.getColor(this,
                com.google.android.material.R.color.material_on_surface_emphasis_medium));
        binding.lineChart.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        binding.lineChart.getXAxis().setTextColor(ContextCompat.getColor(this,
                com.google.android.material.R.color.material_on_surface_emphasis_medium));
        binding.lineChart.getXAxis().setDrawGridLines(false);
        binding.lineChart.setNoDataText(getString(R.string.dashboard_no_data));
    }

    private void setupRecyclerView() {
        adapter = new CategoryRecordAdapter();
        adapter.setOnRecordClickListener(this::onRecordClick);
        binding.rvRecords.setLayoutManager(new LinearLayoutManager(this));
        binding.rvRecords.setAdapter(adapter);
    }

    private void setupFab() {
        binding.fabAdd.setOnClickListener(v -> {
            Intent intent = new Intent(this, InputActivity.class);
            intent.putExtra("preset_category_id", categoryId);
            intent.putExtra("preset_category_name", categoryName);
            startActivity(intent);
        });
    }

    private void loadData() {
        String today = dateFormat.format(new Date());

        executor.execute(() -> {
            // 현재 금액
            AtomicLong currentAmount = new AtomicLong(0);
            CountDownLatch currentLatch = new CountDownLatch(1);

            repository.getClosestSnapshot(categoryId, today, snapshot -> {
                if (snapshot != null) {
                    currentAmount.set(snapshot.getAmount());
                }
                currentLatch.countDown();
            });

            try {
                currentLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            // 1개월 전 금액
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.MONTH, -1);
            String monthAgo = dateFormat.format(cal.getTime());

            AtomicLong monthAgoAmount = new AtomicLong(0);
            CountDownLatch monthLatch = new CountDownLatch(1);

            repository.getClosestSnapshot(categoryId, monthAgo, snapshot -> {
                if (snapshot != null) {
                    monthAgoAmount.set(snapshot.getAmount());
                }
                monthLatch.countDown();
            });

            try {
                monthLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            // 1년 전 금액
            cal = Calendar.getInstance();
            cal.add(Calendar.YEAR, -1);
            String yearAgo = dateFormat.format(cal.getTime());

            AtomicLong yearAgoAmount = new AtomicLong(0);
            CountDownLatch yearLatch = new CountDownLatch(1);

            repository.getClosestSnapshot(categoryId, yearAgo, snapshot -> {
                if (snapshot != null) {
                    yearAgoAmount.set(snapshot.getAmount());
                }
                yearLatch.countDown();
            });

            try {
                yearLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            // 차트 데이터 (최근 12개월)
            List<Entry> chartEntries = loadChartData();

            // 기록 목록
            CountDownLatch recordsLatch = new CountDownLatch(1);
            List<AssetSnapshot> records = new ArrayList<>();

            repository.getSnapshotsByCategory(categoryId, snapshots -> {
                records.addAll(snapshots);
                // 최신순 정렬
                records.sort((a, b) -> b.getDate().compareTo(a.getDate()));
                recordsLatch.countDown();
            });

            try {
                recordsLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            // UI 업데이트
            runOnUiThread(() -> {
                updateHeader(currentAmount.get(), today);
                updateInsightCards(currentAmount.get(), monthAgoAmount.get(), yearAgoAmount.get());
                updateChart(chartEntries);
                updateRecordsList(records);
            });
        });
    }

    private List<Entry> loadChartData() {
        List<Entry> entries = new ArrayList<>();
        Calendar cal = Calendar.getInstance();

        for (int i = 11; i >= 0; i--) {
            Calendar target = (Calendar) cal.clone();
            target.add(Calendar.MONTH, -i);
            target.set(Calendar.DAY_OF_MONTH, target.getActualMaximum(Calendar.DAY_OF_MONTH));
            String targetDate = dateFormat.format(target.getTime());

            AtomicLong amount = new AtomicLong(0);
            CountDownLatch latch = new CountDownLatch(1);

            repository.getClosestSnapshot(categoryId, targetDate, snapshot -> {
                if (snapshot != null) {
                    amount.set(snapshot.getAmount());
                }
                latch.countDown();
            });

            try {
                latch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            entries.add(new Entry(11 - i, amount.get() / 10000f)); // 만원 단위
        }

        return entries;
    }

    private void updateHeader(long amount, String date) {
        binding.tvCurrentAmount.setText(currencyFormat.format(amount));
        try {
            Date d = dateFormat.parse(date);
            binding.tvAsOfDate.setText(getString(R.string.dashboard_as_of_date,
                    displayDateFormat.format(d)));
        } catch (Exception e) {
            binding.tvAsOfDate.setText(date);
        }
    }

    private void updateInsightCards(long current, long monthAgo, long yearAgo) {
        // 1개월 전 대비
        updateChangeCard(binding.tvMonthChange, binding.tvMonthPercent, current, monthAgo);

        // 1년 전 대비
        updateChangeCard(binding.tvYearChange, binding.tvYearPercent, current, yearAgo);
    }

    private void updateChangeCard(android.widget.TextView tvChange,
                                  android.widget.TextView tvPercent,
                                  long current, long past) {
        if (past == 0 && current == 0) {
            tvChange.setText(getString(R.string.dashboard_no_data));
            tvPercent.setText("-");
            int neutralColor = ContextCompat.getColor(this,
                    com.google.android.material.R.color.material_on_surface_emphasis_medium);
            tvChange.setTextColor(neutralColor);
            tvPercent.setTextColor(neutralColor);
            return;
        }

        long change = current - past;
        double percent = past > 0 ? ((double) change / past) * 100 : (current > 0 ? 100 : 0);

        String sign = change >= 0 ? "+" : "";
        tvChange.setText(sign + currencyFormat.format(change));
        tvPercent.setText(sign + percentFormat.format(percent) + "%");

        int color;
        if (change > 0) {
            color = ContextCompat.getColor(this, R.color.positive);
        } else if (change < 0) {
            color = ContextCompat.getColor(this, R.color.negative);
        } else {
            color = ContextCompat.getColor(this,
                    com.google.android.material.R.color.material_on_surface_emphasis_medium);
        }

        tvChange.setTextColor(color);
        tvPercent.setTextColor(color);
    }

    private void updateChart(List<Entry> entries) {
        if (entries.isEmpty()) {
            binding.lineChart.setData(null);
            binding.lineChart.invalidate();
            return;
        }

        LineDataSet dataSet = new LineDataSet(entries, "");
        dataSet.setColor(ContextCompat.getColor(this, R.color.positive));
        dataSet.setLineWidth(2f);
        dataSet.setDrawCircles(true);
        dataSet.setCircleColor(ContextCompat.getColor(this, R.color.positive));
        dataSet.setCircleRadius(3f);
        dataSet.setDrawValues(false);
        dataSet.setMode(LineDataSet.Mode.CUBIC_BEZIER);
        dataSet.setDrawFilled(true);
        dataSet.setFillColor(ContextCompat.getColor(this, R.color.positive));
        dataSet.setFillAlpha(30);

        LineData lineData = new LineData(dataSet);
        binding.lineChart.setData(lineData);

        // X축 레이블 설정 (월)
        List<String> labels = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat monthFormat = new SimpleDateFormat("M월", Locale.KOREA);
        for (int i = 11; i >= 0; i--) {
            Calendar target = (Calendar) cal.clone();
            target.add(Calendar.MONTH, -i);
            labels.add(monthFormat.format(target.getTime()));
        }
        binding.lineChart.getXAxis().setValueFormatter(new IndexAxisValueFormatter(labels));
        binding.lineChart.getXAxis().setLabelCount(6);

        binding.lineChart.invalidate();
    }

    private void updateRecordsList(List<AssetSnapshot> records) {
        binding.tvRecordCount.setText(getString(R.string.category_detail_record_count, records.size()));

        if (records.isEmpty()) {
            binding.rvRecords.setVisibility(View.GONE);
            binding.tvEmpty.setVisibility(View.VISIBLE);
        } else {
            binding.rvRecords.setVisibility(View.VISIBLE);
            binding.tvEmpty.setVisibility(View.GONE);
            adapter.submitList(records);
        }
    }

    private void onRecordClick(AssetSnapshot snapshot) {
        Intent intent = new Intent(this, InputActivity.class);
        intent.putExtra("edit_date", snapshot.getDate());
        intent.putExtra("edit_category_id", snapshot.getCategoryId());
        intent.putExtra("edit_amount", snapshot.getAmount());
        intent.putExtra("edit_memo", snapshot.getMemo());
        startActivity(intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
