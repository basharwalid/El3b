import 'package:El3b/Core/Base/BaseViewModel.dart';
import 'package:El3b/Presentation/UI/Home/Tabs/Chat/ChatTabNavigator.dart';

class ChatTabViewModel extends BaseViewModel <ChatTabNavigator>{



  // function to go to create room screen
  goToCreateRoomScreen(){
    navigator!.goToCreateRoomScreen();
  }

}