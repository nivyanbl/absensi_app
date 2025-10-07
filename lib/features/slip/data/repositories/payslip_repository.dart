import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/features/slip/domain/models/payslip_model.dart';

class PayslipRepository {
  final ApiService _api = ApiService();

  Future<List<PayslipModel>> listPayslips({int? year, int? month, int page = 1, int pageSize = 20}) async {
    final query = <String, dynamic> {
      if (year != null) 'year' : year,
      if (month != null ) 'month' : month,
    };
    final response = await _api.get('/payslips', queryParameters: query);
    final List data = (response.data ['data'] ?? [] ) as List;
    return data.map((json) => PayslipModel.fromJson(json)).toList();
  }

  Future<PayslipModel?> getPayslipByPeriod (int year, int month) async{
    final response = await _api.get('/payslips/$year/$month');
    return PayslipModel.fromJson(response.data['data']);
  }
}