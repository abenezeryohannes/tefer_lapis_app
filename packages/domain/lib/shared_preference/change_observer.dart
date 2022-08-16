import 'change_subscriber.dart';

class ChangeObserver {
  List<ChangeSubscriber> subs = [];

  void addSubs(ChangeSubscriber sub) {
    removeSub(sub);
    subs.add(sub);
  }

  void onChange() {
    for (var f in subs) {
      f.onDataChange();
    }
  }

  void removeSub(ChangeSubscriber sub) {
    subs.removeWhere((test) {
      return test == sub;
    });
  }
}
