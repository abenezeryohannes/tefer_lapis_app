
import 'package:walkthrough/domain/walkthrough_item.dart';

class Config{

  static final List<WalkthroughItem> walkThroughItems = [
      WalkthroughItem.name(asset: 'img/bag.png', title: "walkthrough_title_1", description: "walkthrough_description_1"),
      WalkthroughItem.name(asset: 'img/happy-kid.png', title: "walkthrough_title_2", description: "walkthrough_description_2"),
      WalkthroughItem.name(asset: 'img/bag.png', title: "walkthrough_title_3", description: "walkthrough_description_3"),
  ];

}