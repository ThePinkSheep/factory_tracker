import 'package:flutter/material.dart';
import 'employee_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factory Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context,
              icon: Icons.edit_note,
              label: 'Manual Entry',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmployeeSelectionScreen()),
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuButton(
              context,
              icon: Icons.document_scanner,
              label: 'Scan Form (OCR)',
              onTap: null, // coming later
              disabled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool disabled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 32),
        label: Text(label, style: const TextStyle(fontSize: 22)),
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? Colors.grey[300] : Colors.blue,
          foregroundColor: disabled ? Colors.grey[600] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}