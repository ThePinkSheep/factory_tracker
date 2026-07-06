import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../models/items.dart';
import '../services/item_service.dart';
import 'review_screen.dart';

class QuantityEntryScreen extends StatefulWidget {
  final Employee employee;
  final DateTime date;

  const QuantityEntryScreen({super.key, required this.employee, required this.date});

  @override
  State<QuantityEntryScreen> createState() => _QuantityEntryScreenState();
}

class _QuantityEntryScreenState extends State<QuantityEntryScreen> {
  final ItemService _service = ItemService();
  List<Item> _allItems = [];
  Set<String> _visibleIds = {};
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = true;
  bool _showHidden = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final allItems = await _service.getAllItems();
    final assignedItems = await _service.getItemsForEmployee(widget.employee.id);
    final assignedIds = assignedItems.map((i) => i.id).toSet();

    setState(() {
      _allItems = allItems;
      _visibleIds = assignedIds.isNotEmpty
          ? assignedIds
          : allItems.map((i) => i.id).toSet();
      for (final item in allItems) {
        _controllers[item.id] = TextEditingController(text: '0');
      }
      _loading = false;
    });
  }

  void _toggleItem(String itemId) {
    setState(() {
      if (_visibleIds.contains(itemId)) {
        _visibleIds.remove(itemId);
        _controllers[itemId]!.text = '0';
      } else {
        _visibleIds.add(itemId);
      }
    });
  }

    Future<void> _onSubmit() async {
    final Map<String, int> quantities = {};
    for (final id in _visibleIds) {
        final value = int.tryParse(_controllers[id]!.text) ?? 0;
        if (value > 0) quantities[id] = value;
    }

    if (quantities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one quantity.')),
        );
        return;
    }

    await _service.syncEmployeeItems(
        widget.employee.id,
        _visibleIds.toList(),
    );

    if (mounted) {
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReviewScreen(
            employee: widget.employee,
            date: widget.date,
            quantities: quantities,
            items: _allItems,
            ),
        ),
        );
    }
    }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _allItems.where((i) => _visibleIds.contains(i.id)).toList();
    final hiddenItems = _allItems.where((i) => !_visibleIds.contains(i.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.employee.name),
            Text(widget.employee.company,
                style: const TextStyle(fontSize: 13)),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Visible items
                      ...visibleItems.map((item) => _buildVisibleRow(item)),

                      // Hidden items toggle
                      if (hiddenItems.isNotEmpty)
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _showHidden = !_showHidden),
                          icon: Icon(
                              _showHidden ? Icons.expand_less : Icons.expand_more),
                          label: Text(_showHidden
                              ? 'Hide other items'
                              : 'Show ${hiddenItems.length} more items'),
                        ),

                      if (_showHidden)
                        ...hiddenItems.map((item) => _buildHiddenRow(item)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Review & Submit',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildVisibleRow(Item item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text('Avg/day: ${item.averagePerDay.toStringAsFixed(0)}',
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              controller: _controllers[item.id],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.visibility_off, color: Colors.grey),
            onPressed: () => _toggleItem(item.id),
            tooltip: 'Hide this item',
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenRow(Item item) {
    return ListTile(
      title: Text(item.name, style: const TextStyle(color: Colors.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
        onPressed: () => _toggleItem(item.id),
        tooltip: 'Show this item',
      ),
    );
  }
}