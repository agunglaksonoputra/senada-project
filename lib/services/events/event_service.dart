import 'package:senada/models/events/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final SupabaseClient supabaseClient;

  EventService(this.supabaseClient);

  Future<List<Event>> getEvents() async {
    final data = await supabaseClient
        .from('events')
        .select();

    return (data as List)
        .map((eventData) => Event.fromMap(eventData))
        .toList();
  }

  Future<List<Event>> getTop5Events() async {
    final data = await supabaseClient
        .from('events')
        .select()
        .order('created_at', ascending: false)
        .limit(5);

    return (data as List)
        .map((item) => Event.fromMap(item))
        .toList();
  }
}