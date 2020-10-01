/**
 * 媒体对象
 */
class MediumVO {
  String id;
  String icon;
  MediumEnum type;

  MediumVO(this.id, this.icon, this.type);
}

enum MediumEnum {
  VIDEO, PHOTO
}