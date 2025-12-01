enum AppRoute {
  start(path:'/'),
  create(path:'/create'),
  join(path:'/join'),
  lobby(path:'/lobby'),
  show_cards(path:'/show_cards');
  const AppRoute({required this.path});
  final String path;
}