import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/comment_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/comment.dart';
import 'package:wordpress_app/models/jwt_status.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/auth_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/colors.dart';
import 'package:wordpress_app/utils/dialog.dart';
import 'package:wordpress_app/utils/empty_icon.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:html/parser.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/widgets/full_image.dart';
import 'package:wordpress_app/widgets/html_body.dart';

class CommentsPage extends StatefulWidget {
  final int categoryId;
  final int? postId;
  const CommentsPage({Key? key, required this.postId, required this.categoryId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var textFieldCtrl = TextEditingController();
  Future? _fetchComments;
  bool _isSomethingChanging = false;

  Future _handlePostComment(int? id) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    FocusScope.of(context).requestFocus(new FocusNode());
    if (textFieldCtrl.text.isEmpty) {
      openSnacbar(scaffoldKey, "Comment shouldn't be empty!");
    } else {
      AppService().checkInternet().then((hasInternet) async {
        if (hasInternet!) {
          setState(() => _isSomethingChanging = true);
          await TenwanService()
              .postComment(id, ub.name, ub.email!, textFieldCtrl.text)
              .then((bool isSuccesfull) {
            if (isSuccesfull) {
              textFieldCtrl.clear();
              setState(() => _isSomethingChanging = false);
              openDialog(context, 'comment success title'.tr(),
                  'comment success description'.tr());
            } else {
              setState(() => _isSomethingChanging = false);
              openDialog(context, 'Comment posting error!', 'Please try again');
            }
          });
        }
      });
    }
  }

  Future _handleDeleteComment(int? id, String? commentUser) async {
    final userName = context.read<UserBloc>().name;
    if (userName == commentUser) {
      AppService().checkInternet().then((hasInternet) {
        if (!hasInternet!) {
          openSnacbar(scaffoldKey, 'no internet'.tr());
        } else {
          setState(() => _isSomethingChanging = true);
          AuthService().customAuthenticationViaJWT().then((JwtStatus? status) {
            if (status!.isSuccessfull == false) {
              setState(() => _isSomethingChanging = false);
              openSnacbar(scaffoldKey, 'Failed to authenticate the user');
            } else {
              TenwanService()
                  .deleteCommentById(status.urlHeader, id)
                  .then((value) {
                if (value) {
                  setState(() => _isSomethingChanging = false);
                  _onRefresh();
                } else {
                  setState(() => _isSomethingChanging = false);
                  openSnacbar(scaffoldKey, 'Error on deleteing the comment');
                }
              });
            }
          });
        }
      });
    } else {
      openSnacbar(scaffoldKey, "you can't delete others comment".tr());
    }
  }

  Future _handleUpdateComment(
      int? id, String? commentUser, String newComment) async {
    await AppService().checkInternet().then((hasInternet) async {
      if (!hasInternet!) {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      } else {
        setState(() => _isSomethingChanging = true);
        await AuthService()
            .customAuthenticationViaJWT()
            .then((JwtStatus? status) async {
          if (status!.isSuccessfull == false) {
            setState(() => _isSomethingChanging = false);
            openSnacbar(scaffoldKey, 'Failed to authenticate the user');
          } else {
            await TenwanService()
                .updateCommentById(status.urlHeader, id, newComment)
                .then((value) {
              if (value) {
                setState(() => _isSomethingChanging = false);
                _onRefresh();
              } else {
                setState(() => _isSomethingChanging = false);
                openSnacbar(scaffoldKey, 'Error on deleteing the comment');
              }
            });
          }
        });
      }
    });
  }

  void openUpdateCommentDialog(String? oldComment, int? id, String? commentUser) {
    final userName = context.read<UserBloc>().name;
    if (userName == commentUser) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            var _textfieldCtrl = TextEditingController();
            _textfieldCtrl.text =
                HtmlUnescape().convert(parse(oldComment).documentElement!.text);
            return AlertDialog(
              scrollable: false,
              contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _textfieldCtrl,
                      maxLines: 6,
                    )
                  ]),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('update').tr(),
                  onPressed: () async {
                    _handleUpdateComment(id, commentUser, _textfieldCtrl.text);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      openSnacbar(scaffoldKey, "you can't edit others comment".tr());
    }
  }

  @override
  void initState() {
    Future.microtask(() => context.read<CommentsBloc>().getFlagList());
    _fetchComments = TenwanService().fetchCommentsById(widget.postId);
    super.initState();
  }

  _onRefresh() async {
    setState(() {
      _fetchComments = TenwanService().fetchCommentsById(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder(
                    future: _fetchComments,
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return _LoadingWidget();
                        case ConnectionState.done:
                        default:
                          if (snapshot.hasError || snapshot.data == null) {
                            return EmptyPageWithIcon(
                              icon: Icons.error,
                              title: 'Error on getting data',
                            );
                          } else if (snapshot.data.isEmpty) {
                            return EmptyPageWithImage(
                              image: Config.commentImage,
                              title: 'no comments found'.tr(),
                              description: 'be the first to comment'.tr(),
                            );
                          }

                          return _buildCommentList(snapshot.data);
                      }
                    }),
              ),
              /*Material(
                elevation: 5,
                child: _bottomWidget(context),
              )*/
            ],
          ),
          !_isSomethingChanging
              ? Container()
              : Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  Widget _bottomWidget(BuildContext context) {
    if (context.watch<UserBloc>().isSignedIn == false)
      return SafeArea(
        bottom: true,
        top: false,
        child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: Row(
            children: [
              SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    height: 35,
                    width: MediaQuery.of(context).size.width - 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.logIn,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'login to write comments',
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                letterSpacing: -0.7,
                                wordSpacing: 1,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),

                  //onTap: ()=> nextScreen(context, SearchPage()),
                  onTap: () => nextScreen(
                      context, LoginPage(popUpScreen: true,)),
                ),
              ),
            ],
          ),
        ),
      );
    else
      return SafeArea(
        bottom: true,
        top: false,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 1),
                        contentPadding: EdgeInsets.only(left: 15, right: 10),
                        border: InputBorder.none,
                        hintText: 'write a comment'.tr(),
                      ),
                      controller: textFieldCtrl,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(right: 10),
                icon: Icon(
                  LucideIcons.arrowUpCircle,
                  size: 25,
                  color: Config().appThemeColor,
                ),
                onPressed: () => _handlePostComment(widget.postId),
              )
            ],
          ),
        ),
      );
  }

  Widget _buildCommentList(snap) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      itemCount: snap.length,
      physics: AlwaysScrollableScrollPhysics(),
      separatorBuilder: (ctx, idx) => Divider(
        color: Theme.of(context).dividerColor,
        thickness: 1.5,
        height: 20,
      ),
      itemBuilder: (BuildContext context, int index) {
        CommentModel d = snap[index];
        return InkWell(
          child: Container(
              child: Row(
                children: <Widget>[
                  /*Container(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: CachedNetworkImageProvider(d.avatar!)),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),*/
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          /*margin: EdgeInsets.only(
                          left: 8, top: 10, right: 5, bottom: 0),*/
                          /*padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),*/
                          /*decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(8)),*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /*CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                      article.avatar!),
                                ),*/
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover, image: CachedNetworkImageProvider(
                                          d.avatar!)),
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              d.author!,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              d.date!,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),

                              Html(
                                  data: d.content,
                                  tagsList: Html.tags..remove('video'),
                                  onLinkTap: (String? url,RenderContext context1, Map<String, String> attributes,_) {
                                    AppService().openLinkWithBrowserMiniProgram(context, url!);
                                  },
                                  onImageTap: (String? url, RenderContext context1, Map<String, String> attributes, _) {
                                    nextScreen(context, FullScreenImage(imageUrl: url!));
                                  },

                                  style: {
                                    "body": Style(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                      fontSize: FontSize(15.0),
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    "figure": Style(
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero),

                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  PopupMenuButton<dynamic> _menuPopUp(CommentModel d) {
    return PopupMenuButton(
        padding: EdgeInsets.all(0),
        child: Icon(
          CupertinoIcons.ellipsis,
          size: 18,
        ),
        itemBuilder: (BuildContext context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              child: Text('update comment').tr(),
              value: 'update',
            ),
            

            _isCommentFlagged(d.id)
            ? PopupMenuItem(
              child: Text('unflag comment').tr(),
              value: 'unflag',
            )
            : PopupMenuItem(
              child: Text('flag comment').tr(),
              value: 'flag',
            ),
            
            PopupMenuItem(
              child: Text('delete').tr(),
              value: 'delete',
            ),
            PopupMenuItem(
              child: Text('report').tr(),
              value: 'report',
            )
          ];
        },
        onSelected: (dynamic value) async{
          if (value == 'update') {
            openUpdateCommentDialog(d.content, d.id, d.author);
          }else if (value == 'flag') {
            await context.read<CommentsBloc>().addToFlagList(context, widget.categoryId, widget.postId!, d.id!);
            _onRefresh();
          }else if (value == 'unflag') {
            await context.read<CommentsBloc>().removeFromFlagList(context, widget.categoryId, widget.postId!, d.id!);
            _onRefresh();
          }else if (value == 'report') {
            //fake report
            openDialog(context, 'report-info'.tr(), '');
          }else {
            _handleDeleteComment(d.id, d.author);
          }
        });
  }


  bool _isCommentFlagged (int? commentId){
    final cb = context.read<CommentsBloc>();
    final flagId = "${widget.categoryId}-${widget.postId}-$commentId";
    if(cb.flagList.contains(flagId)){
      return true;
    }else{
      return false;
    }
  }

  Color? _getRandomColor() {
    return (ColorList().randomColors..shuffle()).first;
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(15),
      itemCount: 12,
      separatorBuilder: (ctx, idx) => SizedBox(
        height: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10, right: 5),
                    child: LoadingCard(
                      height: 90,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
