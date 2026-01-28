package com.example.assetinsight.ui.assetlist;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.databinding.ItemAssetListBinding;

import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

public class AssetListAdapter extends ListAdapter<AssetSnapshot, AssetListAdapter.AssetViewHolder> {

    private final SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일", Locale.KOREA);
    private final NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);

    private Map<String, String> categoryNames;
    private OnAssetClickListener clickListener;
    private OnAssetDeleteListener deleteListener;

    public interface OnAssetClickListener {
        void onAssetClick(AssetSnapshot snapshot);
    }

    public interface OnAssetDeleteListener {
        void onAssetDelete(AssetSnapshot snapshot);
    }

    public AssetListAdapter() {
        super(DIFF_CALLBACK);
    }

    public void setCategoryNames(Map<String, String> categoryNames) {
        this.categoryNames = categoryNames;
    }

    public void setOnAssetClickListener(OnAssetClickListener listener) {
        this.clickListener = listener;
    }

    public void setOnAssetDeleteListener(OnAssetDeleteListener listener) {
        this.deleteListener = listener;
    }

    private static final DiffUtil.ItemCallback<AssetSnapshot> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<AssetSnapshot>() {
                @Override
                public boolean areItemsTheSame(@NonNull AssetSnapshot oldItem,
                                               @NonNull AssetSnapshot newItem) {
                    return oldItem.getDate().equals(newItem.getDate())
                            && oldItem.getCategoryId().equals(newItem.getCategoryId());
                }

                @Override
                public boolean areContentsTheSame(@NonNull AssetSnapshot oldItem,
                                                  @NonNull AssetSnapshot newItem) {
                    return oldItem.getAmount() == newItem.getAmount()
                            && TextUtils.equals(oldItem.getMemo(), newItem.getMemo());
                }
            };

    @NonNull
    @Override
    public AssetViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemAssetListBinding binding = ItemAssetListBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new AssetViewHolder(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull AssetViewHolder holder, int position) {
        holder.bind(getItem(position));
    }

    class AssetViewHolder extends RecyclerView.ViewHolder {
        private final ItemAssetListBinding binding;

        AssetViewHolder(ItemAssetListBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(AssetSnapshot snapshot) {
            // 날짜 표시
            try {
                Date date = dbDateFormat.parse(snapshot.getDate());
                binding.tvDate.setText(displayDateFormat.format(date));
            } catch (ParseException e) {
                binding.tvDate.setText(snapshot.getDate());
            }

            // 카테고리 이름
            String categoryName = categoryNames != null
                    ? categoryNames.getOrDefault(snapshot.getCategoryId(), snapshot.getCategoryId())
                    : snapshot.getCategoryId();
            binding.tvCategory.setText(categoryName);

            // 금액
            binding.tvAmount.setText(currencyFormat.format(snapshot.getAmount()));

            // 메모
            if (!TextUtils.isEmpty(snapshot.getMemo())) {
                binding.tvMemo.setText(snapshot.getMemo());
                binding.tvMemo.setVisibility(View.VISIBLE);
            } else {
                binding.tvMemo.setVisibility(View.GONE);
            }

            // 클릭 리스너
            binding.getRoot().setOnClickListener(v -> {
                if (clickListener != null) {
                    clickListener.onAssetClick(snapshot);
                }
            });

            // 삭제 버튼
            binding.btnDelete.setOnClickListener(v -> {
                if (deleteListener != null) {
                    deleteListener.onAssetDelete(snapshot);
                }
            });
        }
    }
}
