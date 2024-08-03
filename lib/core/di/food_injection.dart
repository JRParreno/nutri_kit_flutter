import 'package:get_it/get_it.dart';
import 'package:nutri_kit/features/food/data/datasources/food_remote_data_source.dart';
import 'package:nutri_kit/features/food/data/repository/food_repository_impl.dart';
import 'package:nutri_kit/features/food/domain/repository/food_repository.dart';
import 'package:nutri_kit/features/food/domain/usecase/get_food_detail.dart';
import 'package:nutri_kit/features/food/presentation/bloc/food_detail_bloc.dart';

void foodInit(GetIt serviceLocator) {
  // datasources
  serviceLocator
    ..registerFactory<FoodRemoteDataSource>(
      () => FoodRemoteDataSourceImpl(),
    )
    // repository
    ..registerFactory<FoodRepository>(
      () => FoodRepositoryImpl(serviceLocator()),
    )
    // usecase
    ..registerFactory(() => GetFoodDetail(serviceLocator()))
    // bloc
    ..registerFactory(
      () => FoodDetailBloc(getFoodDetail: serviceLocator()),
    );
}