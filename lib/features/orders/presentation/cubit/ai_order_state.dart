import 'package:equatable/equatable.dart';
import '../widgets/ai_suggested_items_card.dart';

abstract class AiOrderState extends Equatable {
  const AiOrderState();
  @override
  List<Object?> get props => [];
}

class AiOrderInitial extends AiOrderState {}

class AiOrderLoading extends AiOrderState {}

class AiOrderSuccess extends AiOrderState {
  final String originalPrompt;
  final List<AiOrderItem> items;

  const AiOrderSuccess({
    required this.originalPrompt,
    required this.items,
  });

  @override
  List<Object?> get props => [originalPrompt, items];
}

class AiOrderError extends AiOrderState {
  final String message;
  const AiOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
