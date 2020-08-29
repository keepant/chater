import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final String img;
  final String title;
  final String detail;
  final GestureTapCallback onTap;
  final bool isDivider;

  ContactWidget({
    Key key,
    @required this.img,
    @required this.title,
    @required this.onTap,
    this.detail,
    this.isDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(img),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    detail ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  isDivider ? Divider() : Container,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
