import 'package:fpdart/fpdart.dart';
import 'package:nutri_kit/core/error/failure.dart';
import 'package:nutri_kit/core/usecase/usecase.dart';
import 'package:nutri_kit/features/search/domain/entities/index.dart';
import 'package:nutri_kit/features/search/domain/repository/search_repository.dart';

class SearchRemedy implements UseCase<RemediesResponseEntity, SearchParams> {
  final SearchRepository searchRepository;

  const SearchRemedy(this.searchRepository);

  @override
  Future<Either<Failure, RemediesResponseEntity>> call(
      SearchParams params) async {
    return await searchRepository.searchRemedies(
      keyword: params.keyword,
      next: params.next,
      previous: params.previous,
    );
  }
}
