import 'asset_types.dart';

class WalkthroughItem {
  String title;
  String description;
  AssetType assetType;
  String asset;
  String directory = "";
  WalkthroughItem( this.title, this.description, this.assetType, this.asset );
  WalkthroughItem.name( {this.title="dummy_title", this.description = "dummy_text",
    this.assetType = AssetType.IMAGE, this.asset= "img/placeholder.jpg" });
  WalkthroughItem.local( this.title, this.description, this.assetType, this.directory, this.asset );
}
