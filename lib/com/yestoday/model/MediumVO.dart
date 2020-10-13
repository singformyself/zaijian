/**
 * 媒体对象
 */
class MediumVO {
  String id;
  String title;
  String icon;
  MediumEnum type;
  String date;
  MediumVO.short(this.id, this.icon, this.type);

  MediumVO(this.id, this.title, this.icon, this.type, this.date);
}

enum MediumEnum {
  VIDEO, PHOTO
}