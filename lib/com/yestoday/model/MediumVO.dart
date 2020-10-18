/**
 * 媒体对象
 */
class MediumVO {
  String id;
  String title;
  String icon;
  String url;
  double aspectRatio; // 媒体比例
  MediumEnum type;
  String creatorIcon;
  String creator;
  String date;

  MediumVO(this.id, this.title, this.icon, this.url, this.aspectRatio, this.type,this.creatorIcon,this.creator, this.date);
}

enum MediumEnum {
  VIDEO, PHOTO
}