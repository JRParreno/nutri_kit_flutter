import 'package:equatable/equatable.dart';

class FoodCategoryEntity extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String? image;

  const FoodCategoryEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        name,
        description,
        image,
      ];
}
