import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employee.dart';

class EmployeeService {
    final _client = Supabase.instance.client;

    Future<List<Employee>> getEmployees() async {
        final response = await _client
        .from('employees')
        .select()
        .order('name');

        return (response as List)
            .map((e) => Employee.fromJson(e))
            .toList();
    }
}