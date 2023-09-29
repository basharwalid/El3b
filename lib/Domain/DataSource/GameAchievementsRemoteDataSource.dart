
import 'package:El3b/Domain/Models/Achievements/Achievement.dart';

abstract class GameAchievementsRemoteDataSource {

  Future<List<Achievement>?> getGameAchievements({required String id});

}