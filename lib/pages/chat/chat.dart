import 'package:chater/pages/widgets/loading.dart';
import 'package:chater/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String id;
  final String img;
  final String name;

  ChatPage({
    Key key,
    @required this.id,
    @required this.img,
    @required this.name,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatCtrl = new TextEditingController();
  bool isWriting = false;
  SharedPreferences sharedPreferences;
  String _userId;
  final db = new Database();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = (sharedPreferences.getString("userId") ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    String chatId = _userId.hashCode <= widget.id.hashCode
        ? '$_userId-${widget.id}'
        : '${widget.id}-$_userId';
    return Scaffold(
      backgroundColor: Color(0xFFf2f4fa),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?size=128&name=${widget.img}'),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db.messages
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var document = snapshot.data.documents[index].data();
                      return _bubbleChat(
                        content: document['content'],
                        time: document['createdAt'].toDate(),
                        isRight: document['formId'] == _userId,
                      );
                    },
                  );
                }

                return Loading();
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          _textComposer(),
        ],
      ),
    );
  }

  Widget _bubbleChat({
    String content,
    DateTime time,
    bool isRight = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment:
                isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  content,
                  style:
                      TextStyle(color: isRight ? Colors.black : Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                  color:
                      isRight ? Colors.white : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.only(
                  left: isRight ? 30.0 : 10.0,
                  bottom: 4.0,
                  right: isRight ? 10.0 : 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  DateFormat('dd MMM kk:mm').format(
                    time,
                  ),
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 11.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textComposer() {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _chatCtrl,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type something...",
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              String chatId = _userId.hashCode <= widget.id.hashCode
                  ? '$_userId-${widget.id}'
                  : '${widget.id}-$_userId';
              db.updateChattingWith(
                docId: _userId,
                rivalId: widget.id,
              );
              db.chatting(
                chatId: chatId,
                content: _chatCtrl.text,
                fromId: _userId,
                toId: widget.id,
              );
              setState(() {
                _chatCtrl.text = '';
              });
            },
          ),
        ],
      ),
    );
  }
}
