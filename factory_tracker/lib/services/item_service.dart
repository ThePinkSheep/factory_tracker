import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/items.dart';

class ItemService{
    final _client = Supabase.instance.client;

    Future<List<Item>> getItemsForEmployee(String employeeId) async {
        final response = await _client
            .from('employee_items')
            .select('item_id, items(*)')
            .eq('employee_id', employeeId);

        final items = (response as List)
            .map((e) => Item.fromJson(e['items']))
            .toList();

        items.sort((a, b) => a.name.compareTo(b.name));

        return items;
    }

    Future<List<Item>> getAllItems() async {
        final response = await _client
            .from('items')
            .select()
            .eq('active', true)
            .order('name');

        return (response as List)
            .map((e) => Item.fromJson(e))
            .toList();
    }

    Future<void> syncEmployeeItems(String employeeId, List<String> itemIds) async {
    await _client
        .from('employee_items')
        .delete()
        .eq('employee_id', employeeId);

    if (itemIds.isEmpty) return;

    await _client.from('employee_items').insert(
        itemIds.map((id) => {
        'employee_id': employeeId,
        'item_id': id,
        }).toList(),
    );
    }
}