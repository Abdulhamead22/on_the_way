import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/gemini_service.dart';
import '../widgets/ai_suggested_items_card.dart';
import 'ai_order_state.dart';

class AiOrderCubit extends Cubit<AiOrderState> {
  final GeminiService geminiService;

  AiOrderCubit({required this.geminiService}) : super(AiOrderInitial());

  Future<void> generateOrderFromPrompt(String prompt) async {
    if (prompt.trim().isEmpty) {
      emit(const AiOrderError('يرجى كتابة طلبك أولاً ليقوم الذكاء الاصطناعي بتجهيزه'));
      return;
    }

    emit(AiOrderLoading());
    try {
      final rawItems = await geminiService.parseOrderPrompt(prompt);
      final items = rawItems.map((map) {
        return AiOrderItem(
          name: map['name']?.toString() ?? 'غرض غير محدد',
          quantity: map['quantity']?.toString() ?? '1',
          price: (map['price'] as num?)?.toDouble() ?? 5.0,
          isSelected: true,
        );
      }).toList();

      emit(AiOrderSuccess(originalPrompt: prompt, items: items));
    } on ServerException catch (e) {
      emit(AiOrderError(e.message));
    } catch (e) {
      emit(const AiOrderError('حدث خطأ غير متوقع أثناء تحليل الطلب'));
    }
  }
}
