part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class LoadActivities extends ActivityEvent {}

class AddActivity extends ActivityEvent {
  final ActivityLog activity;

  const AddActivity(this.activity);

  @override
  List<Object> get props => [activity];
}