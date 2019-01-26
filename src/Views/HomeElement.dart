import 'dart:html';

class HomeElement {
  ImageElement profilePic = new ImageElement();
  DivElement welcome = new DivElement();
  DivElement stats = new DivElement();
  int credits;
  String user;
  DivElement parent;

  HomeElement(DivElement parent){
    this.parent = parent;
    credits = 0;
    user = "Null"; //User and credits will be updated in UILogic
    welcome.setAttribute('id', 'homeWelcome');
    stats.setAttribute('id', 'homeStats');
    profilePic.setAttribute('id', 'profile');
    profilePic.setAttribute('src', "../resources/icons/profile.jpg"); //replace with getting pic from server, or just remove later

    stats.text = "Credits: " + credits.toString();
    welcome.text = "Welcome user " + user + "!";
    parent.children.add(welcome);
    parent.children.add(stats);
    parent.children.add(profilePic);
  }
  void render() {
    stats.text = "Credits: " + credits.toString(); //credits updated in UILogic
    welcome.text = "Welcome user " + user + "!";
  }
}