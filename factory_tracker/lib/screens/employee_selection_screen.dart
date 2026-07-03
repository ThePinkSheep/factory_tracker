import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeSelectionScreen extends StatefulWidget {
  const EmployeeSelectionScreen({super.key});

  @override
  State<EmployeeSelectionScreen> createState() => _EmployeeSelectionScreenState();
}

class _EmployeeSelectionScreenState extends State<EmployeeSelectionScreen> {
  final EmployeeService _service = EmployeeService();
  List<Employee> _employees = [];
  List<Employee> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final employees = await _service.getEmployees();
    setState(() {
      _employees = employees;
      _filtered = employees;
      _loading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = _employees
          .where((e) =>
              e.name.toLowerCase().contains(query.toLowerCase()) ||
              e.company.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Employee'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search by name or company...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final employee = _filtered[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                        title: Text(
                          employee.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(employee.company),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigation to entry screen comes next
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}