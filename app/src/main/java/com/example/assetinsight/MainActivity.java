package com.example.assetinsight;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.assetinsight.databinding.ActivityMainBinding;
import com.example.assetinsight.ui.input.InputActivity;
import com.example.assetinsight.util.SecurityHelper;
import com.example.assetinsight.util.SecurityHelper.BiometricStatus;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private SecurityHelper securityHelper;
    private boolean isAuthenticated = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        // 화면 보안 활성화 (스크린샷 방지, 최근 앱에서 내용 숨김)
        SecurityHelper.enableScreenSecurity(this);

        ViewCompat.setOnApplyWindowInsetsListener(binding.main, (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        securityHelper = new SecurityHelper(this);

        // 초기 상태: 메인 콘텐츠 숨김
        showAuthScreen();

        // 다시 시도 버튼
        binding.btnRetry.setOnClickListener(v -> requestBiometricAuth());

        // FAB - 자산 입력 화면으로 이동
        binding.fabAdd.setOnClickListener(v -> {
            Intent intent = new Intent(this, InputActivity.class);
            startActivity(intent);
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 앱이 포그라운드로 돌아올 때마다 인증 요청
        if (!isAuthenticated) {
            requestBiometricAuth();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        // 앱이 백그라운드로 가면 인증 상태 초기화
        isAuthenticated = false;
    }

    private boolean isDebugBuild() {
        return (getApplicationInfo().flags & android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE) != 0;
    }

    private void requestBiometricAuth() {
        BiometricStatus status = securityHelper.checkBiometricAvailability();

        // Debug 빌드에서 생체 인증 불가 시 건너뛰기
        if (isDebugBuild() && status != BiometricStatus.AVAILABLE) {
            isAuthenticated = true;
            showMainContent();
            return;
        }

        status = securityHelper.checkBiometricAvailability();

        switch (status) {
            case AVAILABLE:
                performBiometricAuth();
                break;
            case NO_HARDWARE:
                showError(getString(R.string.biometric_error_no_hardware));
                // 생체 인증 불가 시 앱 접근 차단 또는 대체 인증 방법 제공
                break;
            case NOT_ENROLLED:
                showError(getString(R.string.biometric_error_not_enrolled));
                break;
            case HARDWARE_UNAVAILABLE:
            case SECURITY_UPDATE_REQUIRED:
            case UNKNOWN:
                showError(getString(R.string.biometric_error_unavailable));
                break;
        }
    }

    private void performBiometricAuth() {
        securityHelper.authenticate(
                this,
                getString(R.string.biometric_title),
                getString(R.string.biometric_subtitle),
                getString(R.string.biometric_negative_button),
                new SecurityHelper.AuthenticationCallback() {
                    @Override
                    public void onSuccess() {
                        isAuthenticated = true;
                        showMainContent();
                    }

                    @Override
                    public void onFailed() {
                        Toast.makeText(MainActivity.this,
                                R.string.biometric_auth_failed,
                                Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onError(int errorCode, String errorMessage) {
                        // 사용자가 취소한 경우 (errorCode 10, 13)
                        if (errorCode == 10 || errorCode == 13) {
                            showAuthScreen();
                        } else {
                            showError(errorMessage);
                        }
                    }
                }
        );
    }

    private void showAuthScreen() {
        binding.authContainer.setVisibility(View.VISIBLE);
        binding.mainContent.setVisibility(View.GONE);
    }

    private void showMainContent() {
        binding.authContainer.setVisibility(View.GONE);
        binding.mainContent.setVisibility(View.VISIBLE);
    }

    private void showError(String message) {
        binding.tvAuthMessage.setText(message);
        binding.tvAuthMessage.setVisibility(View.VISIBLE);
        binding.btnRetry.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        binding = null;
    }
}
