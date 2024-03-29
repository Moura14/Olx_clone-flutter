import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:olx_mobx/components/drawer/custom_drawer.dart';
import 'package:olx_mobx/screens/home/components/ad_tile.dart';
import 'package:olx_mobx/screens/home/components/created_at_button.dart';
import 'package:olx_mobx/screens/home/components/search_dialog.dart';
import 'package:olx_mobx/screens/home/components/top_bar.dart';
import 'package:olx_mobx/stores/home_stores.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeStore homeStore = GetIt.I<HomeStore>();

  final ScrollController scrollController = ScrollController();

  openSearch(BuildContext context) async {
    final search = await showDialog(
        context: context,
        builder: (_) => SearchDialog(
              currentSearch: homeStore.search,
            ));

    if (search != null) homeStore.setSearch(search);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.purple,
            drawer: CustomDrawer(),
            appBar: AppBar(
                title: Observer(builder: (_) {
                  if (homeStore.search.isEmpty) return Container();
                  return GestureDetector(
                    onTap: () => openSearch(context),
                    child: LayoutBuilder(
                      builder: (_, constrains) {
                        return Container(
                            width: constrains.biggest.width,
                            child: Text(homeStore.search));
                      },
                    ),
                  );
                }),
                actions: [
                  Observer(builder: (_) {
                    if (homeStore.search.isEmpty)
                      return IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          openSearch(context);
                        },
                      );
                    return IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        homeStore.setSearch('');
                      },
                    );
                  })
                ]),
            body: Column(
              children: [
                TopBar(),
                Expanded(
                    child: Stack(
                  children: [
                    Observer(builder: (_) {
                      if (homeStore.error != null)
                        return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Ocorreu um erro! ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )
                                ]));
                      if (homeStore.loading)
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white)),
                        );
                      if (homeStore.showProgress)
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.border_all,
                                color: Colors.white,
                                size: 100,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Hmmm...Nenhum anúncio encontrado!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        );
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: homeStore.itemCount,
                        itemBuilder: (_, index) {
                          if (index < homeStore.adList.length)
                            return AdTile(homeStore.adList[index]);

                          homeStore.loadNextPage();
                          return Container(
                            height: 10,
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.purple),
                            ),
                          );
                        },
                      );
                    }),
                    Positioned(
                        bottom: -50,
                        left: 0,
                        right: 0,
                        child: CreatAdButton(scrollController))
                  ],
                ))
              ],
            )));
  }
}
