import 'dart:html';
import '../Views/ChatBoxElement.dart';
import '../Views/SolitaireElement.dart';
import '../Views/LoginElement.dart';
import '../Views/ChatBoxElement.dart';
import '../Views/RulesElement.dart';
import '../Views/ToolbarElement.dart';
import '../Views/BannerElement.dart';
import '../Views/LobbyElement.dart';
import '../Views/HomeElement.dart';
import '../Views/NiElement.dart';
import '../Views/BlackJackElement.dart';


class Renderer {
  DivElement parent;

  DivElement bannerElementDiv;
  BannerElement bannerElement;

  DivElement toolbarElementDiv;
  ToolbarElement toolbarElement;

  DivElement loginElementDiv;
  LoginElement loginElement;

  DivElement lobbyElementDiv;
  LobbyElement lobbyElement;

  DivElement solitaireElementDiv;
  SolitaireElement solitaireElement;

  DivElement chatBoxElementDiv;
  ChatBoxElement chatBoxElement;

  DivElement niElementDiv;
  NiElement niElement;

  DivElement homeElementDiv;
  HomeElement homeElement;

  DivElement rulesElementDiv;
  RulesElement rulesElement;

  DivElement blackJackElementDiv;
  BlackJackElement blackJackElement;

  Renderer(DivElement parent){

    this.parent = parent;

    bannerElementDiv = new DivElement();
    bannerElementDiv
      ..setAttribute('id', 'banner')
      ..setAttribute('class', 'banner_div');
    bannerElement = new BannerElement(bannerElementDiv);

    toolbarElementDiv = new DivElement();
    toolbarElementDiv
      ..setAttribute('id', 'toolbar')
      ..setAttribute('class', 'toolbar_div');
    toolbarElement = new ToolbarElement(toolbarElementDiv);

    loginElementDiv = new DivElement();
    loginElementDiv
      ..setAttribute('id', 'menu') //for now
      ..setAttribute('class', 'login_div');
    loginElement = new LoginElement(loginElementDiv);

    lobbyElementDiv = new DivElement();
    lobbyElementDiv
      ..setAttribute('id','lobby')
      ..setAttribute('class','lobby_div');
    lobbyElement = new LobbyElement(lobbyElementDiv);

    parent.children.add(lobbyElementDiv);
    parent.children.add(loginElementDiv);
    parent.children.add(bannerElementDiv);
    parent.children.add(toolbarElementDiv);


      //this.parent.children.add(loginElementDiv);
        //this.parent.children.add(bannerElementDiv);
       // this.parent.children.add(toolbarElementDiv);


  }

  render() {
    if (solitaireElement != null) {
      solitaireElement.render();
    }
    if (loginElement != null) {
      loginElement.render();
    }

    if(homeElement != null) {
      homeElement.render();
    }
    if(toolbarElement != null){

      toolbarElement.render();
    }
    if (lobbyElement != null) {
      lobbyElement.render();
    }
    if(niElement != null) {
      niElement.render();
    }
    if(chatBoxElement != null) {
      chatBoxElement.render();
    }
    if(blackJackElement != null) {
      blackJackElement.render();
    }
  }
}
