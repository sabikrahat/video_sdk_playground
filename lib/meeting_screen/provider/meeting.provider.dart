import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_sdk_playground/constant/constant.dart';
import 'package:video_sdk_playground/constant/get.platform.dart';
import 'package:videosdk/videosdk.dart';

typedef MeetingNotifier
    = AutoDisposeAsyncNotifierProviderFamily<MeetingProvider, Room, String>;

final meetingProvider = MeetingNotifier(MeetingProvider.new);

class MeetingProvider extends AutoDisposeFamilyAsyncNotifier<Room, String> {
  late Room _room;
  bool micEnabled = false;
  bool camEnabled = false;
  bool screenShareEnabled = false;
  Map<String, Participant> participants = {};

  @override
  FutureOr<Room> build(String arg) async {
    _room = VideoSDK.createRoom(
      roomId: arg,
      token: token,
      displayName: "John Doe",
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: pt.isNotMobile ? 0 : 1,
      maxResolution: 'hd',
    );
    //
    setMeetingEventListener();
    //
    _room.join();
    //
    return _room;
  }

  Room get room => _room;

  toggleMic() {
    micEnabled ? _room.unmuteMic() : _room.muteMic();
    micEnabled = !micEnabled;
    ref.notifyListeners();
  }

  toggleCam() {
    camEnabled ? _room.disableCam() : _room.enableCam();
    camEnabled = !camEnabled;
    ref.notifyListeners();
  }

  toggleScreenShare() {
    screenShareEnabled ? _room.disableScreenShare() : _room.enableScreenShare();
    screenShareEnabled = !screenShareEnabled;
    ref.notifyListeners();
  }

  // changeCam() {
  //   currCamIdx = (currCamIdx + 1) % cameras.length;
  //   _room.changeCam(cameras[currCamIdx].deviceId);
  //   ref.notifyListeners();
  // }

  // listening to meeting events
  void setMeetingEventListener() {
    //
    _room.on(Events.roomJoined, () {
      participants.putIfAbsent(
          _room.localParticipant.id, () => _room.localParticipant);
      ref.notifyListeners();
    });

    _room.on(Events.participantJoined, (Participant p) {
      participants.putIfAbsent(p.id, () => p);
      ref.notifyListeners();
    });

    _room.on(Events.participantLeft, (String p) {
      if (participants.containsKey(p)) {
        participants.remove(p);
        ref.notifyListeners();
      }
    });

    _room.on(Events.roomLeft, () => participants.clear());
  }
}
