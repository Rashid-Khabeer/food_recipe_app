import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/components/recipes/popular_creator_widget.dart';

class PopularCreatorsPage extends StatefulWidget {
  const PopularCreatorsPage({
    Key? key,
    required this.dataFunction,
    required this.title,
    required this.canPop,
  }) : super(key: key);

  final Future<List<UserModel>> Function() dataFunction;
  final String title;
  final bool canPop;

  @override
  _PopularCreatorsPageState createState() => _PopularCreatorsPageState();
}

class _PopularCreatorsPageState extends State<PopularCreatorsPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        canPop: widget.canPop,
        controller: _scrollController,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).padding.bottom,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.title, style: kBoldW600f24Style),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            FutureBuilder(builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              return snapshot.hasData ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, index) {
                    return PopularCreatorWidget(
                      user: snapshot.data![index],
                    );
                  },
                  childCount: snapshot.data?.length,
                ),
              ) : const SizedBox();
            }, future: widget.dataFunction(),)
          ],
        ),
      ),
    );
  }
}
