import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item.dart';

class ItemService{
    final _client = Supabase.instance.client;

    Future<List<Item>> getItemsForEmployee(String employeeId) async {
        final response = await _client
            .from('employee_items')
            .select('item_id, items(*)')
            .eq('employee_id', employeeId);

        return (response as List)
            .map((e) => Item.fromJson(e['items']))
            .toList();
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
}