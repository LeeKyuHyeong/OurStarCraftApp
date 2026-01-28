package com.example.assetinsight.ui.dashboard;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AppDatabase;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.data.repository.AssetRepository;
import com.example.assetinsight.databinding.FragmentDashboardBinding;
import com.example.assetinsight.ui.backup.BackupRestoreActivity;
import com.example.assetinsight.util.DatabaseKeyManager;
import com.example.assetinsight.ui.category.CategoryManageActivity;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.github.mikephil.charting.formatter.PercentFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;

import android.graphics.Color;
import android.widget.PopupMenu;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicLong;

public class DashboardFragment extends Fragment {

    private FragmentDashboardBinding binding;
    private AssetRepository repository;
    private CategoryAdapter categoryAdapter;

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일", Locale.KOREA);
    private final NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);
    private final NumberFormat percentFormat = NumberFormat.getInstance(Locale.KOREA);

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    // 카테고리 ID -> 이름 매핑
    private final Map<String, String> categoryNames = new HashMap<>();

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        percentFormat.setMaximumFractionDigits(1);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        binding = FragmentDashboardBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        // TODO: DB 암호화 키 관리 - 현재는 임시 키 사용
        repository = new AssetRepository(requireContext(), DatabaseKeyManager.getKey());

        setupRecyclerView();
        setupCategoryManageButton();
        setupMenuButton();
        setupCharts();
        loadCategoryNames();
    }

    private void setupCharts() {
        // 라인 차트 설정
        LineChart lineChart = binding.lineChart;
        lineChart.setDescription(null);
        lineChart.setDrawGridBackground(false);
        lineChart.setTouchEnabled(true);
        lineChart.setDragEnabled(true);
        lineChart.setScaleEnabled(false);
        lineChart.setPinchZoom(false);
        lineChart.getLegend().setEnabled(false);
        lineChart.getAxisRight().setEnabled(false);
        lineChart.getAxisLeft().setTextColor(ContextCompat.getColor(requireContext(),
                com.google.android.material.R.color.material_on_surface_emphasis_medium));
        lineChart.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        lineChart.getXAxis().setTextColor(ContextCompat.getColor(requireContext(),
                com.google.android.material.R.color.material_on_surface_emphasis_medium));
        lineChart.getXAxis().setDrawGridLines(false);
        lineChart.setNoDataText(getString(R.string.dashboard_no_data));

        // 파이 차트 설정
        PieChart pieChart = binding.pieChart;
        pieChart.setDescription(null);
        pieChart.setUsePercentValues(true);
        pieChart.setDrawHoleEnabled(true);
        pieChart.setHoleRadius(50f);
        pieChart.setTransparentCircleRadius(55f);
        pieChart.setDrawEntryLabels(false);
        pieChart.getLegend().setEnabled(true);
        pieChart.getLegend().setTextColor(ContextCompat.getColor(requireContext(),
                com.google.android.material.R.color.material_on_surface_emphasis_medium));
        pieChart.setNoDataText(getString(R.string.dashboard_no_data));
    }

    private void setupMenuButton() {
        binding.btnMenu.setOnClickListener(v -> {
            PopupMenu popup = new PopupMenu(requireContext(), v);
            popup.getMenuInflater().inflate(R.menu.menu_dashboard, popup.getMenu());
            popup.setOnMenuItemClickListener(item -> {
                if (item.getItemId() == R.id.action_backup) {
                    Intent intent = new Intent(requireContext(), BackupRestoreActivity.class);
                    startActivity(intent);
                    return true;
                }
                return false;
            });
            popup.show();
        });
    }

    private void setupCategoryManageButton() {
        binding.btnCategoryManage.setOnClickListener(v -> {
            Intent intent = new Intent(requireContext(), CategoryManageActivity.class);
            startActivity(intent);
        });
    }

    private void loadCategoryNames() {
        executor.execute(() -> {
            AppDatabase db = AppDatabase.getInstance(requireContext(), DatabaseKeyManager.getKey());
            db.ensureDefaultCategories();
            List<Category> categories = db.categoryDao().getAllCategories();

            categoryNames.clear();
            for (Category category : categories) {
                categoryNames.put(category.getId(), category.getName());
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        loadCategoryNames();
        loadDashboardData();
    }

    private void setupRecyclerView() {
        categoryAdapter = new CategoryAdapter();
        binding.rvCategories.setLayoutManager(new LinearLayoutManager(requireContext()));
        binding.rvCategories.setAdapter(categoryAdapter);
    }

    private void loadDashboardData() {
        String today = dateFormat.format(new Date());

        executor.execute(() -> {
            // 1. 전체 자산 총액
            AtomicLong totalAmount = new AtomicLong(0);
            CountDownLatch totalLatch = new CountDownLatch(1);

            repository.getTotalAmountAtDate(today, amount -> {
                totalAmount.set(amount);
                totalLatch.countDown();
            });

            try {
                totalLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            // 2. 인사이트 데이터 (1일, 1개월, 6개월, 1년 전)
            InsightData dayInsight = calculateInsight(today, -1, Calendar.DAY_OF_MONTH, totalAmount.get());
            InsightData monthInsight = calculateInsight(today, -1, Calendar.MONTH, totalAmount.get());
            InsightData sixMonthInsight = calculateInsight(today, -6, Calendar.MONTH, totalAmount.get());
            InsightData yearInsight = calculateInsight(today, -1, Calendar.YEAR, totalAmount.get());

            // 3. 카테고리별 자산
            List<CategoryAssetItem> categoryItems = loadCategoryAssets(today, totalAmount.get());

            // 차트 데이터
            List<Entry> trendEntries = loadTrendData();
            List<PieEntry> pieEntries = createPieEntries(categoryItems);

            // UI 업데이트
            if (getActivity() != null) {
                getActivity().runOnUiThread(() -> {
                    updateTotalAmount(totalAmount.get(), today);
                    updateInsightCard(binding.tvDayChange, binding.tvDayPercent, dayInsight);
                    updateInsightCard(binding.tvMonthChange, binding.tvMonthPercent, monthInsight);
                    updateInsightCard(binding.tvSixMonthChange, binding.tvSixMonthPercent, sixMonthInsight);
                    updateInsightCard(binding.tvYearChange, binding.tvYearPercent, yearInsight);
                    updateCategoryList(categoryItems);
                    updateLineChart(trendEntries);
                    updatePieChart(pieEntries);
                });
            }
        });
    }

    private List<Entry> loadTrendData() {
        List<Entry> entries = new ArrayList<>();

        // 최근 12개월간 월별 총 자산 추이
        Calendar cal = Calendar.getInstance();
        for (int i = 11; i >= 0; i--) {
            Calendar target = (Calendar) cal.clone();
            target.add(Calendar.MONTH, -i);
            target.set(Calendar.DAY_OF_MONTH, target.getActualMaximum(Calendar.DAY_OF_MONTH));
            String targetDate = dateFormat.format(target.getTime());

            AtomicLong amount = new AtomicLong(0);
            CountDownLatch latch = new CountDownLatch(1);

            repository.getTotalAmountAtDate(targetDate, amt -> {
                amount.set(amt);
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

    private List<PieEntry> createPieEntries(List<CategoryAssetItem> categoryItems) {
        List<PieEntry> entries = new ArrayList<>();

        for (CategoryAssetItem item : categoryItems) {
            if (item.getAmount() > 0) {
                entries.add(new PieEntry(item.getAmount(), item.getCategoryName()));
            }
        }

        return entries;
    }

    private void updateLineChart(List<Entry> entries) {
        if (entries.isEmpty() || binding == null) return;

        LineDataSet dataSet = new LineDataSet(entries, "");
        dataSet.setColor(ContextCompat.getColor(requireContext(), R.color.positive));
        dataSet.setLineWidth(2f);
        dataSet.setDrawCircles(true);
        dataSet.setCircleColor(ContextCompat.getColor(requireContext(), R.color.positive));
        dataSet.setCircleRadius(3f);
        dataSet.setDrawValues(false);
        dataSet.setMode(LineDataSet.Mode.CUBIC_BEZIER);
        dataSet.setDrawFilled(true);
        dataSet.setFillColor(ContextCompat.getColor(requireContext(), R.color.positive));
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

    private void updatePieChart(List<PieEntry> entries) {
        if (entries.isEmpty() || binding == null) {
            binding.pieChart.setData(null);
            binding.pieChart.invalidate();
            return;
        }

        PieDataSet dataSet = new PieDataSet(entries, "");
        dataSet.setColors(ColorTemplate.MATERIAL_COLORS);
        dataSet.setSliceSpace(2f);
        dataSet.setValueTextSize(10f);
        dataSet.setValueTextColor(Color.WHITE);

        PieData pieData = new PieData(dataSet);
        pieData.setValueFormatter(new PercentFormatter(binding.pieChart));

        binding.pieChart.setData(pieData);
        binding.pieChart.invalidate();
    }

    private InsightData calculateInsight(String today, int amount, int field, long currentTotal) {
        Calendar cal = Calendar.getInstance();
        try {
            cal.setTime(dateFormat.parse(today));
        } catch (Exception e) {
            return InsightData.noData();
        }
        cal.add(field, amount);
        String pastDate = dateFormat.format(cal.getTime());

        AtomicLong pastAmount = new AtomicLong(0);
        CountDownLatch latch = new CountDownLatch(1);

        repository.getTotalAmountAtDate(pastDate, amt -> {
            pastAmount.set(amt);
            latch.countDown();
        });

        try {
            latch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        return new InsightData(currentTotal, pastAmount.get());
    }

    private List<CategoryAssetItem> loadCategoryAssets(String today, long totalAmount) {
        List<CategoryAssetItem> items = new ArrayList<>();
        CountDownLatch latch = new CountDownLatch(1);

        repository.getAllCategoryIds(categoryIds -> {
            if (categoryIds == null || categoryIds.isEmpty()) {
                latch.countDown();
                return;
            }

            CountDownLatch innerLatch = new CountDownLatch(categoryIds.size());

            for (String categoryId : categoryIds) {
                repository.getClosestSnapshot(categoryId, today, snapshot -> {
                    if (snapshot != null) {
                        String name = categoryNames.getOrDefault(categoryId, categoryId);
                        double percent = totalAmount > 0
                                ? ((double) snapshot.getAmount() / totalAmount) * 100
                                : 0;

                        synchronized (items) {
                            items.add(new CategoryAssetItem(
                                    categoryId,
                                    name,
                                    snapshot.getAmount(),
                                    snapshot.getDate(),
                                    percent
                            ));
                        }
                    }
                    innerLatch.countDown();
                });
            }

            try {
                innerLatch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            latch.countDown();
        });

        try {
            latch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 금액 기준 내림차순 정렬
        items.sort((a, b) -> Long.compare(b.getAmount(), a.getAmount()));
        return items;
    }

    private void updateTotalAmount(long amount, String date) {
        binding.tvTotalAmount.setText(currencyFormat.format(amount));
        try {
            Date d = dateFormat.parse(date);
            binding.tvAsOfDate.setText(getString(R.string.dashboard_as_of_date,
                    displayDateFormat.format(d)));
        } catch (Exception e) {
            binding.tvAsOfDate.setText(date);
        }
    }

    private void updateInsightCard(android.widget.TextView tvChange,
                                   android.widget.TextView tvPercent,
                                   InsightData insight) {
        if (!insight.hasData()) {
            tvChange.setText(getString(R.string.dashboard_no_data));
            tvPercent.setText("-");
            tvChange.setTextColor(ContextCompat.getColor(requireContext(),
                    com.google.android.material.R.color.material_on_surface_emphasis_medium));
            tvPercent.setTextColor(ContextCompat.getColor(requireContext(),
                    com.google.android.material.R.color.material_on_surface_emphasis_medium));
            return;
        }

        String sign = insight.isPositive() ? "+" : "";
        tvChange.setText(sign + currencyFormat.format(insight.getChangeAmount()));
        tvPercent.setText(sign + percentFormat.format(insight.getChangePercent()) + "%");

        int color;
        if (insight.getChangeAmount() > 0) {
            color = ContextCompat.getColor(requireContext(), R.color.positive);
        } else if (insight.getChangeAmount() < 0) {
            color = ContextCompat.getColor(requireContext(), R.color.negative);
        } else {
            color = ContextCompat.getColor(requireContext(),
                    com.google.android.material.R.color.material_on_surface_emphasis_medium);
        }

        tvChange.setTextColor(color);
        tvPercent.setTextColor(color);
    }

    private void updateCategoryList(List<CategoryAssetItem> items) {
        if (items.isEmpty()) {
            binding.rvCategories.setVisibility(View.GONE);
            binding.tvEmpty.setVisibility(View.VISIBLE);
        } else {
            binding.rvCategories.setVisibility(View.VISIBLE);
            binding.tvEmpty.setVisibility(View.GONE);
            categoryAdapter.submitList(items);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
