import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: 'My Profile',
        canPop: false,
        color: Colors.white,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff314F7C).withOpacity(0.1),
                    blurRadius: 51,
                    offset: const Offset(0, 16),
                    spreadRadius: -16,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(children: [
                const Text('My Profile', style: kBoldW600f24Style),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 44, 0, 16),
                  child: Row(children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.primaryColor.shade500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(107, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ]),
                ),
                Text(
                  'Rashid Khabeer',
                  style: kBoldW600f24Style.copyWith(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                  child: Text(
                    'Hello I am Rashid, I am from Pakistan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.neutralColor.shade600,
                    ),
                  ),
                ),
                Text(
                  'Recipe',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.neutralColor.shade600,
                  ),
                ),
                const Text(
                  '14',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ),
          )
        ],
      ),
    );
  }
}
