import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nutri_kit/core/config/shared_prefences_keys.dart';
import 'package:nutri_kit/core/error/failure.dart';
import 'package:nutri_kit/core/notifier/shared_preferences_notifier.dart';
import 'package:nutri_kit/core/usecase/usecase.dart';
import 'package:nutri_kit/features/search/domain/entities/index.dart';
import 'package:nutri_kit/features/search/domain/usecase/search_deficiency.dart';
import 'package:nutri_kit/features/search/domain/usecase/search_food.dart';
import 'package:nutri_kit/features/search/domain/usecase/search_remedy.dart';
import 'package:nutri_kit/features/search/domain/usecase/search_vitamin.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SharedPreferencesNotifier _sharedPreferencesNotifier;
  final SearchFood _searchFood;
  final SearchRemedy _searchRemedy;
  final SearchDeficiency _searchDeficiency;
  final SearchVitamin _searchVitamin;

  SearchBloc({
    required SharedPreferencesNotifier sharedPreferencesNotifier,
    required SearchFood searchFood,
    required SearchRemedy searchRemedy,
    required SearchDeficiency searchDeficiency,
    required SearchVitamin searchVitamin,
  })  : _sharedPreferencesNotifier = sharedPreferencesNotifier,
        _searchFood = searchFood,
        _searchRemedy = searchRemedy,
        _searchDeficiency = searchDeficiency,
        _searchVitamin = searchVitamin,
        super(SearchInitial()) {
    on<SearchGetRecentSearches>(onSearchGetRecentSearches);
    on<SearchTriggerEvent>(onSearchTriggerEvent);
  }

  void onSearchGetRecentSearches(
      SearchGetRecentSearches event, Emitter<SearchState> emit) {
    final recentSearches = _sharedPreferencesNotifier.getValue(
        SharedPreferencesKeys.recentSearches, [] as List<String>);

    emit(SearchRecentLoaded(recentSearches));
  }

  Future<void> onSearchTriggerEvent(
      SearchTriggerEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    final deficiencyResponse = _searchDeficiency.call(
      SearchParams(keyword: event.keyword),
    );
    final remedyResponse = _searchRemedy.call(
      SearchParams(keyword: event.keyword),
    );
    final foodResponse = _searchFood.call(
      SearchParams(keyword: event.keyword),
    );
    final vitaminResponse = _searchVitamin.call(
      SearchParams(keyword: event.keyword),
    );

    final List<Either<Failure, Equatable>> results =
        await Isolate.run<List<Either<Failure, Equatable>>>(() async {
      return await Future.wait([
        deficiencyResponse,
        remedyResponse,
        foodResponse,
        vitaminResponse,
      ]);
    });

    final deficiencyResult =
        results[0] as Either<Failure, DeficiencyResponseEntity>;
    final remedyResult = results[1] as Either<Failure, RemediesResponseEntity>;
    final foodResult = results[2] as Either<Failure, FoodResponseEntity>;
    final vitaminResult = results[3] as Either<Failure, VitaminResponseEntity>;

    if (deficiencyResult.isLeft() &&
        remedyResult.isLeft() &&
        foodResult.isLeft() &&
        vitaminResult.isLeft()) {
      emit(const SearchFailure('Something went wrong'));
      return;
    }

    if (deficiencyResult.foldRight(
          true,
          (acc, b) => b.results.isEmpty,
        ) &&
        remedyResult.foldRight(
          true,
          (acc, b) => b.results.isEmpty,
        ) &&
        foodResult.foldRight(
          true,
          (acc, b) => b.results.isEmpty,
        ) &&
        vitaminResult.foldRight(
          true,
          (acc, b) => b.results.isEmpty,
        )) {
      emit(SearchEmpty());
      return;
    }

    emit(
      SearchSuccess(
          deficiencyResponse: deficiencyResult.fold((l) => null, (r) => r),
          remediesResponse: remedyResult.fold((l) => null, (r) => r),
          foodResponse: foodResult.fold((l) => null, (r) => r),
          vitaminResponse: vitaminResult.fold((l) => null, (r) => r)),
    );
  }
}
