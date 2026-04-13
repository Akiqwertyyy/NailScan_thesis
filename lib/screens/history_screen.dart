import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/history_item.dart';

// Import AppColors from home_screen or define locally:
// (copy AppColors here if not sharing via a separate colors.dart)
const Color _primary   = Color(0xFFC97A5A);
const Color _mid       = Color(0xFFD9956E);
const Color _blush     = Color(0xFFD4A09A);
const Color _light     = Color(0xFFECC9B8);
const Color _cream     = Color(0xFFF9EDE6);
const Color _textDark  = Color(0xFF4A2416);
const Color _textMid   = Color(0xFF7A4030);
const Color _textMuted = Color(0xFFAA7060);
const Color _cardBorder= Color(0xFFF0D0C0);

// Semantic colours (kept meaningful but warmed)
const Color _healthy   = Color(0xFF8BAF7A); // muted sage – healthy status
const Color _danger    = Color(0xFFD0604A); // warm red  – disease/error
const Color _unident   = Color(0xFFB8A09A); // warm grey – unidentified

class HistoryScreen extends StatefulWidget {
  final Function(String)? onNavigate;
  final String? currentScreen;
  final List<HistoryItem> historyItems;
  final Function(int)? onDeleteItem;
  final VoidCallback? onClearAll;
  final VoidCallback? onScanAgain;

  const HistoryScreen({
    super.key,
    this.onNavigate,
    this.currentScreen,
    this.historyItems = const [],
    this.onDeleteItem,
    this.onClearAll,
    this.onScanAgain,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 1;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const List<String> _screenKeys = ['home', 'history', 'about'];

  @override
  void initState() {
    super.initState();

    if (widget.currentScreen != null) {
      final idx = _screenKeys.indexOf(widget.currentScreen!);
      if (idx != -1) _selectedIndex = idx;
    }

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          _buildBackground(size),
          _buildBlurredOverlay(size),
          _buildBokehDots(size),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(size),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5DDD0),
            Color(0xFFF9EDE6),
            Color(0xFFF2D8C8),
            Color(0xFFEDCFBE),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildBlurredOverlay(Size size) {
    return Positioned(
      top: -40,
      right: -60,
      child: Opacity(
        opacity: 0.18,
        child: Container(
          width: size.width * 0.75,
          height: size.height * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const RadialGradient(
              colors: [Color(0xFFECC9B8), Color(0xFFD4A09A)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBokehDots(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _BokehPainter()),
      ),
    );
  }

  Widget _buildMainContent(Size size) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: widget.historyItems.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
        ),
        const SizedBox(height: 88),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Scan History',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: _textDark,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _primary.withOpacity(0.18),
              ),
            ),
            child: Text(
              '${widget.historyItems.length} scan${widget.historyItems.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _textMid,
              ),
            ),
          ),
          if (widget.historyItems.isNotEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showClearAllDialog(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: _danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _danger.withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _danger,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: _primary.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 46,
              color: _blush,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your scan results will appear here after you complete your first nail analysis.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _textMuted,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => widget.onScanAgain?.call(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD9956E), Color(0xFFC97A5A)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Start a Scan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.historyItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.historyItems[index];
        return _buildHistoryCard(item);
      },
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    Color statusColor;
    IconData statusIcon;

    switch (item.type) {
      case HistoryItemType.healthy:
        statusColor = _healthy;
        statusIcon = Icons.check_circle_rounded;
        break;
      case HistoryItemType.unidentified:
        statusColor = _unident;
        statusIcon = Icons.help_rounded;
        break;
      default:
        statusColor = _danger;
        statusIcon = Icons.warning_rounded;
    }

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: _danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: _danger),
      ),
      onDismissed: (_) => widget.onDeleteItem?.call(item.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Image or icon placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: item.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          statusIcon,
                          color: statusColor,
                          size: 28,
                        ),
                      ),
                    )
                  : Icon(statusIcon, color: statusColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.condition,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Confidence badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${item.confidence.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear All History',
          style: TextStyle(fontWeight: FontWeight.w700, color: _textDark),
        ),
        content: const Text(
          'This will permanently delete all scan records.',
          style: TextStyle(color: _textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearAll?.call();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: _danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            border: Border(
              top: BorderSide(color: _cardBorder.withOpacity(0.5), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0, screenKey: 'home'),
              _buildNavItem(icon: Icons.history_rounded, label: 'History', index: 1, screenKey: 'history'),
              _buildNavItem(icon: Icons.info_outline_rounded, label: 'About', index: 2, screenKey: 'about'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required String screenKey,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        widget.onNavigate?.call(screenKey);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26,
              color: isSelected ? _primary : const Color(0xFFB8A09A)),
            const SizedBox(height: 4),
            Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? _primary : const Color(0xFFB8A09A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BokehPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dots = [
      [0.08, 0.12, 18.0, 0.18], [0.88, 0.06, 12.0, 0.13],
      [0.15, 0.55, 10.0, 0.10], [0.92, 0.35, 22.0, 0.15],
      [0.5,  0.08,  8.0, 0.12], [0.75, 0.75, 16.0, 0.10],
      [0.3,  0.88, 20.0, 0.08], [0.65, 0.5,   6.0, 0.09],
      [0.02, 0.72, 14.0, 0.11], [0.95, 0.88, 10.0, 0.08],
    ];
    for (final d in dots) {
      canvas.drawCircle(
        Offset(size.width * d[0], size.height * d[1]),
        d[2],
        Paint()
          // Warm peach bokeh dots instead of cold blue
          ..color = const Color(0xFFD9956E).withOpacity(d[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
