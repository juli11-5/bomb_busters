import 'package:go_router/go_router.dart';
import 'package:bomb_busters/views/create/create.dart';
import 'package:bomb_busters/views/join/join.dart';
import 'package:bomb_busters/views/lobby/lobby.dart';
import 'package:bomb_busters/views/show_cards/show_cards.dart';
import 'package:bomb_busters/views/start/start.dart';
import 'package:bomb_busters/header_footer_scaffold.dart';
import 'package:bomb_busters/routes/routes.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.start.path,
      name: AppRoute.start.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: HeaderFooterScaffold(
          child: const StartScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.join.path,
      name: AppRoute.join.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: HeaderFooterScaffold(
          child: const JoinScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.create.path,
      name: AppRoute.create.name,
      pageBuilder: (context, state) => NoTransitionPage(
        child: HeaderFooterScaffold(
          child: const CreateScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoute.lobby.path,
      name: AppRoute.lobby.name,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final bool isAdmin = extra['isAdmin'] as bool? ?? false;
        final String gameId = extra['gameId'] as String? ?? '';
        final String name = extra['name'] as String? ?? '';

        return NoTransitionPage(
          child: HeaderFooterScaffold(
            child: LobbyScreen(isAdmin: isAdmin, gameId: gameId, name: name),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoute.showCards.path,
      name: AppRoute.showCards.name,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final String gameId = extra['gameId'] as String? ?? '';
        final String name = extra['name'] as String? ?? '';

        return NoTransitionPage(
          child: HeaderFooterScaffold(
            child: ShowCardsScreen(gameId: gameId, name: name),
          ),
        );
      },
    ),
  ],
);
