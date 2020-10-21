/**
 * 媒体对象
 */
class MediumVO {
  String id;
  String title;
  String icon;
  String url;
  double width;
  double height;
  MediumEnum type;
  String creatorIcon;
  String creator;
  String date;
  List<String> photos;

  MediumVO(this.id, this.title, this.icon, this.url, this.width,this.height, this.type,this.creatorIcon,this.creator, this.date,this.photos);
}

enum MediumEnum {
  VIDEO, PHOTO
}