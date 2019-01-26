import 'dart:html';

class RoomElement {

  DivElement parent;
  DivElement roomData;
  ButtonElement roomSelect;
  List<String> users;
  int id;
  int gameType;

  RoomElement(DivElement parent) {
    this.parent = parent;
    roomData = new DivElement();
    roomSelect = new ButtonElement();
    roomSelect.text = "Join Room";
    roomSelect.setAttribute('class', 'RoomButton');
    users = [];
    this.parent.children.add(roomSelect);
    this.parent.children.add(roomData);

  }
  void render() {
    roomData.text = '${users.length}/4 ${users.join(',')}';

  }
}