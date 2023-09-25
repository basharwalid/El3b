import 'package:El3b/Core/Base/BaseState.dart';
import 'package:El3b/Domain/UseCase/GetGenresUseCase.dart';
import 'package:El3b/Presentation/UI/GamesList/GamesListView.dart';
import 'package:El3b/Presentation/UI/GamesSearch/GameSearchView.dart';
import 'package:El3b/Presentation/UI/Home/Tabs/Explore/ExploreTabNavigator.dart';
import 'package:El3b/Presentation/UI/Home/Tabs/Explore/ExploreTabViewModel.dart';
import 'package:El3b/Presentation/UI/Home/Tabs/Explore/Widgets/TabButton.dart';
import 'package:El3b/Presentation/UI/Widgets/CustomSearchBarButton.dart';
import 'package:El3b/Presentation/UI/Widgets/ErrorMessageWidget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';

class ExploreTabView extends StatefulWidget {
  const ExploreTabView({super.key});

  @override
  State<ExploreTabView> createState() => _ExploreTabViewState();
}

class _ExploreTabViewState
    extends BaseState<ExploreTabView, ExploreTabViewModel>
    implements ExploreTabNavigator {
  @override
  void initState() {
    super.initState();
    viewModel!.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel!,
      builder: (context, child) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 70,
          titleSpacing: 10,
          centerTitle: true,
          leadingWidth: 0,
          title: CustomSearchBarButton(
            navigation: viewModel!.goToSearchScreen,
          ),
        ),
        body: Consumer<ExploreTabViewModel>(
          builder: (context, value, child) {
            if (value.errorMessage != null) {
              return ErrorMessageWidget(
                  errorMessage: value.errorMessage!,
                  fixErrorFunction: value.getGenres);
            } else if (value.genres.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: value.themeProvider!.isDark()
                        ? Lottie.asset("Assets/Animations/loading2.json",
                            width: 150, height: 120)
                        : Lottie.asset("Assets/Animations/loading3.json",
                            width: 300, height: 300),
                  ),
                ],
              );
            } else {
              return ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10
                                ),
                              itemBuilder: (context, index) => TabButton(
                                genre: value.genres[index],
                                goToSearchScreen: value.goToGameListScreen,
                              ),
                              itemCount: value.genres.length,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
            }
          },
        ),
      ),
    );
  }

  @override
  ExploreTabViewModel initViewModel() {
    return ExploreTabViewModel(getGenresUseCase: injectGetGenresUseCase(),);
  }

  @override
  goToGameListScreen(String id) {

    Navigator.pushNamed(context, GamesListView.routeName , arguments: id);
  }
}
