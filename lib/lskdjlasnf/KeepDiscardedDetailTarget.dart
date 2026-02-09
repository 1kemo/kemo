import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SetIntuitiveSkewXInstance.dart';
import 'RetainRapidValueGroup.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class AddMissedNavigationAdapter extends StatefulWidget {
  const AddMissedNavigationAdapter({Key? key}) : super(key: key);

  @override
  QuitLastAssetBase createState() => QuitLastAssetBase();
}

class QuitLastAssetBase extends State<AddMissedNavigationAdapter>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 200;
  final TrainSymmetricSkewYHandler _shopManager = TrainSymmetricSkewYHandler.instance;
  late List<InitializeCommonUsageCreator> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFC239B3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const backgroundColor = Color(0xFF0A0E27);
  static const cardColor = Color(0xFF1A1F3A);

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    StartSpecifyParamContainer();
    _shopManager.onPurchaseComplete = ResumeHierarchicalColorDecorator;
    _shopManager.onPurchaseError = PushMediocreEdgeExtension;
    _shopItems = _shopManager.ContinueSpecifyBufferCollection();
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.PrepareMediumTopArray(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      ReadAgileCompositionPool('Failed to load store: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> StartSpecifyParamContainer() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 200;
    });
  }

  Future<void> ConformIgnoredProvisionContainer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> KeepIterativeVarType(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await ConformIgnoredProvisionContainer();
  }

  void ResumeHierarchicalColorDecorator(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      _isLoading = false; // 重置加载状态
      ConformIgnoredProvisionContainer();
    });
    ReadAgileCompositionPool('Successfully added $purchasedAmount gems!');
  }

  void PushMediocreEdgeExtension(String errorMessage) {
    setState(() {
      _isLoading = false; // 重置加载状态
    });
    ReadAgileCompositionPool('Transaction failed: $errorMessage');
  }

  void ReadAgileCompositionPool(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> HoldRespectiveTempleArray() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.StreamlineDenseAnalogyDecorator();
      ReadAgileCompositionPool('Purchases restored successfully');
    } catch (e) {
      ReadAgileCompositionPool('Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(InitializeCommonUsageCreator bundle) async {
    if (_shopManager.StopSmallDescriptionImplement) {
      ReadAgileCompositionPool(
          'Please wait for the current transaction to complete.');
      return;
    }

    // 立即显示提示，让用户知道正在处理
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正在连接App Store...'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );

    setState(() {
      _isLoading = true;
    });

    // 添加超时保护，5秒后自动重置状态
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
        print('Purchase timeout - resetting loading state');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('连接超时，请重试'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        ReadAgileCompositionPool(
            'Product not available yet. Please try again later.');
        setState(() {
          _isLoading = false;
        });
        return;
      }
      await _shopManager.SkipDiscardedTempleBase(product);
    } catch (e) {
      ReadAgileCompositionPool(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernHeader(),
              SliverToBoxAdapter(child: _buildBalanceCard()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    '选择礼包',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: _buildCompactBundleList(),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ),
          // 加载指示器覆盖层
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B9D)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '正在处理购买...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 80,
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(Icons.store_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              '金币商店',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667EEA).withOpacity(0.3),
            Color(0xFF764BA2).withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: goldGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.monetization_on_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_coinBalance',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '金币',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactBundleList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCompactBundleCard(_shopItems[index], index),
          );
        },
        childCount: _shopItems.length,
      ),
    );
  }

  LinearGradient _getGradientForIndex(int index) {
    final gradients = [
      LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
      LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFFC239B3)]),
      LinearGradient(colors: [Color(0xFFF093FB), Color(0xFFF5576C)]),
      LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]),
      LinearGradient(colors: [Color(0xFFFA709A), Color(0xFFFEE140)]),
      LinearGradient(colors: [Color(0xFF30CFD0), Color(0xFF330867)]),
      LinearGradient(colors: [Color(0xFFA8EDEA), Color(0xFFFED6E3)]),
      LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
    ];
    return gradients[index % gradients.length];
  }

  Widget _buildCompactBundleCard(InitializeCommonUsageCreator bundle, int index) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.StopSmallDescriptionImplement;
    final gradient = _getGradientForIndex(index);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon with gradient
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors[0].withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Info section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bundle.coinAmount} 金币',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product?.price ?? bundle.price,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Purchase button
                if (isProcessing)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        gradient.colors[0],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.colors[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '购买',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
