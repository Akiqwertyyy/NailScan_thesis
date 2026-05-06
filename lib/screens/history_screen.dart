import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/history_item.dart';
import '../widgets/diagnosis_detail_sheet.dart';
import '../widgets/bottom_nav_bar.dart';

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

class _HistoryScreenState extends State<HistoryScreen> {
  void _openHistoryDetail(HistoryItem item) {
    if (item.diagnosisResult == null) return;

    DiagnosisDetailSheet.show(
      context,
      result: item.diagnosisResult!,
      date: item.date,
      imagePath: item.imagePath,
      onScanAgain: () => widget.onScanAgain?.call(),
      onDelete: () async {
        widget.onDeleteItem?.call(item.id);
      },
    );
  }

  Future<void> _confirmClearAll() async {
    if (widget.historyItems.isEmpty) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete all history?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF071F55),
          ),
        ),
        content: const Text(
          'This will permanently remove all saved scan results.',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F668F),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF4F668F),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      widget.onClearAll?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) widget.onNavigate?.call('home');
          if (index == 1) widget.onNavigate?.call('history');
          if (index == 2) widget.onNavigate?.call('about');
        },
      ),
      body: Stack(
        children: [
          _buildBackground(size),
          const _SoftCircle(top: -90, left: -70, size: 260, opacity: .24),
          const _SoftCircle(top: 120, right: -90, size: 230, opacity: .15),
          const _SoftCircle(bottom: 80, left: -100, size: 250, opacity: .16),
          SafeArea(
            bottom: false,
            child: widget.historyItems.isEmpty
                ? _buildEmptyContent()
                : _buildHistoryContent(),
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
            Color(0xFFD5EBFF),
            Color(0xFFEEF7FF),
            Color(0xFFBFDFFF),
            Color(0xFF88C4FF),
          ],
          stops: [0.0, 0.34, 0.72, 1.0],
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            physics: const BouncingScrollPhysics(),
            itemCount: widget.historyItems.length + 2,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              if (index == 0) return _buildAutoSaveCard();
              if (index == 1) return _buildRecentTitle();

              final item = widget.historyItems[index - 2];
              return _buildHistoryCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                iconColor: const Color(0xFF0B2E6F),
                onTap: () => widget.onNavigate?.call('home'),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Scan History',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B2E6F),
                    letterSpacing: -.6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _HeaderIconButton(
                icon: Icons.delete_outline_rounded,
                iconColor: widget.historyItems.isEmpty
                    ? const Color(0xFFB8C7E0)
                    : Colors.red,
                onTap: widget.historyItems.isEmpty ? null : _confirmClearAll,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 52),
            child: Text(
              'View your past nail scan results',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4667A0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveCard() {
    return _GlassCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5FA8FF), Color(0xFF006DFF)],
              ),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Results are automatically saved',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF006DFF),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'All your scan results are securely stored and can be viewed anytime.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF071F55),
                  ),
                ),
              ],
            ),
          ),

          // Ito yung ">" icon. Naka-keep siya.
        ],
      ),
    );
  }

  Widget _buildRecentTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 2),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Recent Scans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF071F55),
              ),
            ),
          ),
          Text(
            '${widget.historyItems.length} result${widget.historyItems.length == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17448A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    final status = _statusData(item);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openHistoryDetail(item),
        child: _GlassCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 86,
                  height: 96,
                  color: const Color(0xFFE9F2FF),
                  child: item.imagePath != null
                      ? Image.file(
                          File(item.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            status.icon,
                            color: status.color,
                            size: 34,
                          ),
                        )
                      : Icon(status.icon, color: status.color, size: 34),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.condition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF071F55),
                      ),
                    ),
                    const SizedBox(height: 7),
                    _InfoLine(
                      icon: Icons.verified_user_outlined,
                      text: '${item.confidence.toStringAsFixed(0)}% Confidence',
                      color: const Color(0xFF006DFF),
                    ),
                    const SizedBox(height: 7),
                    _InfoLine(
                      icon: Icons.calendar_month_outlined,
                      text: item.date,
                      color: const Color(0xFF4F668F),
                    ),
                    const SizedBox(height: 8),
                    _RiskPill(label: status.riskLabel, color: status.riskColor),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF006DFF),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _HistoryStatus _statusData(HistoryItem item) {
    switch (item.type) {
      case HistoryItemType.healthy:
        return const _HistoryStatus(
          color: Color(0xFF2E9D45),
          riskColor: Color(0xFF2E9D45),
          icon: Icons.check_circle_outline_rounded,
          label: 'Healthy',
          riskLabel: 'Low Risk',
        );
      case HistoryItemType.unidentified:
        return const _HistoryStatus(
          color: Color(0xFF7E8BA0),
          riskColor: Color(0xFF7E8BA0),
          icon: Icons.help_outline_rounded,
          label: 'Unidentified',
          riskLabel: 'Uncertain Risk',
        );
      default:
        return const _HistoryStatus(
          color: Color(0xFFD71920),
          riskColor: Color(0xFFFF8A00),
          icon: Icons.speed_rounded,
          label: 'Disease',
          riskLabel: 'Moderate Risk',
        );
    }
  }

  Widget _buildEmptyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: _GlassCard(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF006DFF).withOpacity(.10),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        size: 46,
                        color: Color(0xFF006DFF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No History Yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF071F55),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your scan results will appear here after your first analysis.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4F668F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 88),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.40),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(.72),
            width: 1,
          ),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.86),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF006DFF).withOpacity(.10),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskPill extends StatelessWidget {
  final String label;
  final Color color;

  const _RiskPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryStatus {
  final Color color;
  final Color riskColor;
  final IconData icon;
  final String label;
  final String riskLabel;

  const _HistoryStatus({
    required this.color,
    required this.riskColor,
    required this.icon,
    required this.label,
    required this.riskLabel,
  });
}

class _SoftCircle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftCircle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * .45),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}