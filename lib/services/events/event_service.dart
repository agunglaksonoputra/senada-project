import 'package:senada/models/events/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final SupabaseClient supabaseClient;

  EventService(this.supabaseClient);

  // Fetch all events
  Future<List<Event>> getEvents() async {
    final data = await supabaseClient
        .from('events')
        .select();

    return (data as List)
        .map((eventData) => Event.fromMap(eventData))
        .toList();
  }

  // Fetch top 5 latest events
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

  // Fetch events by category
  Future<List<Event>> getEventsByCategoryId(int categoryId) async {
  final response = await supabaseClient
      .from('event_categories')
      .select('event_id, events ( * )')
      .eq('category_id', categoryId);

  final List eventsData = response as List;

  // Ambil hanya data events
  final List<Event> events = eventsData.map((eventCategory) {
    final eventMap = eventCategory['events'];
    return Event.fromMap(eventMap);
  }).toList();

  return events;
}

}
