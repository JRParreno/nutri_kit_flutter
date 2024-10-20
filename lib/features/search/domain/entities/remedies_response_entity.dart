// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:nutri_kit/core/common/entities/list_response.dart';
import 'package:nutri_kit/features/remedy/domain/entities/index.dart';

class RemediesResponseEntity extends Equatable {
  final ListResponse listResponse;
  final List<RemedyEntity> results;

  const RemediesResponseEntity({
    required this.listResponse,
    required this.results,
  });

  @override
  List<Object?> get props => [
        listResponse,
        results,
      ];

  RemediesResponseEntity copyWith({
    ListResponse? listResponse,
    List<RemedyEntity>? results,
  }) {
    return RemediesResponseEntity(
      listResponse: listResponse ?? this.listResponse,
      results: results ?? this.results,
    );
  }
}
