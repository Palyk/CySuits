import 'dart:html';
import '../Controller/EntityManager.dart';
import '../Controller/Logic/UILogic.dart';
//import '../Controller/Logic/BlackJackLogic.dart';
import '../Controller/Renderer.dart';
import 'dart:async';
import '../Controller/Logic/SolitaireLogic.dart';

UILogic ui;
DivElement parent;
HeadingElement debug;
EntityManager manager;
Renderer r;

void main() {
  parent = querySelector("#main");
  debug = new HeadingElement.h1();
  parent.children.add(debug);
  manager = new EntityManager();
  r = new Renderer(parent);
  ui = new UILogic(r, manager);
  const oneSec = const Duration(milliseconds: 5);
  new Timer.periodic(oneSec, runLogic);
}

void runLogic(Timer t) {
  manager.run();
  ui.run();

  // 1 corresponds to Black Jack

  if (manager.gameState.gameType == 1) {
    /*BlackJackLogic blackJackLogic = new BlackJackLogic(manager, r);
    blackJackLogic.run();
    blackJackLogic = null;*/
  }
  if (manager.playing_solitaire == 1) {
    SolitaireLogic s = new SolitaireLogic(manager,r);
    s.run();
    s = null;
  }

  //debug.text = "Flush stats(user chat gamestate):"+manager.flush_user.toString()+manager.flush_chat.toString()+manager.flush_gameState.toString();
  r.render();
}
