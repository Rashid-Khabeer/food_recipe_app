import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/home_view/popular_category_view.dart';
import 'package:food_recipie_app/src/components/recipes/popular_creator_widget.dart';
import 'package:food_recipie_app/src/components/recipes/popular_creators_page.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_widget.dart';
import 'package:food_recipie_app/src/components/recipes/recipes_page.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';
import '../recipes/recipe_search_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();
  final _service = RecipeFirestoreService();

  @override
  Widget build(BuildContext context) {
    var _style = kBoldW600f24Style.copyWith(fontSize: 20);
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: 'Find best recipes for cooking',
        canPop: false,
      ),
      body: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Text(
                'Find best recipes for cooking',
                style: kBoldW600f24Style,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
            child: AppTextField(
              readonly: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 14, 0),
                child: Image.asset(
                  AppAssets.search,
                  width: 16,
                  height: 16,
                  color: AppTheme.neutralColor.shade200,
                ),
              ),
              hint: 'Search recipes',
              onTap: () {
                AppNavigation.to(context, const RecipeSearchPage());
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Row(children: [
              Expanded(child: Text('Trending now 🔥', style: _style)),
              _seeAllButton(
                () {
                  AppNavigation.to(
                    context,
                    RecipesPage(
                      dataFunction: _service.fetchTrending,
                      title: 'Trending recipes',
                      canPop: true,
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: SimpleStreamBuilder<List<RecipeModel>>.simpler(
                stream: _service.fetchTrendingByLimit(),
                context: context,
                builder: (data) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return RecipeWidget(
                        recipe: data[i],
                        width: 280,
                        padding: const EdgeInsets.only(right: 16),
                      );
                    },
                    itemCount: data.length,
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 0, 16),
          sliver: SliverToBoxAdapter(
            child: Text('Popular category', style: _style),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(left: 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 310,
              child: PopularCategoryView(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Row(children: [
              Expanded(child: Text('Recent Recipe', style: _style)),
              _seeAllButton(
                () {
                  AppNavigation.to(
                    context,
                    RecipesPage(
                      dataFunction: _service.fetchAllSortedFirestore,
                      title: 'Recent recipes',
                      canPop: true,
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: SimpleStreamBuilder<List<RecipeModel>>.simpler(
                stream: _service.fetchTrendingByLimit(),
                context: context,
                builder: (data) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return RecipeWidget(
                        recipe: data[i],
                        width: 280,
                        padding: const EdgeInsets.only(right: 16),
                      );
                    },
                    itemCount: data.length,
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Row(children: [
              Expanded(child: Text('Popular Creators', style: _style)),
              _seeAllButton(
                    () {
                  AppNavigation.to(
                    context,
                    PopularCreatorsPage(
                      dataFunction: RecipeFirestoreService().popularCreators,
                      title: 'Popular Creators',
                      canPop: true,
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 130,
              child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                  return snapshot.hasData ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return PopularCreatorWidget(
                              user: snapshot.data![i],
                              width: 100,
                            );
                    },
                    itemCount: snapshot.data?.length ?? 0,
                  ) : const SizedBox();
                },
                future: RecipeFirestoreService().popularCreators(5),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom),
        ),
      ], controller: _scrollController),
    );
  }

  Widget _seeAllButton(VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Row(children: [
        const Text(
          'See all',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(width: 4),
        Image.asset(
          AppAssets.next,
          color: AppTheme.primaryColor.shade500,
          width: 20,
          height: 20,
        ),
      ]),
      style: TextButton.styleFrom(
        primary: AppTheme.primaryColor.shade500,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
