package com.example.assetinsight.ui.category;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.Category;
import com.example.assetinsight.databinding.ItemCategoryManageBinding;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CategoryManageAdapter extends RecyclerView.Adapter<CategoryManageAdapter.ViewHolder> {

    private final List<Category> items = new ArrayList<>();
    private OnCategoryActionListener listener;

    public interface OnCategoryActionListener {
        void onEdit(Category category);
        void onDelete(Category category);
        void onOrderChanged(List<Category> newOrder);
    }

    public void setListener(OnCategoryActionListener listener) {
        this.listener = listener;
    }

    public void submitList(List<Category> newItems) {
        items.clear();
        if (newItems != null) {
            items.addAll(newItems);
        }
        notifyDataSetChanged();
    }

    public void moveItem(int from, int to) {
        if (from < to) {
            for (int i = from; i < to; i++) {
                Collections.swap(items, i, i + 1);
            }
        } else {
            for (int i = from; i > to; i--) {
                Collections.swap(items, i, i - 1);
            }
        }
        notifyItemMoved(from, to);

        // 순서 변경 콜백
        if (listener != null) {
            listener.onOrderChanged(new ArrayList<>(items));
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemCategoryManageBinding binding = ItemCategoryManageBinding.inflate(
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
        private final ItemCategoryManageBinding binding;

        ViewHolder(ItemCategoryManageBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(Category category) {
            binding.tvCategoryName.setText(category.getName());

            if (category.isDefault()) {
                binding.tvCategoryType.setText(R.string.category_default);
                binding.tvCategoryType.setVisibility(View.VISIBLE);
                binding.btnDelete.setVisibility(View.GONE);
            } else {
                binding.tvCategoryType.setText(R.string.category_custom);
                binding.tvCategoryType.setVisibility(View.VISIBLE);
                binding.btnDelete.setVisibility(View.VISIBLE);
            }

            binding.btnEdit.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onEdit(category);
                }
            });

            binding.btnDelete.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onDelete(category);
                }
            });
        }
    }
}
