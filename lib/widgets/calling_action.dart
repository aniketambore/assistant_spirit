import 'package:flutter/material.dart';

class CallingAction extends StatefulWidget {
  final bool isBot;
  final bool isHuman;
  final String url;
  final String name;
  final bool isVoiceCall;
  CallingAction(
      {this.isBot, this.isHuman, this.url, this.name, this.isVoiceCall});

  @override
  _CallingActionState createState() => _CallingActionState();
}

class _CallingActionState extends State<CallingAction>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black54, Colors.blueGrey],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight)),
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.isVoiceCall ? 'VOICE CALL' : 'VIDEO CALL',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '${widget.name}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Calling...",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              ScaleTransition(
                scale: Tween(begin: 0.75, end: 1.0).animate(CurvedAnimation(
                    parent: _controller, curve: Curves.elasticOut)),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          offset: Offset(0, 2),
                          blurRadius: 5)
                    ],
                  ),
                  child: widget.isBot == true
                      ? CircleAvatar(
                          backgroundImage: AssetImage("${widget.url}"))
                      : CircleAvatar(
                          backgroundImage: NetworkImage("${widget.url}"),
                        ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FunctionalButton(
                    title: 'Speaker',
                    icon: Icons.phone_in_talk,
                    onPressed: () {},
                  ),
                  FunctionalButton(
                    title: 'Video Call',
                    icon: Icons.videocam,
                    onPressed: () {},
                  ),
                  FunctionalButton(
                    title: 'Mute',
                    icon: Icons.mic_off,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                elevation: 20.0,
                shape: CircleBorder(side: BorderSide(color: Colors.red)),
                mini: false,
                child: Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
                backgroundColor: Colors.red[100],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FunctionalButton extends StatefulWidget {
  final title;
  final icon;
  final Function() onPressed;

  const FunctionalButton({Key key, this.title, this.icon, this.onPressed})
      : super(key: key);

  @override
  _FunctionalButtonState createState() => _FunctionalButtonState();
}

class _FunctionalButtonState extends State<FunctionalButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RawMaterialButton(
          onPressed: widget.onPressed,
          splashColor: Theme.of(context).accentColor,
          fillColor: Colors.black26,
          elevation: 10.0,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              widget.icon,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 15.0, color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
