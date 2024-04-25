class Usermodel {
  String email;
  String username;
  String image;
  List following;
  List followers;
  Usermodel(this.email, this.followers, this.following, this.image,
      this.username);
}