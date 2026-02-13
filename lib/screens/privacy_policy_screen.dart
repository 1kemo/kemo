import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/privacy_config.dart';
import '../utils/theme.dart';

/// 隐私政策展示页。未配置真实 URL 或远程加载失败时，展示本地 HTML，确保审核时内容可见。
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _localHtml;

  /// 使用桌面 Chrome User-Agent，避免 Google Sites 在 WebView 中重定向到登录页
  static const String _desktopUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _setLoading(true),
          onPageFinished: (_) => _setLoading(false),
          onWebResourceError: (WebResourceError error) {
            if ((error.isForMainFrame ?? false) && _localHtml != null && mounted) {
              _controller.loadHtmlString(_localHtml!);
              _setLoading(false);
            }
          },
        ),
      );
    _loadContent();
  }

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  Future<void> _loadContent() async {
    final String? html = await _loadLocalHtml();
    if (!mounted) return;
    _localHtml = html;

    if (kPrivacyPolicyUrlIsPlaceholder || html == null) {
      if (html != null) {
        _controller.loadHtmlString(html);
      }
      _setLoading(false);
      return;
    }

    try {
      await _controller.setUserAgent(_desktopUserAgent);
      await _controller.loadRequest(Uri.parse(kPrivacyPolicyUrl));
    } catch (_) {
      if (html != null) _controller.loadHtmlString(html);
      _setLoading(false);
    }
  }

  Future<String?> _loadLocalHtml() async {
    try {
      return await rootBundle.loadString('assets/privacy_policy.html');
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '隐私政策',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricPurple),
              ),
            ),
        ],
      ),
    );
  }
}
