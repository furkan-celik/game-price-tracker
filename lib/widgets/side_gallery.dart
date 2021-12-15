import 'package:flutter/material.dart';

class SideGallery extends StatefulWidget {
  final List<String> imageList;
  int idx = 0;

  SideGallery(this.imageList, {this.idx = 0, Key? key}) : super(key: key);

  @override
  _SideGalleryState createState() => _SideGalleryState();
}

class _SideGalleryState extends State<SideGallery>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (child, anim) => SizeTransition(
              sizeFactor: anim,
              child: child,
              axis: Axis.horizontal,
            ),
            child: Center(
              child: Image.network(
                widget.imageList[widget.idx],
                key: ValueKey(widget.idx),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                color: Colors.black26,
                width: 50,
                child: Material(
                  color: Colors.black26,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 40,
                    icon: const Icon(
                      Icons.arrow_left_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.idx = (widget.idx - 1) % widget.imageList.length;
                      });
                    },
                  ),
                )),
            Container(
              color: Colors.black26,
              width: 50,
              child: Material(
                color: Colors.black26,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 40,
                  icon: const Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.idx = (widget.idx + 1) % widget.imageList.length;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
