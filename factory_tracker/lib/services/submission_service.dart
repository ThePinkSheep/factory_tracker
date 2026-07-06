import 'package:supabase_flutter/supabase_flutter.dart';

class SubmissionService {
    final _client = Supabase.instance.client;

    Future<void> createSubmission({
        required String employeeId,
        required DateTime workDate,
        required Map<String, int> quantities,
    }) async {
        final submission = await _client
            .from('submissions')
            .insert({
                'employee_id': employeeId,
                'work_date': workDate.toIso8601String().split('T').first,
            })
            .select()
            .single();

        final submissionId = submission['id'];

        await _client.from('submission_lines').insert(
            quantities.entries
            .map((e) => {
                'submission_id': submissionId,
                'item_id': e.key,
                'quantity': e.value,
            })
            .toList(),
        );
    }
}