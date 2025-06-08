import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class AcademicResultScreen extends StatelessWidget {
  const AcademicResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Academic result',
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 150.h,
            color: Colors.green,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 24.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Tổng hợp kết quả',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Tổng hợp kết quả" card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.green, // Card background color
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TBC thang điểm 10: 8.51', // Placeholder
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Số tín chỉ đã tích luỹ: 108', // Placeholder
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    _buildResultItem(
                                        context, '5', 'Môn chờ điểm'),
                                    SizedBox(width: 16.w),
                                    _buildResultItem(
                                        context, '0', 'Môn thi lại'),
                                    SizedBox(width: 16.w),
                                    _buildResultItem(
                                        context, '0', 'Môn học lại'),
                                  ],
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Colors.white,
                              child: Text(
                                'Giỏi', // Placeholder
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // "Biểu đồ phân tích" section
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart, // Chart icon
                            color: Colors.grey[700],
                            size: 24.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Biểu đồ phân tích', // Placeholder
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Tabs for "Bảng điểm" and "Nhận xét"
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'Bảng điểm'), // Placeholder
                                Tab(text: 'Nhận xét'), // Placeholder
                              ],
                              labelStyle:
                                  context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle:
                                  context.textTheme.titleSmall,
                              indicatorColor: context.colorScheme.primary,
                              labelColor: context.colorScheme.primary,
                              unselectedLabelColor: Colors.grey[600],
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 300.h, // Fixed height for tab bar view
                              child: TabBarView(
                                children: [
                                  // Table content for "Bảng điểm" tab
                                  _buildScoreTable(context),
                                  // Content for "Nhận xét" tab (placeholder)
                                  Center(child: Text('Nội dung nhận xét')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom navigation bar (Placeholder for now)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green, // Adjust as needed
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Placeholder
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat', // Placeholder
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar', // Placeholder
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications', // Placeholder
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu', // Placeholder
          ),
        ],
        onTap: (index) {
          // Handle tap (e.g., navigate to different screens)
        },
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreTable(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.withOpacity(0.5),
        width: 0.5,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1)),
          children: [
            _buildTableCell(context, 'Mã học phần', isHeader: true),
            _buildTableCell(context, 'Tên học phần', isHeader: true),
            _buildTableCell(context, 'Số tín chỉ', isHeader: true),
            _buildTableCell(context, 'Thang điểm 10', isHeader: true),
          ],
        ),
        _buildScoreTableRow(context, '191244001', 'Tiếng Nga 1', '4', '9'),
        _buildScoreTableRow(
            context, '191032021', 'Đồ họa máy tính', '2', '8.6'),
        _buildScoreTableRow(
            context, '191032029', 'Lập trình C++ cơ sở', '4', '8.4'),
        _buildScoreTableRow(
            context, '191032015', 'Đồ án phần mềm C++', '2', '7.5'),
      ],
    );
  }

  TableRow _buildScoreTableRow(BuildContext context, String col1, String col2,
      String col3, String col4) {
    return TableRow(
      children: [
        _buildTableCell(context, col1),
        _buildTableCell(context, col2),
        _buildTableCell(context, col3),
        _buildTableCell(context, col4),
      ],
    );
  }

  Widget _buildTableCell(BuildContext context, String text,
      {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.green : context.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
