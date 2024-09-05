import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:nutri_kit/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:nutri_kit/core/config/shared_prefences_keys.dart';
import 'package:nutri_kit/core/error/error_page.dart';
import 'package:nutri_kit/core/notifier/shared_preferences_notifier.dart';
import 'package:nutri_kit/features/deficiency/presentation/pages/deficiency_detail_page.dart';
import 'package:nutri_kit/features/food/presentation/pages/food_detail_page.dart';
import 'package:nutri_kit/features/home/presentation/pages/home.dart';
import 'package:nutri_kit/features/home/presentation/pages/pdf_view_sample.dart';
import 'package:nutri_kit/features/home/presentation/pages/pinggang_pinoy_pdf_viewer_page.dart';
import 'package:nutri_kit/features/meal/domain/entities/index.dart';
import 'package:nutri_kit/features/meal/presentation/pages/child_meal_plan_detail_page.dart';
import 'package:nutri_kit/features/meal/presentation/pages/create_child_health_page.dart';
import 'package:nutri_kit/features/meal/presentation/pages/first_create_child_health_page.dart';
import 'package:nutri_kit/features/meal/presentation/pages/meal_plan_breakdown_page.dart';
import 'package:nutri_kit/features/meal/presentation/pages/user_child_list_page.dart';
import 'package:nutri_kit/features/navigation/presentation/scaffold_with_bottom_nav.dart';
import 'package:nutri_kit/features/on_boarding/on_boarding.dart';
import 'package:nutri_kit/features/profile/presentation/pages/profile.dart';
import 'package:nutri_kit/features/profile/presentation/pages/update_profile.dart';
import 'package:nutri_kit/features/remedy/presentation/pages/remedy_detail_page.dart';
import 'package:nutri_kit/features/search/presentation/pages/search.dart';
import 'package:nutri_kit/router/index.dart';

import '../features/auth/presentation/pages/index.dart';

/// Contains all of the app routes configurations
GoRouter routerConfig() {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mainNavigator');
  final shellNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorHomeKey');
  final shellNavigatorSearchKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorSearchKey');
  final shellNavigatorProfileKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorProfileKey');
  final shellNavigatorMealKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorMealKey');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.login.path,
    errorPageBuilder: (context, state) {
      return buildTransitionPage(
        localKey: state.pageKey,
        child: const ErrorPage(),
      );
    },
    refreshListenable:
        GoRouterRefreshStream(GetIt.instance<AppUserCubit>().stream),
    redirect: (context, state) {
      final sharedPreferencesNotifier =
          GetIt.instance<SharedPreferencesNotifier>();
      final bool isLoggedIn = sharedPreferencesNotifier.getValue(
          SharedPreferencesKeys.isLoggedIn, false);
      final bool isOnBoarded = sharedPreferencesNotifier.getValue(
          SharedPreferencesKeys.isOnBoarded, false);

      final loggingIn = state.matchedLocation == AppRoutes.login.path;
      final signingIn = state.matchedLocation == AppRoutes.signup.path;
      final profilePath = state.matchedLocation == AppRoutes.profile.path;

      if (!isOnBoarded) {
        return AppRoutes.onBoarding.path;
      }

      if (isLoggedIn && (loggingIn || signingIn)) {
        return AppRoutes.home.path;
      }

      if (!isLoggedIn && (loggingIn || profilePath)) {
        return AppRoutes.login.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onBoarding.path,
        name: AppRoutes.onBoarding.name,
        pageBuilder: (context, state) {
          return buildTransitionPage(
            localKey: state.pageKey,
            child: const OnBoardingPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        pageBuilder: (context, state) {
          return buildTransitionPage(
            localKey: state.pageKey,
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signup.path,
        name: AppRoutes.signup.name,
        pageBuilder: (context, state) {
          return buildTransitionPage(
            localKey: state.pageKey,
            child: const SingupPage(),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => ScaffoldWithBottomNav(child: child),
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home.path,
                name: AppRoutes.home.name,
                pageBuilder: (context, state) {
                  return buildTransitionPage(
                    localKey: state.pageKey,
                    child: const HomePage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: AppRoutes.search.path,
                name: AppRoutes.search.name,
                pageBuilder: (context, state) {
                  return buildTransitionPage(
                    localKey: state.pageKey,
                    child: const SearchPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorMealKey,
            routes: [
              GoRoute(
                  path: AppRoutes.meal.path,
                  name: AppRoutes.meal.name,
                  pageBuilder: (context, state) {
                    return buildTransitionPage(
                      localKey: state.pageKey,
                      child: const UserChildListPage(),
                    );
                  },
                  routes: const []),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorProfileKey,
            routes: [
              GoRoute(
                  path: AppRoutes.profile.path,
                  name: AppRoutes.profile.name,
                  pageBuilder: (context, state) {
                    return buildTransitionPage(
                      localKey: state.pageKey,
                      child: const ProfilePage(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: AppRoutes.updateProfile.path,
                      name: AppRoutes.updateProfile.name,
                      pageBuilder: (context, state) {
                        return buildTransitionPage(
                          localKey: state.pageKey,
                          child: const UpdateProfilePage(),
                        );
                      },
                    ),
                  ]),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.remedyDetail.path,
        name: AppRoutes.remedyDetail.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildTransitionPage(
            localKey: state.pageKey,
            child: RemedyDetailPage(
              id: id,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.foodDetail.path,
        name: AppRoutes.foodDetail.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildTransitionPage(
            localKey: state.pageKey,
            child: FoodDetailPage(
              id: id,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.deficiencyDetail.path,
        name: AppRoutes.deficiencyDetail.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildTransitionPage(
            localKey: state.pageKey,
            child: DeficiencyDetailPage(
              id: id,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.chidlMealPlanDetailPage.path,
        name: AppRoutes.chidlMealPlanDetailPage.name,
        pageBuilder: (context, state) {
          final userMealPlanId = state.pathParameters['userMealPlanId']!;
          final mealPlanId = state.pathParameters['mealPlanId']!;
          final isCreated = state.pathParameters['isCreated']!;
          final healthStatusInfos = state.extra as List<String>?;

          return buildTransitionPage(
            localKey: state.pageKey,
            child: ChildMealPlanDetailPage(
              mealPlanId: mealPlanId,
              userMealPlanId: userMealPlanId,
              isCreated: isCreated == "true",
              healthStatusInfos: healthStatusInfos,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mealBreakdownPage.path,
        name: AppRoutes.mealBreakdownPage.name,
        pageBuilder: (context, state) {
          final dayMealCompletionEntity =
              state.extra as DayMealCompletionEntity;

          return buildTransitionPage(
            localKey: state.pageKey,
            child: MealPlanBreakdownPage(
              dayMealCompletionEntity: dayMealCompletionEntity,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.homePDFViewer.path,
        name: AppRoutes.homePDFViewer.name,
        pageBuilder: (context, state) {
          final pdfParams = state.extra as PDFParams;

          return buildTransitionPage(
            localKey: state.pageKey,
            child: PdfViewSample(
              pdfParams: pdfParams,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createChildHealthForm.path,
        name: AppRoutes.createChildHealthForm.name,
        pageBuilder: (context, state) {
          return buildTransitionPage(
            localKey: state.pageKey,
            child: const CreateChildHealthPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.firstCreateChildHealthForm.path,
        name: AppRoutes.firstCreateChildHealthForm.name,
        pageBuilder: (context, state) {
          return buildTransitionPage(
            localKey: state.pageKey,
            child: const FirstCreateChildHealthPage(),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage buildTransitionPage({
  required LocalKey localKey,
  required Widget child,
}) {
  return CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.linearToEaseOut).animate(animation),
        child: child,
      );
    },
    key: localKey,
    child: child,
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
