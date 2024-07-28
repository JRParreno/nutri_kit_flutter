import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nutri_kit/features/search/domain/entities/index.dart';
import 'package:nutri_kit/features/search/presentation/widgets/index.dart';
import 'package:nutri_kit/gen/assets.gen.dart';
import 'package:nutri_kit/router/index.dart';

class SearchRemedySuccess extends StatelessWidget {
  const SearchRemedySuccess({
    super.key,
    this.data,
  });

  final RemediesResponseEntity? data;

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();
    if (data!.results.isEmpty) return const SizedBox();

    return SearchBaseHeaderSuccess(
      displayTitle: 'Remedy',
      isShowViewAll: data!.results.length > 2,
      onTViewAll: () {},
      children: data!.results
          .take(2)
          .map(
            (e) => SearchTileItem(
              defaultImage: Assets.images.placeholder.remedy.image(),
              title: e.name,
              description: e.description,
              onTap: () {
                context.pushNamed(
                  AppRoutes.remedyDetail.name,
                  pathParameters: {"id": e.id.toString()},
                );
              },
            ),
          )
          .toList(),
    );
  }
}