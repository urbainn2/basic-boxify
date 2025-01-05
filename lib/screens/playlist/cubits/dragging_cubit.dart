import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles the border around a [Track] when you're dragging
/// to reposition within a [Playlist]. Notifies the [TrackMouseRow]
/// the it is a [DragTarget] and needs to paint a blue border
/// above or below.
class DraggingCubit extends Cubit<DraggingState> {
  DraggingCubit() : super(DraggingInitial());

  void updateAboveTarget(bool value, int index) =>
      emit(DraggingAboveTarget(value, index));
  void updateBelowTarget(bool value, int index) =>
      emit(DraggingBelowTarget(value, index));
  void updateTappingRow(bool value, int index) =>
      emit(TappingRow(value, index));
  void updateDoubleTappingRow(bool value, int index) =>
      emit(DoubleTappingRow(value, index));
}

abstract class DraggingState {}

class DraggingInitial extends DraggingState {}

class DraggingAboveTarget extends DraggingState {
  final bool isAboveTarget;
  final int index;

  DraggingAboveTarget(this.isAboveTarget, this.index);
}

class DraggingBelowTarget extends DraggingState {
  final bool isBelowTarget;
  final int index;

  DraggingBelowTarget(this.isBelowTarget, this.index);
}

class TappingRow extends DraggingState {
  final bool isTappingRow;
  final int index;

  TappingRow(this.isTappingRow, this.index);
}

class DoubleTappingRow extends DraggingState {
  final bool isDoubleTappingRow;
  final int index;

  DoubleTappingRow(this.isDoubleTappingRow, this.index);
}
