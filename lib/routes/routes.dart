enum AppRoute {
  start(path:'/'),
  create(path:'/create'),
  join(path:'/join'),
  lobby(path:'/lobby'),
  showCards(path:'/showCards');
  const AppRoute({required this.path});
  final String path;
}