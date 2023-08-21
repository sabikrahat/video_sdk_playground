import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_sdk_playground/meeting_screen/provider/meeting.provider.dart';
import 'package:video_sdk_playground/participant_title.dart';

class MeetingScreen extends ConsumerWidget {
  const MeetingScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(meetingProvider(meetingId));
    final notifier = ref.watch(meetingProvider(meetingId).notifier);
    return WillPopScope(
      onWillPop: () async {
        notifier.room.leave();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VideoSDK QuickStart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(meetingId, style: const TextStyle(fontSize: 20.0)),
              //render all participant
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return ParticipantTile(
                          key: Key(
                              notifier.participants.values.elementAt(index).id),
                          participant:
                              notifier.participants.values.elementAt(index));
                    },
                    itemCount: notifier.participants.length,
                  ),
                ),
              ),
              _Controllers(meetingId),
            ],
          ),
        ),
      ),
      // home: JoinScreen(),
    );
  }
}

class _Controllers extends ConsumerWidget {
  const _Controllers(this.meetingId);

  final String meetingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(meetingProvider(meetingId));
    final notifier = ref.watch(meetingProvider(meetingId).notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: notifier.toggleMic,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: notifier.micEnabled ? Colors.transparent : Colors.red,
                border: Border.all(color: Colors.white, width: 0.7),
              ),
              child: Icon(
                notifier.micEnabled
                    ? Icons.mic_none_outlined
                    : Icons.mic_off_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: notifier.toggleCam,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: notifier.camEnabled ? Colors.transparent : Colors.red,
                border: Border.all(color: Colors.white, width: 0.7),
              ),
              child: Icon(
                notifier.camEnabled
                    ? Icons.videocam_outlined
                    : Icons.videocam_off_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          // ifß
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: notifier.toggleScreenShare,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: notifier.screenShareEnabled
                    ? Colors.transparent
                    : Colors.red,
                border: Border.all(color: Colors.white, width: 0.7),
              ),
              child: Icon(
                notifier.screenShareEnabled
                    ? Icons.screen_share_outlined
                    : Icons.stop_screen_share_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              notifier.room.leave();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                border: Border.all(color: Colors.white, width: 0.7),
              ),
              child: const Icon(
                Icons.call_end_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Copy button
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: meetingId))
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                  ),
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 0.7),
              ),
              child: const Icon(
                Icons.copy_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
