import 'dart:html';

class MessageElement{

  DivElement parent;
  DivElement messageBox;
  String username;
  String text;
  String time;


  MessageElement(DivElement parent) {
    this.parent = parent;
    messageBox = new DivElement();
    messageBox.setAttribute('id','message');
    parent.children.add(messageBox);
  }

  render(){
    parent.text = '${username}: ${text} (${time})';
  }
}