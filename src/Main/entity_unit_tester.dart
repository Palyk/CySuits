import 'dart:html';
import '../Controller/EntityManager.dart';

void main() {
  print('hello');
  var em = new EntityManager();
  em.run();

  em.user.userName = 'dkihlken';
  em.user.password = 'password';
  em.flush_user = 1;

  em.run();
  while(em.lobby.blackjackRooms == null){

  }
  print(em.user.id);
  print(em.lobby.blackjackRooms);

  em.gameState.id = em.lobby.blackjackRooms[0].gameStateId;
  em.create_player = 1;

  em.run();
  print(em.gameState.gameType);


}
