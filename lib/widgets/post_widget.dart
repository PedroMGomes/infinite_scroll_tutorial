import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/post.dart' show Post;
import 'package:flutter_tutorial/providers/posts_provider.dart'
    show PostsProvider;
import 'package:provider/provider.dart';

/// [PostWidget].
class PostWidget extends StatelessWidget {
  const PostWidget({Key key, @required this.post}) : super(key: key);

  final Post post;

  // Separators.
  Widget get _vSpace => const SizedBox(height: 8.0);
  Widget get _hSpace => const SizedBox(width: 8.0);

  Color _color(String keyword) {
    switch (keyword) {
      case 'red':
        return Colors.red.shade300;
      case 'brown':
        return Colors.brown.shade400;
      case 'green':
        return Colors.green.shade200;
      case 'blue':
        return Colors.blue.shade200;
      case 'yellow':
        return Colors.yellow.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  void _save(BuildContext context) {
    final res = context.read<PostsProvider>().toggle(this.post);
    final message = (res) ? 'Post Saved' : 'Post Removed';
    final icon = (res)
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.remove_circle, color: Colors.red);

    // Displays Snackbar.
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(width: 8.0),
          icon,
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0)),
      ),
      duration: const Duration(seconds: 1),
    ));
  }

  /// build.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.blue),
                _hSpace,
                Text(post.user, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _vSpace,
          Image.network(
            this.post.image,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, err, stackTrace) => Container(
              height: 300,
              width: double.infinity,
              color: Colors.blueGrey,
              child: const Center(child: const Text('Failed to load image.')),
            ),
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              // Same as the example provided in the official docs.
              if (wasSynchronouslyLoaded) {
                return child;
              } else {
                return AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
          _vSpace,
          Text(this.post.description),
          _vSpace,
          Chip(
            label: Text(this.post.keyword),
            backgroundColor: _color(this.post.keyword),
          ),
          _vSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.bookmark_border, color: Colors.green),
                  onPressed: () => this._save(context)),
              IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.blue),
                  onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}
