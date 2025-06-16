import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/main_wrapper/presentation/widgets/main_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TuitionPaymentScreen extends StatelessWidget {
  const TuitionPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          context.loc.pay_tuition,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          // QR Code Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    children: [
                      Text(
                        'Quét mã QR để thanh toán',
                        style: context.textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.h),
                      QrImageView(
                        data:
                            'HUBT Social Hiện tại ngân hàng đang bảo trì vui lòng đến thành toán trực tiếp tại quầy',
                        version: QrVersions.auto,
                        size: 200.r,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          // Payment Information Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin thanh toán',
                        style: context.textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoRow(context, 'Số tiền:', '7,700,000 VND'),
                      _buildInfoRow(context, 'Nội dung:', 'Học phí học kỳ 1'),
                      _buildInfoRow(context, 'Ngân hàng:', 'HSbank'),
                      _buildInfoRow(context, 'Số tài khoản:',
                          '- - - - - - - - - - - - - -'),
                      _buildInfoRow(context, 'Chủ tài khoản:', 'HUBT Social'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          // Payment Instructions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hướng dẫn thanh toán',
                        style: context.textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.h),
                      _buildInstructionStep(
                          context, '1. Quét mã QR bằng ứng dụng ngân hàng'),
                      _buildInstructionStep(
                          context, '2. Kiểm tra thông tin thanh toán'),
                      _buildInstructionStep(
                          context, '3. Xác nhận và hoàn tất giao dịch'),
                      _buildInstructionStep(
                          context, '4. Lưu lại biên lai thanh toán'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: SizedBox(height: 24.h)), // Consistent spacing
          // Payment Button (now scrolls with content)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () {
                  context.showSnackBarMessage(
                      'Hiện tại ngân hàng đang bảo trì vui lòng đến thành toán trực tiếp tại quầy');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Thanh toán ngay',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
