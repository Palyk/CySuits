import 'dart:html';
import '../Views/MessageElement.dart';

class ChatBoxElement {
  DivElement parent;
  DivElement messageWindow;
  InputElement inputMessage;
  ButtonElement submitMessage;
  List<MessageElement> messageElementList;
  List<DivElement> messageElementDivList;

  ChatBoxElement(DivElement parent) {
    this.parent = parent;

    messageWindow = new DivElement();
    inputMessage = new InputElement();
    submitMessage = new ButtonElement();

    messageWindow.setAttribute('id','messageWindow');
    inputMessage.setAttribute('id','inputMessage');
    inputMessage.setAttribute('placeholder','Enter message here...');
    submitMessage.text= 'Send';
    submitMessage.setAttribute('id', 'submitMessage');

    parent.children.add(messageWindow);
    parent.children.add(inputMessage);
    parent.children.add(submitMessage);
    messageElementList = [];
    messageElementDivList = [];
  }
  void render() {
    messageElementList.forEach((curr){
      curr.render();
    });

  }
}