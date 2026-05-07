import 'package:umkm_store/model/request/RegisterRequest.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final RegisterRequest request;

  RegisterSubmitted({
    required this.request,
  });
}
