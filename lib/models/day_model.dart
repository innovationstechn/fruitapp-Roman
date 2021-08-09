import 'package:flutter/foundation.dart';

class DayModel extends ChangeNotifier {
  // The datetime that the current page is on.
  DateTime currentDate = DateTime.now();

  // Flutter has no "infinite" PageView. A workaround is using a ridiculously
  // large initial index for starting page of PageView, so that an infinite
  // scrolling effect is achieved
  final int startingIndex = (.161251195141521521142025 * 1e6).round();

  // The page the user has scrolled to in PageView.
  int currentIndex = (.161251195141521521142025 * 1e6).round();

  // If a page is changed, then the current index needs to be updated.
  void pageChanged(int newIndex) {
    // Now, the current index needs to be updated, along with currentdate.
    // So it is important to know if we have gone forwards or backwards.

    // If the diffrernce of indexes is postive we have gone forward, and vice
    // versa
    if (newIndex - currentIndex > 0)
      next();
    else if (newIndex - currentIndex < 0) previous();

    // And of course, we must notify our listeners that something has changed.
    notifyListeners();
  }

  ////// These two functions just move the current date and index variables
  // by 1 backward and forward.
  void next() {
    currentDate = currentDate.add(new Duration(days: 1));
    currentIndex++;
  }

  void previous() {
    currentDate = currentDate.subtract(new Duration(days: 1));
    currentIndex--;
  }

  // Setting an entirely new date with difference that is not necessarily 1
  // is a different matter.
  void setNewDate(DateTime newDate) {
    // The difference is first calculated.
    final int difference = currentDate.difference(newDate).inDays;

    // And the our indexes are updated.
    currentIndex -= difference;
    currentDate = newDate;

    notifyListeners();
  }
}
