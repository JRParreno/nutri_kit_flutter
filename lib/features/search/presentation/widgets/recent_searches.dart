import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_kit/features/search/presentation/blocs/search/search_bloc.dart';
import 'package:nutri_kit/gen/colors.gen.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({
    super.key,
    required this.keywords,
    required this.onClearRecent,
    required this.onTapKeyword,
  });

  final List<String> keywords;
  final VoidCallback onClearRecent;
  final Function(String value) onTapKeyword;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (keywords.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No Recent Searches',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onClearRecent,
              child: Text(
                'Clear All',
                style: textTheme.titleMedium?.copyWith(color: ColorName.link),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: keywords.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                onTapKeyword(keywords[index]);
                context.read<SearchBloc>().add(
                      SearchTriggerEvent(
                        keywords[index],
                      ),
                    );
              },
              child: Text(
                keywords[index],
                style: textTheme.titleMedium,
              ),
            ),
          ),
        )
      ],
    );
  }
}
