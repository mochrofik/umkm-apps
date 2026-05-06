abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}
