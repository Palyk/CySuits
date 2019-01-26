import 'dart:html';

class ToolbarElement {
  ImageElement homeIcon;
  ImageElement loginIcon;
  ImageElement chatIcon;
  ImageElement rulesIcon;
  DivElement parent;

  ToolbarElement(DivElement parent) {
    this.parent = parent;
    homeIcon = new ImageElement();
    loginIcon = new ImageElement();
    chatIcon = new ImageElement();
    rulesIcon = new ImageElement();

    homeIcon..setAttribute('src', '../resources/icons/home.png')
            ..setAttribute('id', 'home')
            ..setAttribute('class', 'tButton');
    loginIcon..setAttribute('src', '../resources/icons/login.png')
             ..setAttribute('id','login')
             ..setAttribute('class', 'tButton');
    chatIcon..setAttribute('src', '../resources/icons/chat.png')
            ..setAttribute('id', 'chat')
            ..setAttribute('class', 'tButton');
    rulesIcon..setAttribute('src', '../resources/icons/rules.png')
             ..setAttribute('id', 'rules')
             ..setAttribute('class', 'tButton');

    loginIcon.setAttribute('href', 'null');

    parent.children..add(homeIcon)
                   ..add(loginIcon)
                   ..add(chatIcon)
                   ..add(rulesIcon);
  }

  void render(){

  }
}