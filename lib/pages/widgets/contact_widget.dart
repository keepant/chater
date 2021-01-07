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
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                NetworkImage('https://ui-avatars.com/api/?size=128&name=$img'),
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
                  SizedBox(height: 5.0),
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
