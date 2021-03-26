import 'package:flutter/material.dart';

import '../../core/models/comment.dart';
import '../../core/view-models/base_model.dart';
import '../../core/view-models/comments_model.dart';
import '../../ui/shared/app_colors.dart';
import '../../ui/shared/ui_helpers.dart';
import '../views/base_view.dart';

class Comments extends StatelessWidget {
  final int postId;
  Comments(this.postId);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('I am comments '));
  }
}

/// Renders a single comment given a comment model
class CommentItem extends StatelessWidget {
  final Comment comment;
  const CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return BaseView<CommentsModel>(
      builder: (context, model, child) => model.state == ViewState.Idle
          ? Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: commentColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comment.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  Text(comment.body),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
