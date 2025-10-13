class ApiBase {
  static const String user = 'https://e-fatoora.wexeltech.xyz/api/v1/user';
}

class ApiPaths {
  // Auth
  static const String login = '/login';
  static const String me = '/me';
  static const String clients = '/clients';
  static const String deleteUser = '/delete';

  // Company
  static const String companyInvoices = '/company-invoices';
  static const String products = '/products';
  static const String branches = '/branches';

  static const String downloadInvoice = '/company-invoices-download';
}

class ApiEndpoints {
  // Auth
  static String get login => '${ApiBase.user}${ApiPaths.login}';
  static String get me => '${ApiBase.user}${ApiPaths.me}';
  static String get clients => '${ApiBase.user}${ApiPaths.clients}';
  static String get deleteUser => '${ApiBase.user}${ApiPaths.deleteUser}';

  static String get companyInvoices =>
      '${ApiBase.user}${ApiPaths.companyInvoices}';
  static String get products => '${ApiBase.user}${ApiPaths.products}';
  static String get branches => '${ApiBase.user}${ApiPaths.branches}';

  static String downloadInvoice(String id) =>
      '${ApiBase.user}${ApiPaths.downloadInvoice}/$id';

  // Dynamic endpoints (Path params)
  static String deleteProduct(int productId) =>
      '${ApiBase.user}${ApiPaths.products}/$productId';
}

class ApiCodes {
  static const int success = 200;
}
