class EndpointConstant {
  EndpointConstant._();

  static const String baseUrl = 'http://localhost:3000/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // Users
  static const String createUser = '/users';
  static const String getUsers = '/users';
  static const String getMe = '/users/me';

  // Categories
  static const String categoriesPagination = '/categories/pagination';

  // Materials
  static const String materialsPagination = '/materials/pagination';
  static String materialById(String id) => '/materials/$id';
  static String materialCommentsPagination(String id) => '/materials/$id/comments/pagination';
  static String materialComments(String id) => '/materials/$id/comments';
  static String materialInteractions(String id) => '/materials/$id/interactions';
  static String materialStatus(String id) => '/materials/$id/status';

  // Chatbot
  static const String chatbotAsk = '/chatbot/ask';
  static const String chatbotHistoryPagination = '/chatbot/history/pagination';

  // Admin - Categories
  static const String adminCreateCategory = '/admin/categories';
  static String adminUpdateCategory(String id) => '/admin/categories/$id';
  static String adminDeleteCategory(String id) => '/admin/categories/$id';

  // Admin - Materials
  static const String adminCreateMaterial = '/admin/materials';
  static String adminUpdateMaterial(String id) => '/admin/materials/$id';
  static String adminDeleteMaterial(String id) => '/admin/materials/$id';

  // Admin - Vector Documents
  static const String adminCreateVectorDocument = '/admin/vector-documents';

  // Admin - Users
  static String adminUpdateUserRole(String id) => '/admin/users/$id/role';
}