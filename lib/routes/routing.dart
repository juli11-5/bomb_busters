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
      pageBuilder: (context, state){
        final bool isAdmin = state.extra as bool? ?? false;
        final String gameId = state.queryParameters['gameId'] ?? '';
        final String name = state.queryParameters['name'] ?? '';
        return NoTransitionPage(
          child: HeaderFooterScaffold(
            child: LobbyScreen(isAdmin: isAdmin, gameId: gameId, name: name),
          ),
        );
      }
    ),
    GoRoute(
      path: AppRoute.show_cards.path,
      name: AppRoute.show_cards.name,
      pageBuilder: (context, state) {
        final (gameId, name) = state.extra as (String, String);
        return NoTransitionPage(
          child: HeaderFooterScaffold(
            child: ShowCardsScreen(gameId: gameId, name: name),
          ),
        );
      }
    ),
  ],
);

