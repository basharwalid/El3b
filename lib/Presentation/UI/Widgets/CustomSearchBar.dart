import 'package:El3b/Core/Providers/AppConfigProvider.dart';
import 'package:El3b/Core/Providers/ThemeProvider.dart';
import 'package:El3b/Core/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSearchBarButton extends StatelessWidget {
  const CustomSearchBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AppConfigProvider configProvider = Provider.of<AppConfigProvider>(context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return InkWell(
      onTap: (){},
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
        margin:const EdgeInsets.all(10),
        padding:const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 2 ,color: MyTheme.lightPurple),
          color: themeProvider.isDark()?MyTheme.purple :MyTheme.offWhite
        ),
        child: Row(
          children: [
            Icon(BoxIcons.bx_search_alt , size: 30, color: themeProvider.isDark()?MyTheme.grayPurple : MyTheme.lightPurple,),
            const SizedBox(width: 10,),
            Expanded(
              child: Text(
                "${local.whatAreYouSearchingFor} ${configProvider.getUser()!.displayName!.split(" ")[0]}",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: themeProvider.isDark()?MyTheme.grayPurple : MyTheme.lightPurple,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}