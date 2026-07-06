import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../models/items.dart';
import '../services/submission_service.dart';

class ReviewScreen extends StatefulWidget {
  final Employee employee;
  final DateTime date;
  final Map<String, int> quantities;
  final List<Item> items;

  const ReviewScreen({
    super.key,
    required this.employee,
    required this.date,
    required this.quantities,
    required this.items,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final SubmissionService _service = SubmissionService();
  bool _submitting = false;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _onConfirm() async {
    setState(() => _submitting = true);

    try {
      await _service.createSubmission(
        employeeId: widget.employee.id,
        workDate: widget.date,
        quantities: widget.quantities,
      );

      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission saved successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final submittedItems = widget.items
        .where((i) => widget.quantities.containsKey(i.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Submission'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Summary header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.employee.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(widget.employee.company,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('Work date: ${_formatDate(widget.date)}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Items list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: submittedItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = submittedItems[index];
                final quantity = widget.quantities[item.id]!;
                final earned = quantity * item.rate;

                return Row(
                  children: [
                    Expanded(
                      child: Text(item.name,
                          style: const TextStyle(fontSize: 16)),
                    ),
                    Text('x $quantity',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 16),
                    Text('${earned.toStringAsFixed(2)} RON',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey[600])),
                  ],
                );
              },
            ),
          ),

          // Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${submittedItems.fold(0.0, (sum, item) => sum + widget.quantities[item.id]! * item.rate).toStringAsFixed(2)} RON',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _submitting ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Go Back',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _submitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Confirm',
                            style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}