import 'package:car_companion/data/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_search_service.g.dart';

@riverpod
class UserSearchService extends _$UserSearchService {
  final db = FirebaseFirestore.instance;

  @override
  FutureOr<List<User>> build() async {
    return searchUsers("");
  }

  Future<List<User>> searchUsers(String searchText) async {
    if (searchText == "") {
      return [];
    }
    var query = db.collection("User").where(Filter.and(Filter('username', isGreaterThanOrEqualTo: searchText),
            Filter('username', isLessThan: searchText + 'z')));
    
    // Execute query and ingest data
    var searchResults = await query.get().then((snapshot) {
        List<User> results = [];
        for (var document in snapshot.docs) {
          results.add(User.fromJson(document.id, document.data() as Map<String, dynamic>));
        }
        return results;
    });
    state = AsyncValue.data(searchResults);
    return searchResults;
  }
}
