import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/domain/repositories/activity_repository.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc(this._activityRepository) : super(ActivityInitial()) {
    on<LoadActivities>(_onLoadActivities);
    on<AddActivity>(_onAddActivity);
  }

  void _onLoadActivities(LoadActivities event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    final failureOrActivities = await _activityRepository.getActivities();
    failureOrActivities.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(ActivityLoaded(activities)),
    );
  }

  void _onAddActivity(AddActivity event, Emitter<ActivityState> emit) async {
    final failureOrSuccess = await _activityRepository.logActivity(event.activity);
    failureOrSuccess.fold(
      (failure) => emit(ActivityError(failure.message)),
      (_) => add(LoadActivities()),
    );
  }
}
