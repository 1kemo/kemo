class InitializeCommonUsageCreator {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const InitializeCommonUsageCreator({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<InitializeCommonUsageCreator> shopInventory = <InitializeCommonUsageCreator>[
  InitializeCommonUsageCreator(
    itemId: 'qwe_6',
    name: '入门礼包',
    type: 'basic',
    coinAmount: 80,
    price: '¥6',
    description: '80金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  InitializeCommonUsageCreator(
    itemId: 'qwe_8',
    name: '超值礼包',
    type: 'basic',
    coinAmount: 98,
    price: '¥8',
    description: '98金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  InitializeCommonUsageCreator(
    itemId: 'qwe_28',
    name: '热门礼包',
    type: 'basic',
    coinAmount: 318,
    price: '¥28',
    description: '318金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  InitializeCommonUsageCreator(
    itemId: 'qwe_58',
    name: '精选礼包',
    type: 'basic',
    coinAmount: 688,
    price: '¥58',
    description: '688金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  InitializeCommonUsageCreator(
    itemId: 'qwe_98',
    name: '豪华礼包',
    type: 'basic',
    coinAmount: 1158,
    price: '¥98',
    description: '1158金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  InitializeCommonUsageCreator(
    itemId: 'qwe_198',
    name: '至尊礼包',
    type: 'basic',
    coinAmount: 2358,
    price: '¥198',
    description: '2358金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
];
