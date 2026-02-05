/// 真人亚洲面孔头像占位图（可替换为自有 CDN）
/// 使用 randomuser.me 肖像图，含多种族面孔
class AvatarUrls {
  AvatarUrls._();

  /// 女性头像索引 1–99
  static const List<String> women = [
    'https://randomuser.me/api/portraits/women/44.jpg',
    'https://randomuser.me/api/portraits/women/45.jpg',
    'https://randomuser.me/api/portraits/women/46.jpg',
    'https://randomuser.me/api/portraits/women/47.jpg',
    'https://randomuser.me/api/portraits/women/48.jpg',
    'https://randomuser.me/api/portraits/women/49.jpg',
    'https://randomuser.me/api/portraits/women/50.jpg',
    'https://randomuser.me/api/portraits/women/51.jpg',
    'https://randomuser.me/api/portraits/women/52.jpg',
    'https://randomuser.me/api/portraits/women/53.jpg',
  ];

  /// 男性头像索引 1–99
  static const List<String> men = [
    'https://randomuser.me/api/portraits/men/32.jpg',
    'https://randomuser.me/api/portraits/men/33.jpg',
    'https://randomuser.me/api/portraits/men/34.jpg',
    'https://randomuser.me/api/portraits/men/35.jpg',
    'https://randomuser.me/api/portraits/men/36.jpg',
    'https://randomuser.me/api/portraits/men/37.jpg',
    'https://randomuser.me/api/portraits/men/38.jpg',
    'https://randomuser.me/api/portraits/men/39.jpg',
    'https://randomuser.me/api/portraits/men/40.jpg',
    'https://randomuser.me/api/portraits/men/41.jpg',
  ];

  /// 根据用户 ID 或昵称取稳定头像（女性）
  static String forWomen(String idOrName) {
    final i = idOrName.hashCode.abs() % women.length;
    return women[i];
  }

  /// 根据用户 ID 或昵称取稳定头像（男性）
  static String forMen(String idOrName) {
    final i = idOrName.hashCode.abs() % men.length;
    return men[i];
  }

  /// 当前用户（我的）默认头像 - 女性
  static const String currentUserWomen = 'https://randomuser.me/api/portraits/women/44.jpg';
  /// 当前用户（我的）默认头像 - 男性
  static const String currentUserMen = 'https://randomuser.me/api/portraits/men/32.jpg';
}
