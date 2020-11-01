class UserVO {
  static final String LOGIN_KEY = "userInfo";
  String id;
  String nickName; // 昵称
  String name; // 真是姓名
  String icon; // 头像图标，最终使用base64编码图片数据
  String phone; // 电话号码
  String identityCard; // 身份证号
  String email; // 邮箱
  String vip;

  UserVO(this.id, this.nickName, this.name, this.icon, this.phone,
      this.identityCard, this.email, this.vip);
}