import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bomb_busters/providers.dart';

class TeamDisplay extends ConsumerWidget {
  final double width;
  final double height;
  final bool isAdmin;
  final String gameId;

  const TeamDisplay({
    super.key,
    required this.width,
    required this.height,
    required this.isAdmin,
    required this.gameId,
  });

  void _selectMember(WidgetRef ref, String gameId, String memberName) {
    if (!isAdmin) return;
    ref.read(setAdminProvider({
      'gameId': gameId,
      'memberName': memberName,
    }));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(getStreamGameProvider(gameId));

    return gameAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (game) {
        const Color bgColor = Color(0xFF7CB9E8);
        const Color borderColor = Color(0xFFE88E5D);
        const Color activeColor = Color(0xFFFA9346);
        const Color inactiveColor = Colors.white;
        final Color itemColor = Colors.grey.shade300;

        final double verticalPadding = height * 0.02;
        final double gapHeight = height * 0.015;
        final double availableHeight =
            height - (verticalPadding * 2) - (gapHeight * (game.players.length - 1));
        final double itemHeight = availableHeight / game.players.length;
        final double fontSize = itemHeight * 0.45;
        final double circleSize = itemHeight * 0.60;

        return Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 3),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: game.players.length,
            separatorBuilder: (context, index) => SizedBox(height: gapHeight),
            itemBuilder: (context, index) {
              final member = game.players[index];

              return GestureDetector(
                onTap: () => _selectMember(ref, gameId, member),
                child: Container(
                  height: itemHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: itemColor,
                    borderRadius: BorderRadius.circular(itemHeight / 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        member,
                        style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: fontSize,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: circleSize,
                        width: circleSize,
                        decoration: BoxDecoration(
                          color:
                              member == game.captain ? activeColor : inactiveColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
