import 'package:El3b/Core/Base/BaseViewModel.dart';
import 'package:El3b/Domain/Exception/DioServerException.dart';
import 'package:El3b/Domain/Exception/InternetConnectionException.dart';
import 'package:El3b/Domain/Exception/TimeOutOperationsException.dart';
import 'package:El3b/Domain/Exception/UnknownException.dart';
import 'package:El3b/Domain/Models/Games/GameDetails/GameDetails.dart';
import 'package:El3b/Domain/Models/Games/RAWG/RAWGGame.dart';
import 'package:El3b/Domain/UseCase/GetGameDetailsUseCase.dart';
import 'package:El3b/Presentation/UI/GameDetails/GameDetailsNavigator.dart';


class GameDetailsViewModel extends BaseViewModel<GameDetailsNavigator> {


  RAWGGame game;
  GetGameDetailsUseCase getGameDetailsUseCase;
  GameDetailsViewModel({required this.game , required this.getGameDetailsUseCase});

  GameDetails? gameDetails;
  String? gameErrorMessage ;

  // function to get the game details
  void getGameDetails()async{
    gameDetails = null ;
    gameErrorMessage = null;
    notifyListeners();
    try {
      gameDetails = await getGameDetailsUseCase.invoke(id: game.id.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioServerException) {
        gameErrorMessage = e.errorMessage;
      } else if (e is TimeOutOperationsException) {
        gameErrorMessage = local!.operationTimedOut;
      } else if (e is InternetConnectionException) {
        gameErrorMessage = local!.checkYourInternetConnection;
      } else if (e is UnknownException) {
        gameErrorMessage = e.errorMessage;
      } else {
        gameErrorMessage = e.toString();
      }
      notifyListeners();
    }

  }

  // function to calc the total ratings of the game
  double calcGameRatingsCount(){
    double count = 0;
    for(int i =0 ; i<gameDetails!.ratings!.length;i++){
      count += gameDetails!.ratings![i].count??0;
    }
    return count;
  }

  // function to calc the steps of the gradiant based on the rating count
  List<double> calcStepsList(){

    double count = calcGameRatingsCount();
    double sum = 0 ;
    List<double> steps = [];

    for(int i = 0; i<gameDetails!.ratings!.length ; i++){
      steps.add(sum);
      sum += (gameDetails!.ratings![i].count! / count);
      steps.add(sum);
    }

    return steps;

  }


}