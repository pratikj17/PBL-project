import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCall extends StatefulWidget {
  String channelName;

  @override
  VideoCall({required this.channelName});
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late AgoraClient client;
  /*final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "d587bd2c7f8b4bf494c38b6a2239dd56",  // Replace with your actual App ID
      tempToken: "007eJxTYHhdmSH5rUD4Vql3mJ+cldrRh2d+lgRsmT6jJu5M094U8+cKDCmmFuZJKUbJ5mkWSSZJaSaWJsnGFklmiUZGxpYpKaZmQtZSaQ2BjAzzl7ewMDJAIIjPwlCSWlzCwAAAhFUf3A==",
      channelName: "test",
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );*/

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "d587bd2c7f8b4bf494c38b6a2239dd56",  // Replace with your actual App ID
        tempToken: "007eJxTYPjxr4dl48X47orl19uaFmx8dlWxgC1x2VW9pAmvr2yb8vSgAkOKqYV5UopRsnmaRZJJUpqJpUmysUWSWaKRkbFlSoqp2ek/smkNgYwMWxTsWBkZIBDEZ2EoSS0uYWAAAIinI00=",
        channelName: widget.channelName,
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
