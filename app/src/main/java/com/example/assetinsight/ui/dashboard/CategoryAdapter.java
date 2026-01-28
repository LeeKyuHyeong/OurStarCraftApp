package com.example.assetinsight.ui.dashboard;

import android.view.LayoutInflater;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.assetinsight.databinding.ItemCategoryAssetBinding;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * 카테고리별 자산 목록 어댑터
 */
public class CategoryAdapter extends RecyclerView.Adapter<CategoryAdapter.ViewHolder> {

    private final List<CategoryAssetItem> items = new ArrayList<>();
    private final NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);
    private final NumberFormat percentFormat = NumberFormat.getPercentInstance(Locale.KOREA);

    private OnCategoryClickListener clickListener;

    public interface OnCategoryClickListener {
        void onCategoryClick(CategoryAssetItem item);
    }

    public CategoryAdapter() {
        percentFormat.setMaximumFractionDigits(1);
    }

    public void setOnCategoryClickListener(OnCategoryClickListener listener) {
        this.clickListener = listener;
    }

    public void submitList(List<CategoryAssetItem> newItems) {
        items.clear();
        if (newItems != null) {
            items.addAll(newItems);
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemCategoryAssetBinding binding = ItemCategoryAssetBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new ViewHolder(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(items.get(position));
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        private final ItemCategoryAssetBinding binding;

        ViewHolder(ItemCategoryAssetBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(CategoryAssetItem item) {
            binding.tvCategoryName.setText(item.getCategoryName());
            binding.tvCategoryAmount.setText(currencyFormat.format(item.getAmount()));
            binding.tvCategoryDate.setText(item.getLastUpdatedDate() + " 기준");
            binding.tvCategoryPercent.setText(percentFormat.format(item.getPercentOfTotal() / 100));

            binding.getRoot().setOnClickListener(v -> {
                if (clickListener != null) {
                    clickListener.onCategoryClick(item);
                }
            });
        }
    }
}
