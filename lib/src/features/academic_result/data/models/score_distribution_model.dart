class ScoreDistributionModel {
  final int excellent;
  final int good;
  final int fair;
  final int average;
  final int belowAverage;
  final int fail;

  ScoreDistributionModel({
    required this.excellent,
    required this.good,
    required this.fair,
    required this.average,
    required this.belowAverage,
    required this.fail,
  });

  factory ScoreDistributionModel.fromJson(Map<String, dynamic> json) {
    return ScoreDistributionModel(
      excellent: json['excellent'] as int,
      good: json['good'] as int,
      fair: json['fair'] as int,
      average: json['average'] as int,
      belowAverage: json['belowAverage'] as int,
      fail: json['fail'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'excellent': excellent,
      'good': good,
      'fair': fair,
      'average': average,
      'belowAverage': belowAverage,
      'fail': fail,
    };
  }
}
