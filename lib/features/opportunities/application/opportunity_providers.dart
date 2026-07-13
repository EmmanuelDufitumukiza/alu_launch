import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/opportunity_model.dart';
import '../data/opportunity_repository.dart';

final opportunityRepositoryProvider = Provider((ref) => OpportunityRepository());

final allOpenOpportunitiesProvider = StreamProvider<List<OpportunityModel>>((ref) {
  return ref.watch(opportunityRepositoryProvider).watchAllOpen();
});

final myPostedOpportunitiesProvider =
    StreamProvider.family<List<OpportunityModel>, String>((ref, startupId) {
  return ref.watch(opportunityRepositoryProvider).watchByStartup(startupId);
});

// Search/filter state — plain StateProvider holding the current search text
final opportunitySearchQueryProvider = StateProvider<String>((ref) => '');

// Derived provider: filters the live opportunity list by the search query
final filteredOpportunitiesProvider = Provider<AsyncValue<List<OpportunityModel>>>((ref) {
  final query = ref.watch(opportunitySearchQueryProvider).toLowerCase();
  final opportunities = ref.watch(allOpenOpportunitiesProvider);

  return opportunities.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((o) =>
        o.title.toLowerCase().contains(query) ||
        o.roleType.toLowerCase().contains(query) ||
        o.startupName.toLowerCase().contains(query)).toList();
  });
});