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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MainAppBar(
            title: context.loc.pay_tuition,
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                // QR Code Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Text(
                          'Quét mã QR để thanh toán',
                          style: context.textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.h),
                        QrImageView(
                          data: 'https://example.com/payment',
                          version: QrVersions.auto,
                          size: 200.r,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Payment Information Section
                Card(
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
                          'Thông tin thanh toán',
                          style: context.textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoRow('Số tiền:', '5,000,000 VND'),
                        _buildInfoRow('Nội dung:', 'Học phí học kỳ 1'),
                        _buildInfoRow('Ngân hàng:', 'MBbank'),
                        _buildInfoRow('Số tài khoản:', '9651511041704'),
                        _buildInfoRow('Chủ tài khoản:', 'HUBT'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Payment Instructions
                Card(
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
                            '1. Quét mã QR bằng ứng dụng ngân hàng'),
                        _buildInstructionStep(
                            '2. Kiểm tra thông tin thanh toán'),
                        _buildInstructionStep(
                            '3. Xác nhận và hoàn tất giao dịch'),
                        _buildInstructionStep('4. Lưu lại biên lai thanh toán'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h), // Consistent spacing
                // Payment Button (now scrolls with content)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.showSnackBarMessage(
                          'Hiện tại ngân hàng đang bảo trì vui lòng đến thành toán trực tiếp tại quầy');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Thanh toán ngay',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 72.h), // Increased padding at the very bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 16.sp),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
