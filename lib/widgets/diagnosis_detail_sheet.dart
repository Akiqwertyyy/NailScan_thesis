import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/diagnosis_result.dart';

import 'package:flutter/services.dart';

class DiagnosisDetailSheet extends StatelessWidget {
  final DiagnosisResult result;
  final String date;
  final String? imagePath;
  final VoidCallback onScanAgain;
  final Future<void> Function()? onDelete;
  const DiagnosisDetailSheet({
    super.key,
    required this.result,
    required this.date,
    required this.onScanAgain,
    this.imagePath,
    this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required DiagnosisResult result,
    required String date,
    required VoidCallback onScanAgain,
    String? imagePath,
    Future<void> Function()? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => DiagnosisDetailSheet(
        result: result,
        date: date,
        imagePath: imagePath,
        onScanAgain: onScanAgain,
        onDelete: onDelete,
      ),
    );
  }

  bool get _healthy => result.condition.toLowerCase().contains('healthy');
  Color get _accent => _healthy ? AppColors.success : AppColors.warning;
  String get _riskLabel => result.riskLevel == RiskLevel.low ? 'Low' : result.riskLevel == RiskLevel.moderate ? 'Moderate' : 'High';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, AppColors.background, AppColors.backgroundSoft])),
          child: SafeArea(
            child: Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(8, 8, 8, 8), child: Row(children: [IconButton(onPressed:()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded, color:AppColors.textDark)), const Expanded(child: Text('Scan Details', textAlign: TextAlign.center, style: TextStyle(fontSize:16, fontWeight:FontWeight.w900, color:AppColors.textDark))), IconButton(
                    onPressed: onDelete == null
                        ? null
                        : () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                title: const Text(
                                  'Delete Scan?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                content: const Text(
                                  'This scan result will be removed from your history.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
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
                              await onDelete?.call();

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  )])),
              Expanded(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), child: Column(children: [
                _summaryCard(), const SizedBox(height:12), _analysisCard(), const SizedBox(height:12), _infoCard(), const SizedBox(height:12), _recommendations(),
              ]))),
Padding(
  padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
  child: Row(
    children: [
      Expanded(
        child: _bottomButton(
          'Scan Again',
          true,
          () => Navigator.pop(context),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _bottomButton(
          'Exit',
          false,
          () => SystemNavigator.pop(),
        ),
      ),
    ],
  ),
),       
     ]),
          ),
        ),
      ),
    );
  }
  Widget _summaryCard()=>Container(padding: const EdgeInsets.all(12), decoration: _dec(), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(width:86,height:106,color:AppColors.surfaceSoft, child: imagePath!=null?Image.file(File(imagePath!), fit:BoxFit.cover, errorBuilder:(_,__,___)=>Icon(Icons.fingerprint_rounded,color:_accent,size:42)):Icon(Icons.fingerprint_rounded,color:_accent,size:42))),
    const SizedBox(width:14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(result.condition.replaceAll(' Nail',''), maxLines:1, overflow:TextOverflow.ellipsis, style: const TextStyle(fontSize:20, fontWeight:FontWeight.w900, color:AppColors.textDark))), Icon(_healthy?Icons.check_circle_rounded:Icons.warning_rounded, color:_accent, size:20)]), const SizedBox(height:4), Text(date, style: const TextStyle(fontSize:11, fontWeight:FontWeight.w600, color:AppColors.textSecondary)), const SizedBox(height:14), const Text('Confidence Score', style: TextStyle(fontSize:12, fontWeight:FontWeight.w800, color:AppColors.textSecondary)), Text('${result.confidence.toStringAsFixed(0)}%', style: const TextStyle(fontSize:22, fontWeight:FontWeight.w900, color:AppColors.primary)), ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: result.confidence/100, minHeight:6, backgroundColor:AppColors.border, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)))])),
  ]));
  Widget _analysisCard()=>_section('Analysis Details', Column(children: [_row('Shape', result.shape), _row('Color', result.color), _row('Texture', result.texture)]));
Widget _infoCard()=>_section('Additional Information', Column(children: [
  _kv('Risk Level', _riskLabel),
]));  Widget _recommendations()=>_section('Recommendations', Column(children: const [_Bullet('Maintain regular nail hygiene'), _Bullet('Avoid prolonged moisture exposure'), _Bullet('Use protective gloves when handling chemicals')]));
  Widget _section(String title, Widget child)=>Container(width:double.infinity, padding: const EdgeInsets.all(16), decoration: _dec(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize:15, fontWeight:FontWeight.w900, color:AppColors.primary)), const SizedBox(height:12), child]));
  Widget _row(String l, String v)=>Padding(padding: const EdgeInsets.only(bottom:10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(fontSize:12, fontWeight:FontWeight.w900, color:AppColors.textSecondary)), const SizedBox(height:3), Text(v, style: const TextStyle(fontSize:13, fontWeight:FontWeight.w600, color:AppColors.descriptionDark)), const Divider(color:AppColors.border)]));
  Widget _kv(String l, String v)=>Padding(padding: const EdgeInsets.only(bottom:8), child: Row(children: [Text(l, style: const TextStyle(fontSize:12, fontWeight:FontWeight.w900, color:AppColors.textSecondary)), const Spacer(), Text(v, style: const TextStyle(fontSize:12, fontWeight:FontWeight.w800, color:AppColors.textSecondary))]));
  Widget _bottomButton(String text, bool filled, VoidCallback tap)=>GestureDetector(onTap:tap, child: Container(height:50, alignment:Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: filled?null:Colors.white, gradient: filled?const LinearGradient(colors:[AppColors.primary, AppColors.primaryDark]):null, border: filled?null:Border.all(color:AppColors.border)), child: Text(text, style: TextStyle(color:filled?Colors.white:AppColors.primary, fontWeight:FontWeight.w900))));
  BoxDecoration _dec()=>BoxDecoration(color:Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color:AppColors.border), boxShadow: const [BoxShadow(color:AppColors.shadow, blurRadius:14, offset:Offset(0,5))]);
}
class _Bullet extends StatelessWidget{final String text; const _Bullet(this.text); @override Widget build(BuildContext context)=>Padding(padding: const EdgeInsets.only(bottom:10), child: Row(children: [const Icon(Icons.health_and_safety_outlined, size:17, color:AppColors.primary), const SizedBox(width:10), Expanded(child: Text(text, style: const TextStyle(fontSize:13, fontWeight:FontWeight.w700, color:AppColors.textSecondary)))]));}
