import 'package:flutter/material.dart';
import 'package:momo_payment_flutter/momo_payment_flutter.dart';

import 'cart_service.dart';
import 'purchase_history_service.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];
  int _total = 0;
  bool _loadedArgs = false;

  static const String kRedirectUrl = 'momopayment://return';

  static const String kIpnUrl = 'https://your-public-server.com/momo/ipn';

  static const String kPartnerCode = 'MOMO';
  static const String kAccessKey = 'F8BBA842ECF85';
  static const String kSecretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz';
  static const bool kIsTestMode = true;

  late final MomoPayment _momo;
  String? _orderId;
  String? _requestId;
  bool _momoBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _momo = MomoPayment(
      partnerCode: kPartnerCode,
      accessKey: kAccessKey,
      secretKey: kSecretKey,
      isTestMode: kIsTestMode,
      isDebug: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      final rawItems = args['items'];
      final rawTotal = args['total'];

      _items = (rawItems is List)
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : <Map<String, dynamic>>[];

      _total = rawTotal is int ? rawTotal : 0;
    } else {
      _items = <Map<String, dynamic>>[];
      _total = 0;
    }

    _loadedArgs = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkMomoStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final total = _total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán MoMo'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Không có sản phẩm được chọn'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = (item['name'] ?? '').toString();

                      final dynamic rawPrice = item['price'];
                      final int price = rawPrice is int
                          ? rawPrice
                          : int.tryParse(rawPrice?.toString() ?? '') ?? 0;

                      final qty = item['quantity'] as int? ?? 1;
                      final img = (item['image'] ?? '').toString();

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 64,
                                height: 64,
                                color: const Color(0xFFEAF4FF),
                                child: img.isNotEmpty
                                    ? Image.asset(
                                        img,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.inventory_2_outlined,
                                          size: 26,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 26,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Số lượng: $qty'),
                                ],
                              ),
                            ),
                            Text(
                              _formatPrice(price * qty),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng thanh toán',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            _formatPrice(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _momoBusy ? null : () => _startMomoPayment(total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0006D), 
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _momoBusy
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.account_balance_wallet_outlined),
                        label: Text(
                          _momoBusy ? 'Đang chuyển sang MoMo...' : 'Thanh toán bằng MoMo',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }


  Future<void> _startMomoPayment(int amount) async {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền không hợp lệ')),
      );
      return;
    }

    try {
      setState(() => _momoBusy = true);

      final ts = DateTime.now().millisecondsSinceEpoch;
      _orderId = 'ORDER_$ts';
      _requestId = 'REQ_$ts';

      final info = MomoPaymentInfo(
        orderId: _orderId!,
        requestId: _requestId!,
        orderInfo: 'Thanh toán đơn hàng #$_orderId',
        amount: amount,
        redirectUrl: kRedirectUrl,
        ipnUrl: kIpnUrl,
        requestType: 'captureWallet',
        lang: 'vi',
      );

      final res = await _momo.createPayment(info);

      if (!mounted) return;

      if (res.payUrl == null) {
        _orderId = null;
        _requestId = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không có payUrl: ${res.message ?? ''}')),
        );
        return;
      }

      await _momo.openPaymentPage(res.payUrl!);
    } catch (e) {
      _orderId = null;
      _requestId = null;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi MoMo: $e')),
      );
    } finally {
      if (mounted) setState(() => _momoBusy = false);
    }
  }

  Future<void> _checkMomoStatus() async {
    if (_orderId == null || _requestId == null) return;

    try {
      final res = await _momo.checkStatus(orderId: _orderId!, requestId: _requestId!);

      if (!mounted) return;

      if (res.resultCode == 0) {
        _orderId = null;
        _requestId = null;
        _finalizeSuccess();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MoMo: ${res.message ?? 'Chưa thành công'} (code ${res.resultCode})')),
      );

      _orderId = null;
      _requestId = null;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi checkStatus: $e')),
      );
    }
  }

  void _finalizeSuccess() {
    PurchaseHistoryService.instance.addPurchase(
      items: _items,
      totalAmount: _total,
      paymentMethod: 'MoMo',
    );

    CartService.instance.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thanh toán MoMo thành công!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  String _formatPrice(int price) {
    final text = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final pos = text.length - i;
      buf.write(text[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '$buf đ';
  }
}
