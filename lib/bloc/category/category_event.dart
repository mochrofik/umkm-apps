abstract class CategoryEvent {}

class FetchCategory extends CategoryEvent {
  final String search;
  final int page;
  FetchCategory({this.search = '', this.page = 1});
}
class FetchCategoryUser extends CategoryEvent {}
