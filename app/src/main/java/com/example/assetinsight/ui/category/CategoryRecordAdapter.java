package com.example.assetinsight.ui.category;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.example.assetinsight.R;
import com.example.assetinsight.data.local.AssetSnapshot;
import com.example.assetinsight.databinding.ItemCategoryRecordBinding;

import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class CategoryRecordAdapter extends ListAdapter<AssetSnapshot, CategoryRecordAdapter.RecordViewHolder> {

    private final SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
    private final SimpleDateFormat displayDateFormat = new SimpleDateFormat("yyyy년 M월 d일", Locale.KOREA);
    private final NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.KOREA);

    private OnRecordClickListener clickListener;

    public interface OnRecordClickListener {
        void onRecordClick(AssetSnapshot snapshot);
    }

    public CategoryRecordAdapter() {
        super(DIFF_CALLBACK);
    }

    public void setOnRecordClickListener(OnRecordClickListener listener) {
        this.clickListener = listener;
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
    public RecordViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemCategoryRecordBinding binding = ItemCategoryRecordBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new RecordViewHolder(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull RecordViewHolder holder, int position) {
        AssetSnapshot current = getItem(position);
        AssetSnapshot previous = position < getItemCount() - 1 ? getItem(position + 1) : null;
        holder.bind(current, previous);
    }

    class RecordViewHolder extends RecyclerView.ViewHolder {
        private final ItemCategoryRecordBinding binding;

        RecordViewHolder(ItemCategoryRecordBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(AssetSnapshot snapshot, AssetSnapshot previous) {
            // 날짜 표시
            try {
                Date date = dbDateFormat.parse(snapshot.getDate());
                binding.tvDate.setText(displayDateFormat.format(date));
            } catch (ParseException e) {
                binding.tvDate.setText(snapshot.getDate());
            }

            // 금액
            binding.tvAmount.setText(currencyFormat.format(snapshot.getAmount()));

            // 메모
            if (!TextUtils.isEmpty(snapshot.getMemo())) {
                binding.tvMemo.setText(snapshot.getMemo());
                binding.tvMemo.setVisibility(View.VISIBLE);
            } else {
                binding.tvMemo.setVisibility(View.GONE);
            }

            // 이전 기록 대비 변화량
            if (previous != null) {
                long change = snapshot.getAmount() - previous.getAmount();
                if (change != 0) {
                    String sign = change > 0 ? "+" : "";
                    binding.tvChange.setText(sign + currencyFormat.format(change));

                    int color;
                    if (change > 0) {
                        color = ContextCompat.getColor(binding.getRoot().getContext(), R.color.positive);
                    } else {
                        color = ContextCompat.getColor(binding.getRoot().getContext(), R.color.negative);
                    }
                    binding.tvChange.setTextColor(color);
                    binding.tvChange.setVisibility(View.VISIBLE);
                } else {
                    binding.tvChange.setVisibility(View.GONE);
                }
            } else {
                binding.tvChange.setVisibility(View.GONE);
            }

            // 클릭 리스너
            binding.getRoot().setOnClickListener(v -> {
                if (clickListener != null) {
                    clickListener.onRecordClick(snapshot);
                }
            });
        }
    }
}
