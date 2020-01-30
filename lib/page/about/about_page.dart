import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixez/bloc/iap_bloc.dart';
import 'package:pixez/bloc/iap_event.dart';
import 'package:pixez/bloc/iap_state.dart';
import 'package:pixez/generated/i18n.dart';
import 'package:pixez/page/about/bloc/about_bloc.dart';
import 'package:pixez/page/about/bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<IapBloc>(context)..add(FetchIapEvent());
    return BlocProvider<AboutBloc>(
      child: Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).About),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.email),
            //   onPressed: () {

            //     showCupertinoDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return CupertinoPopupSurface(
            //       child: Text('data'),

            //         );
            //       },
            //     );
            //   },
            // )
          ],
        ),
        body: _buildInfo(context),
      ),
      create: (BuildContext context) => AboutBloc(),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return     BlocListener<IapBloc, IapState>(
              listener: (context, state) {
                if (state is ThanksState) {
                  BotToast.showNotification(title: (_) => Text('Thanks!'));
                }
              },
      child: BlocBuilder<AboutBloc, AboutState>(builder: (context, snapshot) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/me.jpg'),
              ),
              title: Text('Perol_Notsfsssf'),
              subtitle: Text('使用flutter开发'),
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('如果你觉得PixEz还不错'),
              subtitle: Text('好评鼓励一下吧！'),
            ),
            Visibility(
              visible: false,
              child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('GitHub Page'),
                  subtitle: Text('https://github.com/Notsfsssf'),
                  onTap: () async {
                    var url = 'https://github.com/Notsfsssf';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {}
                  }),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(I18n.of(context).FeedBack),
              subtitle: SelectableText('PxezFeedBack@outlook.com'),
            ),
            ListTile(
              leading: Icon(Icons.stars),
              title: Text(I18n.of(context).Support),
              subtitle: SelectableText('欢迎反馈建议或共同开发:)'),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(I18n.of(context).Thanks),
              subtitle: Text('感谢帮助我测试的弹幕委员会群友们'),
            ),
            BlocBuilder<IapBloc, IapState>(
                condition: (pre, now) => now is DataIapState,
                builder: (context, snapshot) {
                  return snapshot is DataIapState
                      ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < snapshot.products.length) {
                            var product = snapshot.products[index];
                            print(product);
                            return Card(
                              child: ListTile(
                                subtitle: Text(
                                    snapshot.products[index].description),
                                title: Text(product.title),
                                trailing: Text('${product.localizedPrice}'),
                                onTap: () {
                                  BlocProvider.of<IapBloc>(context)
                                      .add(MakeIapEvent(product));
                                },
                              ),
                            );
                          }
                          var i = index - snapshot.products.length;
                          var item = snapshot.items[i];
                          return Card(
                            child: ListTile(
                              title: Text(item.productId),
                              onTap: () async {},
                            ),
                          );
                        },
                        itemCount: snapshot.products.length +
                            snapshot.items.length,
                      )
                      : Container();
                })
          ],
        );
      }),
    );
  }
}