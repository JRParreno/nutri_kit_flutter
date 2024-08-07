import 'package:equatable/equatable.dart';

class DeficiencyEntity extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;

  const DeficiencyEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        name,
        description,
      ];
}
