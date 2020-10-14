/**
 * 媒体对象
 */
class MediumVO {
  String id;
  String title;
  String icon;
  MediumEnum type;
  String creatorIcon;
  String creator;
  String date;
  MediumVO.short(this.id, this.icon, this.type);


  MediumVO(this.id, this.title, this.icon, this.type,this.creatorIcon,this.creator, this.date);
}

enum MediumEnum {
  VIDEO, PHOTO
}