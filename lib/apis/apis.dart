class APi {
  static List<Map<String, dynamic>> user = const [
    {"url": "localhost:5000", "route": "Userinfo/officeData"},
    {"url": "localhost:5000", "route": "Notifications/searchData"},
    {"url": "localhost:5000", "route": "Notifications/filterData"},
  ];

  static List<Map<String, dynamic>> signin = const [
    {"url": "localhost:5000", "route": "Office/signinData"},
  ];

  static List<Map<String, dynamic>> shop = const [
    {"url": "localhost:5000", "route": "Shop/chooseData"},
    {"url": "localhost:5000", "route": "Shop/searchData"},
    {"url": "localhost:5000", "route": "Shop/statistData"},
    {"url": "localhost:5000", "route": "Shop/categoryData"},
    {"url": "localhost:5000", "route": "Shop/closedData"},
    {"url": "localhost:5000", "route": "Shop/openedData"},
    {"url": "localhost:5000", "route": "Shop/waitedData"},
    {"url": "localhost:5000", "route": "Shop/restartData"},
    {"url": "localhost:5000", "route": "Shop/deleteData"},
    {"url": "localhost:5000", "route": "Shop/modifyData"},
    {"url": "localhost:5000", "route": "Shop/insertData"},
    {"url": "localhost:5000", "route": "Shop/createData"},
    {"url": "localhost:5000", "route": "Shop/removeData"},
    {"url": "localhost:5000", "route": "Shop/increaseData"},
    {"url": "localhost:5000", "route": "Shop/soldoutData"},
  ];

  static List<Map<String, dynamic>> office = const [
    {"url": "localhost:5000", "route": "Office/searchData"},
    {"url": "localhost:5000", "route": "Office/checkData"},
    {"url": "localhost:5000", "route": "Office/insertData"},
    {"url": "localhost:5000", "route": "Office/deleteData"},
  ];

  static List<Map<String, dynamic>> bank = const [
    {"url": "localhost:5000", "route": "Bank/balanceData"},
    {"url": "localhost:5000", "route": "Bank/searchData"},
    {"url": "localhost:5000", "route": "Bank/statistData"},
    {"url": "localhost:5000", "route": "Bank/analysisData"},
    {"url": "localhost:5000", "route": "Bank/detailData"},
    {"url": "localhost:5000", "route": "Bank/checkData"},
    {"url": "localhost:5000", "route": "Bank/storedData"},
    {"url": "localhost:5000", "route": "Bank/pickupData"},
  ];

  static List<Map<String, dynamic>> calendar = const [
    {"url": "localhost:5000", "route": "Calendar/searchData"},
    {"url": "localhost:5000", "route": "Calendar/categoryData"},
    {"url": "localhost:5000", "route": "Calendar/deleteData"},
    {"url": "localhost:5000", "route": "Calendar/modifyData"},
    {"url": "localhost:5000", "route": "Calendar/createData"},
  ];

  static List<Map<String, dynamic>> suggest = const [
    {"url": "localhost:5000", "route": "Suggest/searchData"},
    {"url": "localhost:5000", "route": "Suggest/createData"},
    {"url": "localhost:5000", "route": "Suggest/deleteData"},
  ];

  static List<Map<String, dynamic>> preview = const [
    {"url": "localhost:5000", "route": "Preview/searchData"},
    {"url": "localhost:5000", "route": "Preview/totalData"},
  ];

  static List<Map<String, dynamic>> profile = const [
    {"url": "localhost:5000", "route": "Profile/searchData"},
  ];
}
