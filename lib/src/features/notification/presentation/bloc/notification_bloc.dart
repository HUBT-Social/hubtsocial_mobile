// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hubtsocial_mobile/src/features/notification/data/services/notification_service.dart';
// import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
// import 'package:hubtsocial_mobile/src/features/notification/presentation/bloc/notification_event.dart';
// import 'package:hubtsocial_mobile/src/features/notification/presentation/bloc/notification_state.dart';

// import '../../domain/repositories/notification_repository.dart';
// import 'package:hive/hive.dart';

// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   final NotificationRepository _repository;
//   final NotificationService _service;
//   StreamSubscription? _notificationSubscription;
//   final _box = Hive.box<NotificationModel>('notifications');

//   NotificationBloc(this._repository, this._service)
//       : super(NotificationInitial()) {
//     on<LoadNotifications>(_onLoadNotifications);
//     on<DeleteNotification>(_onDeleteNotification);
//     on<MarkAsRead>(_onMarkAsRead);
//     on<MarkAllAsRead>(_onMarkAllAsRead);
//     on<NotificationReceived>(_onNotificationReceived);
//     on<NewNotificationReceived>(_onNewNotificationReceived);

//     // Lắng nghe thông báo mới
//     _notificationSubscription =
//         _service.subscribeToNewNotifications().listen((notification) {
//       add(NewNotificationReceived(notification));
//     });
//   }

//   @override
//   Future<void> close() {
//     _notificationSubscription?.cancel();
//     return super.close();
//   }

//   Future<void> _onLoadNotifications(
//     LoadNotifications event,
//     Emitter<NotificationState> emit,
//   ) async {
//     try {
//       emit(NotificationLoading());
      
//       final notifications = _box.values.toList();
//       print("Đã load được ${notifications.length} thông báo từ Hive");
      
//       emit(NotificationLoaded(notifications));
//     } catch (e) {
//       print("Lỗi khi load thông báo: $e");
//       emit(NotificationError(e.toString()));
//     }
//   }

//   Future<void> _onDeleteNotification(
//     DeleteNotification event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is NotificationLoaded) {
//       try {
//         final updatedNotifications =
//             List<NotificationModelAdapter>.from(currentState.notifications)
//               ..removeWhere((notification) => notification.typeId == event.id);
//         emit(
//             NotificationLoaded(updatedNotifications.cast<NotificationModel>()));

//         await _repository.deleteNotification(event.id);
//       } catch (e) {
//         emit(NotificationError('Không thể xóa thông báo: ${e.toString()}'));
//         add(LoadNotifications());
//       }
//     }
//   }

//   Future<void> _onMarkAsRead(
//     MarkAsRead event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is NotificationLoaded) {
//       try {
//         final updatedNotifications =
//             currentState.notifications.map((notification) {
//           if (notification.id == event.id) {
//             return notification.copyWith(isRead: true);
//           }
//           return notification;
//         }).toList();

//         emit(NotificationLoaded(updatedNotifications));
//         await _repository.markAsRead(event.id);
//       } catch (e) {
//         emit(NotificationError('Không thể đánh dấu đã đọc: ${e.toString()}'));
//         add(LoadNotifications());
//       }
//     }
//   }

//   Future<void> _onMarkAllAsRead(
//     MarkAllAsRead event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is NotificationLoaded) {
//       try {
//         final updatedNotifications = currentState.notifications
//             .map((notification) => notification.copyWith(isRead: true))
//             .toList();

//         emit(NotificationLoaded(updatedNotifications));
//         await _repository.markAllAsRead();
//       } catch (e) {
//         emit(NotificationError(
//             'Không thể đánh dấu tất cả đã đọc: ${e.toString()}'));
//         add(LoadNotifications());
//       }
//     }
//   }

//   Future<void> _onNotificationReceived(
//     NotificationReceived event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is NotificationLoaded) {
//       try {
//         final updatedNotifications = [
//           event.notification,
//           ...currentState.notifications,
//         ];

//         emit(NotificationLoaded(updatedNotifications));
//         await _repository.saveNotification(event.notification);
//       } catch (e) {
//         emit(NotificationError(
//             'Không thể xử lý thông báo mới: ${e.toString()}'));
//       }
//     }
//   }

//   Future<void> _onNewNotificationReceived(
//     NewNotificationReceived event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is NotificationLoaded) {
//       try {
//         final updatedNotifications = [
//           event.notification,
//           ...currentState.notifications,
//         ];

//         emit(NotificationLoaded(updatedNotifications));
//         await _repository.saveNotification(event.notification);
//       } catch (e) {
//         emit(NotificationError(
//             'Không thể xử lý thông báo mới: ${e.toString()}'));
//       }
//     }
//   }
// }
