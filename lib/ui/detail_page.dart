import 'package:flutter/material.dart';
import 'package:story_app/data/locale/auth_local_datasource.dart';
import 'package:story_app/provider/detail_provider.dart';
import 'package:story_app/service/api_service.dart';
import 'package:story_app/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/enumeration/result_state_enum.dart';
import '../widgets/custom_error.dart';

class DetailPage extends StatelessWidget {
  final String _storyId;

  const DetailPage({
    Key? key,
    required String restaurantId,
  })  : _storyId = restaurantId,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(
          apiService: ApiService(),
          authService: AuthService(
            locale: AuthLocalDatasource(prefs: SharedPreferences.getInstance()),
          ),
          storyId: _storyId,
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.black,
                  flexibleSpace: Consumer<DetailProvider>(
                    builder: (ctx, value, child) {
                      return FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: _storyId,
                              child: value.state == ResultState.hasData
                                  ? Image.network(
                                      value.listStory.photoUrl,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress != null) {
                                          return const CircularProgressIndicator();
                                        }

                                        return child;
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.5),
                                  end: Alignment.center,
                                  colors: <Color>[
                                    Color(0x80000000),
                                    Color(0x00000000),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          value.state == ResultState.hasData
                              ? value.listStory.name
                              : "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ];
            },
            body: Consumer<DetailProvider>(
              builder: (context, value, child) {
                if (value.state == ResultState.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            "Description",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            value.listStory.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (value.state == ResultState.loading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Loading Data.."),
                      ],
                    ),
                  );
                } else {
                  return CustomErrorWidget(
                    refresh: () => value.refreshData,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
