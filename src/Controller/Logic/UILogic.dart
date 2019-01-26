import 'dart:html';
import '../../Views/LobbyElement.dart';
import '../../Views/LoginElement.dart';
import '../../Views/ChatBoxElement.dart';
import '../../Views/HomeElement.dart';
import '../../Views/RulesElement.dart';
import '../../Views/RoomElement.dart';
import '../../Views/BlackJackElement.dart';
import '../EntityManager.dart';
import '../Renderer.dart';
import '../../Entities/Message.dart';
import '../../Views/MessageElement.dart';
import '../../Views/SolitaireElement.dart';
import '../../Views/NiElement.dart';
import '../../Views/CardElement.dart';

class UILogic {
  EntityManager em;
  Renderer r;
  int menuState; //0 = login, 1= home, 2=chat, 3=rules
  int registerState; //0 = login, 1 = register
  int attemptLogin; //0 = no attempt, 1 = attempted
  ButtonElement leaveGame; //This and its onClick will be used in roughly every game implemented so for simplicity it'll instantiate in this class
  int playerId;

  UILogic(Renderer renderer, EntityManager entityManager) {
    r = renderer;
    em = entityManager;
    menuState = 0;
    registerState = 0;
    attemptLogin = 0;
    leaveGame = new ButtonElement();
    leaveGame.text = "Exit game";
    leaveGame.onClick.listen(exitGame);
    playerId = 0;
    r.loginElement.submit.onClick.listen(submit);


    r.toolbarElement
      ..homeIcon.onClick.listen(renderHome)

      ..loginIcon.onClick.listen(renderLogin)
      ..chatIcon.onClick.listen(renderChat)
      ..rulesIcon.onClick.listen(renderRules);
    r.loginElement.register.onClick.listen(setRegister);


    r.lobbyElement.playSolitaire.onClick.listen(playSolitaire);
  }

  void run() {
    //login stuff
    if (r.lobbyElement == null &&
        em.logged_in == 1 &&
        em.playing_solitaire == 0 &&
        em.gameState.id == null) {
      //if not in a game but lobby not rendered when logged in, render lobby
      r.lobbyElementDiv = new DivElement();
      r.lobbyElementDiv..setAttribute('id', 'lobby')..setAttribute(
          'class', 'lobby_div');
      r.lobbyElement = new LobbyElement(r.lobbyElementDiv);

      r.parent.children.add(r.lobbyElementDiv);
    }
    if (r.lobbyElement != null) {
      //if lobby is rendered, update rooms
      showRooms();
    }

    if (em.gameState.id != null && playerId == 0 &&
        em.gameState.players != null) {
      em.gameState.players.forEach((player) {
        if (player.userName == em.user.userName) {
          playerId = player.id;
          return;
        }
      });
    }

    if (em.logged_in == 1 && r.homeElement != null) {
      //if logged in, update user and credits
      r.homeElement.user = em.user.userName;
      r.homeElement.credits = em.user.credits;
    }
    if (attemptLogin == 1 && em.flush_user == 0) {
      attemptLogin = 0;
      if (em.logged_in == 0) {} else {}
    }

    //toolbar stuff

    //chat stuff
    if (r.chatBoxElement != null &&
        r.chatBoxElement.messageElementList.length != em.chat.messages.length) {
      //if chatbox is rendered but not all messages rendered, render new messages
      addNewMessages();
    }
    //print("flush_chat: " + em.flush_chat.toString() + "flush_user: " + em.flush_user.toString() + "flush_gameState: " + em.flush_gameState.toString());
  }

  //Login functions

  void submit(Event e) {
    if (registerState == 0) {
      login();
    } else {
      register();
    }
  }

  void login() {
    if (em.flush_user == 1 ||
        r.loginElement.username.value == '' ||
        r.loginElement.password.value == '' ||
        em.create_user == 1) {
      return;
    }
    em.user.userName = r.loginElement.username.value;
    em.user.password = r.loginElement.password.value;
    em.flush_user = 1;
    attemptLogin = 1;
  }

  void register() {
    if (em.flush_user == 1 ||
        r.loginElement.username.value == '' ||
        r.loginElement.password.value == '') {
      return;
    }
    if (r.loginElement.password.value != r.loginElement.confirmPass.value) {
      r.loginElement.failedRegister = 1;
      return;
    }
    em.user.userName = r.loginElement.username.value;
    em.user.password = r.loginElement.password.value;
    em.create_user = 1;
  }

  void setRegister(Event e) {
    if (registerState == 0) {
      r.parent.children.add(r.loginElement.confirmPass);
      registerState = 1;
    } else {
      r.loginElement.confirmPass.remove();
      registerState = 0;
    }
  }


  //Chat functions
  void sendMessage(Event e) {
    if (em.flush_chat == 1 || r.chatBoxElement.inputMessage.value == '') {
      return;
    }
    Message outMessage = new Message();
    DateTime now = new DateTime.now();

    String hour;
    String minute;
    if (now.hour < 10) {
      hour = "0" + now.hour.toString();
    } else {
      hour = now.hour.toString();
    }
    if (now.minute < 10) {
      minute = "0" + now.minute.toString();
    } else {
      minute = now.minute.toString();
    }
    String formatted = hour + ":" + minute;

    outMessage.username = em.user.userName;
    outMessage.text = r.chatBoxElement.inputMessage.value;
    outMessage.time = formatted;
    em.outbox.add(outMessage);
    em.flush_chat = 1;
    r.chatBoxElement.inputMessage.value = ""; //clear box, remove if not wanted
  }


  void addNewMessages() {
    //assuming no messages are deletable, also assuming that EntityManager will limit messagecount, otherwise edit later to limit messages here
    //if there are more messages than currently rendered (usually the case)
    em.chat.messages.forEach((message) {
      if (em.chat.messages.indexOf(message) <
          r.chatBoxElement.messageElementList.length) {
        //if the index of the message is within the currently rendered range (usually means message already rendered)
        //do nothing, message already added, if em manages rewriting messages uncomment lower section
        r.chatBoxElement.messageElementList[em.chat.messages.indexOf(message)]
          ..username = message.username
          ..text = message.text
          ..time = message.time
          ..render();
      } else {
        //needs to add more to rendered list to display
        r.chatBoxElement.messageElementDivList
            .add(new DivElement()); //create a new div to hold the new message
        r.chatBoxElement.messageWindow.children
            .add(r.chatBoxElement.messageElementDivList.last); //render new div
        r.chatBoxElement.messageElementList.add(new MessageElement(r
            .chatBoxElement
            .messageElementDivList
            .last)); //add new message to div

        r.chatBoxElement.messageElementList.last
          ..username = message.username
          ..text = message.text
          ..time = message.time
          ..render();
      }
    });


    //Note: currently not going to limit number of messages, message list is scrollable so shouldn't be a problem, if it does become a problem then add a section here to limit messages
    //else {
    //
    //}
  }

  //Blackjack functions (can be reused by other games)

  //Lobby functions
  void clickRoom(RoomElement r) {
    joinRoom(r.id, r.gameType);
  }

  void showRooms() {
    //This function should verify the roomlist and display the correct information, should only add what's not already added
    //if nothing is new, roomElements will still be refreshed
    if (em.lobby.blackjackRooms != null && em.lobby.blackjackRooms.length > 0) {
      //null checker, also sees if any rooms even exist
      /*while(r.lobbyElement.roomElementList.length < em.lobby.blackjackRooms.length) {
        r.lobbyElement.roomElementDivList.add(new DivElement());
        r.lobbyElement.blackjackRooms.children.add(r.lobbyElement.roomElementDivList[0]);
        r.lobbyElement.roomElementList.add(new RoomElement(r.lobbyElement.roomElementDivList[0]));
      }

      for(int i=0; i<em.lobby.blackjackRooms.length; ++i) {
        if(r.lobbyElement.roomElementList[i].id == em.lobby.blackjackRooms[i].gameStateId) {

        }
        else {
          r.lobbyElement.roomElementList[i] = null;
          r.lobbyElement.roomElementList[i] = new RoomElement(r.lobbyElement.roomElementDivList[i]);

          r.lobbyElement.roomElementList[i].gameType = 0;
          r.lobbyElement.roomElementList[i].id = em.lobby.blackjackRooms[i].gameStateId;
          r.lobbyElement.roomElementList[i].users = em.lobby.blackjackRooms[i].players;
          r.lobbyElement.roomElementList[i].roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.roomElementList[i]);
          });
        }

      }*/
      for(int i = 0; i<em.lobby.blackjackRooms.length; ++i) {
        if (i >=
            r.lobbyElement.blackjackList.length) {
          //if there are more rooms in the entity manager than has been rendered in last tick

          r.lobbyElement.blackjackDivList
              .add(new DivElement()); //create a new div to hold the new room
          r.lobbyElement.blackjackRooms.children.add(
              r.lobbyElement.blackjackDivList[i]); //render the new div

          r.lobbyElement.blackjackList.add(new RoomElement(
              r.lobbyElement.blackjackDivList[i])); //add the new room

          r.lobbyElement.blackjackList.last.gameType = 0;
          r.lobbyElement.blackjackList.last.id = em.lobby.blackjackRooms[i].gameStateId;
          r.lobbyElement.blackjackList.last.users = em.lobby.blackjackRooms[i].players;

          r.lobbyElement.blackjackList.last.render();
          r.lobbyElement.blackjackList.last.roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.blackjackList[i]);
          });
        } else {
          //a div is already created, we must simply overwrite it
          if (em.lobby.blackjackRooms[i].gameStateId ==
              r.lobbyElement
                  .blackjackList[i].id) {
            r.lobbyElement.blackjackList[i].users = em.lobby.blackjackRooms[i].players; //update player count
            //the room is the same, do not modify the listing as this will make trying to click a button more annoying with it being rewritten every tick
          } else {
            //the room is different, modify listing


            r.lobbyElement.blackjackList[i] =
            new RoomElement(r.lobbyElement.blackjackDivList[
            i]); //add the new room

            r
                .lobbyElement
                .blackjackList[i]
                .gameType = 0;
            r
                .lobbyElement
                .blackjackList[i]
                .id = em.lobby.blackjackRooms[i].gameStateId;
            r
                .lobbyElement
                .blackjackList[i]
                .users = em.lobby.blackjackRooms[i].players;
            r.lobbyElement
                .blackjackList[i]
                .render();
            r.lobbyElement.blackjackList[i].roomSelect.onClick.listen((e) {
              clickRoom(r.lobbyElement.blackjackList[i]);
            });
          }
        }

      }
      if (em.lobby.blackjackRooms.length <
          r.lobbyElement.blackjackList.length) {
        //because of earlier method, there is no reason em should be greater than renderer, and do nothing if equal
        for (int i = em.lobby.blackjackRooms.length;
        i < r.lobbyElement.blackjackList.length;
        ++i) {
          r.lobbyElement.blackjackList.removeAt(
              i); //should start with the first excess index above em's max, then end at the end of the list
          r.lobbyElement.blackjackDivList.removeAt(
              i); //remove the div after removing its contents, div will be added back only if need be
        }
      }
    } else {}

    //Do the same when other game room types are added
    //DIVIDER
    /*if (em.lobby.solitaireRooms != null && em.lobby.solitaireRooms.length > 0) {
      //null checker, also sees if any rooms even exist
      /*while(r.lobbyElement.roomElementList.length < em.lobby.solitaireRooms.length) {
        r.lobbyElement.roomElementDivList.add(new DivElement());
        r.lobbyElement.solitaireRooms.children.add(r.lobbyElement.roomElementDivList[0]);
        r.lobbyElement.roomElementList.add(new RoomElement(r.lobbyElement.roomElementDivList[0]));
      }

      for(int i=0; i<em.lobby.solitaireRooms.length; ++i) {
        if(r.lobbyElement.roomElementList[i].id == em.lobby.solitaireRooms[i].gameStateId) {

        }
        else {
          r.lobbyElement.roomElementList[i] = null;
          r.lobbyElement.roomElementList[i] = new RoomElement(r.lobbyElement.roomElementDivList[i]);

          r.lobbyElement.roomElementList[i].gameType = 0;
          r.lobbyElement.roomElementList[i].id = em.lobby.solitaireRooms[i].gameStateId;
          r.lobbyElement.roomElementList[i].users = em.lobby.solitaireRooms[i].players;
          r.lobbyElement.roomElementList[i].roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.roomElementList[i]);
          });
        }

      }*/
      for(int i = 0; i<em.lobby.solitaireRooms.length; ++i) {
        if (i >=
            r.lobbyElement.solitaireList.length) {
          //if there are more rooms in the entity manager than has been rendered in last tick
          print("more rooms");
          r.lobbyElement.solitaireDivList
              .add(new DivElement()); //create a new div to hold the new room
          r.lobbyElement.solitaireRooms.children.add(
              r.lobbyElement.solitaireDivList[i]); //render the new div
          //print(r.lobbyElement.roomElementDivList[em.lobby.solitaireRooms.indexOf(room)].children);
          r.lobbyElement.solitaireList.add(new RoomElement(
              r.lobbyElement.solitaireDivList[i])); //add the new room

          r.lobbyElement.solitaireList.last.gameType = 1;
          r.lobbyElement.solitaireList.last.id = em.lobby.solitaireRooms[i].gameStateId;
          r.lobbyElement.solitaireList.last.users = em.lobby.solitaireRooms[i].players;

          r.lobbyElement.solitaireList.last.render();
          r.lobbyElement.solitaireList.last.roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.solitaireList[i]);
          });
        } else {
          //a div is already created, we must simply overwrite it
          if (em.lobby.solitaireRooms[i].gameStateId ==
              r.lobbyElement
                  .solitaireList[i].id) {
            r.lobbyElement.solitaireList[i].users = em.lobby.solitaireRooms[i].players; //update player count
            //the room is the same, do not modify the listing as this will make trying to click a button more annoying with it being rewritten every tick
          } else {
            //the room is different, modify listing
            print("listing modify");

            r.lobbyElement.solitaireList[i] =
            new RoomElement(r.lobbyElement.solitaireDivList[
            i]); //add the new room

            r
                .lobbyElement
                .solitaireList[i]
                .gameType = 1;
            r
                .lobbyElement
                .solitaireList[i]
                .id = em.lobby.solitaireRooms[i].gameStateId;
            r
                .lobbyElement
                .solitaireList[i]
                .users = em.lobby.solitaireRooms[i].players;
            r.lobbyElement
                .solitaireList[i]
                .render();
            r.lobbyElement.solitaireList[i].roomSelect.onClick.listen((e) {
              clickRoom(r.lobbyElement.solitaireList[i]);
            });
          }
        }

      }
      if (em.lobby.solitaireRooms.length <
          r.lobbyElement.solitaireList.length) {
        //because of earlier method, there is no reason em should be greater than renderer, and do nothing if equal
        for (int i = em.lobby.solitaireRooms.length;
        i < r.lobbyElement.solitaireList.length;
        ++i) {
          r.lobbyElement.solitaireList.removeAt(
              i); //should start with the first excess index above em's max, then end at the end of the list
          r.lobbyElement.solitaireDivList.removeAt(
              i); //remove the div after removing its contents, div will be added back only if need be
        }
      }
    } else {}*/
    if (em.lobby.niRooms != null && em.lobby.niRooms.length > 0) {
      //null checker, also sees if any rooms even exist
      /*while(r.lobbyElement.roomElementList.length < em.lobby.niRooms.length) {
        r.lobbyElement.roomElementDivList.add(new DivElement());
        r.lobbyElement.niRooms.children.add(r.lobbyElement.roomElementDivList[0]);
        r.lobbyElement.roomElementList.add(new RoomElement(r.lobbyElement.roomElementDivList[0]));
      }

      for(int i=0; i<em.lobby.niRooms.length; ++i) {
        if(r.lobbyElement.roomElementList[i].id == em.lobby.niRooms[i].gameStateId) {

        }
        else {
          r.lobbyElement.roomElementList[i] = null;
          r.lobbyElement.roomElementList[i] = new RoomElement(r.lobbyElement.roomElementDivList[i]);

          r.lobbyElement.roomElementList[i].gameType = 0;
          r.lobbyElement.roomElementList[i].id = em.lobby.niRooms[i].gameStateId;
          r.lobbyElement.roomElementList[i].users = em.lobby.niRooms[i].players;
          r.lobbyElement.roomElementList[i].roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.roomElementList[i]);
          });
        }

      }*/
      for(int i = 0; i<em.lobby.niRooms.length; ++i) {
        if (i >=
            r.lobbyElement.niList.length) {
          //if there are more rooms in the entity manager than has been rendered in last tick
          print("more rooms");
          r.lobbyElement.niDivList
              .add(new DivElement()); //create a new div to hold the new room
          r.lobbyElement.niRooms.children.add(
              r.lobbyElement.niDivList[i]); //render the new div
          //print(r.lobbyElement.roomElementDivList[em.lobby.niRooms.indexOf(room)].children);
          r.lobbyElement.niList.add(new RoomElement(
              r.lobbyElement.niDivList[i])); //add the new room

          r.lobbyElement.niList.last.gameType = 5;
          r.lobbyElement.niList.last.id = em.lobby.niRooms[i].gameStateId;
          r.lobbyElement.niList.last.users = em.lobby.niRooms[i].players;

          r.lobbyElement.niList.last.render();
          r.lobbyElement.niList.last.roomSelect.onClick.listen((e) {
            clickRoom(r.lobbyElement.niList[i]);
          });
        } else {
          //a div is already created, we must simply overwrite it
          if (em.lobby.niRooms[i].gameStateId ==
              r.lobbyElement
                  .niList[i].id) {
            r.lobbyElement.niList[i].users = em.lobby.niRooms[i].players; //update player count
            //the room is the same, do not modify the listing as this will make trying to click a button more annoying with it being rewritten every tick
          } else {
            //the room is different, modify listing
            print("listing modify");

            r.lobbyElement.niList[i] =
            new RoomElement(r.lobbyElement.niDivList[
            i]); //add the new room

            r
                .lobbyElement
                .niList[i]
                .gameType = 5;
            r
                .lobbyElement
                .niList[i]
                .id = em.lobby.niRooms[i].gameStateId;
            r
                .lobbyElement
                .niList[i]
                .users = em.lobby.niRooms[i].players;
            r.lobbyElement
                .niList[i]
                .render();
            r.lobbyElement.niList[i].roomSelect.onClick.listen((e) {
              clickRoom(r.lobbyElement.niList[i]);
            });
          }
        }

      }
      if (em.lobby.niRooms.length <
          r.lobbyElement.niList.length) {
        //because of earlier method, there is no reason em should be greater than renderer, and do nothing if equal
        for (int i = em.lobby.niRooms.length;
        i < r.lobbyElement.niList.length;
        ++i) {
          r.lobbyElement.niList.removeAt(
              i); //should start with the first excess index above em's max, then end at the end of the list
          r.lobbyElement.niDivList.removeAt(
              i); //remove the div after removing its contents, div will be added back only if need be
        }
      }
    } else {}
  }


  void joinRoom(int id, int game) {
    deRenderLobby();
    print(id);
    em.gameState.id = id;
    em.gameState.gameType = game;
    if (game == 0) {
      //blackjack
      renderBlackJack();
    }

    if (game == 1) {
      renderSolitaire();
    }

    if (game == 5) {
      renderNi();
    }
    em.create_player = 1;
    //add other games here
  }

  //Render functions
  void renderBlackJack() {
    r.blackJackElementDiv = new DivElement();
    r.blackJackElementDiv..setAttribute('id', 'blackJack')..setAttribute(
        'class', 'blackjack_div');
    r.blackJackElement = new BlackJackElement(r.blackJackElementDiv);
    r.parent.children.add(r.blackJackElementDiv);

    r.blackJackElementDiv.children.add(leaveGame);
    print("rendering blackjack");
  }

  void renderSolitaire() {
    r.solitaireElementDiv = new DivElement();
    r.solitaireElementDiv..setAttribute('id', 'solitaire')..setAttribute(
        'class', 'solitaire_div');
    r.solitaireElement = new SolitaireElement(r.solitaireElementDiv);
    r.parent.children.add(r.solitaireElementDiv);
    print("Rendering solitaire");
    r.solitaireElementDiv.children.add(leaveGame);
  }


  void renderNi() {
    r.niElementDiv = new DivElement();
    r.niElementDiv..setAttribute('id', 'ni')..setAttribute('class', 'ni_div');
    r.niElement = new NiElement(r.niElementDiv);
    r.parent.children.add(r.niElementDiv);
    r.niElementDiv.children.add(leaveGame);
  }


  void renderChat(Event e) {
    deRender();
    r.chatBoxElementDiv = new DivElement();
    r.chatBoxElementDiv..setAttribute('id', 'menu')..setAttribute(
        'class', 'chat_div');
    r.chatBoxElement = new ChatBoxElement(r.chatBoxElementDiv);
    r.parent.children.add(r.chatBoxElementDiv);
    r.chatBoxElement.submitMessage.onClick.listen(sendMessage);
    menuState = 2;
  }

  void renderLogin(Event e) {
    deRender();
    r.loginElementDiv = new DivElement();
    r.loginElementDiv..setAttribute('id', 'menu')..setAttribute(
        'class', 'login_div');
    r.loginElement = new LoginElement(r.loginElementDiv);
    r.parent.children.add(r.loginElementDiv);
    menuState = 0;
    r.loginElement.submit.onClick.listen(submit);
  }

  void renderHome(Event e) {
    deRender();
    r.homeElementDiv = new DivElement();
    r.homeElementDiv..setAttribute('id', 'menu')..setAttribute(
        'class', 'home_div');
    r.homeElement = new HomeElement(r.homeElementDiv);
    r.parent.children.add(r.homeElementDiv);
    menuState = 1;
  }

  void renderRules(Event e) {
    deRender();
    r.rulesElementDiv = new DivElement();
    r.rulesElementDiv..setAttribute('id', 'menu')..setAttribute(
        'class', 'rules_div');
    r.rulesElement = new RulesElement(r.rulesElementDiv);
    r.parent.children.add(r.rulesElementDiv);
    menuState = 3;
  }

  void deRender() {
    if (menuState == 0) {
      r.loginElementDiv.remove();
      r.loginElement = null;
      r.loginElementDiv = null;
    } else if (menuState == 1) {
      r.homeElementDiv.remove();
      r.homeElement = null;
      r.homeElementDiv = null;
    } else if (menuState == 2) {
      r.chatBoxElementDiv.remove();
      r.chatBoxElement = null;
      r.chatBoxElementDiv = null;
    } else {
      //menuState == 3
      r.rulesElementDiv.remove();
      r.rulesElement = null;
      r.rulesElementDiv = null;
    }
  }

  void deRenderLobby() {
    r.lobbyElementDiv.remove();
    r.lobbyElement = null;
    r.lobbyElementDiv = null;
  }


  void deRenderGame() {
    if (em.gameState.gameType == 0) {
      r.blackJackElementDiv.remove();
      r.blackJackElement = null;
      r.blackJackElementDiv = null;
    }
    else if (em.gameState.gameType == 1) {
      print(r.solitaireElementDiv);
      r.solitaireElementDiv.remove();
      r.solitaireElement = null;
      r.blackJackElementDiv = null;
    }
    else if (em.gameState.gameType == 5) {
      print(r.niElementDiv);
      r.niElementDiv.remove();
      r.niElement = null;
      r.niElementDiv = null;
    }
    //update with more gameModes later
  }

  void playSolitaire(Event e) {
    if (e.target == r.lobbyElement.playSolitaire) {
      print('made it');


      em.solitaire_load = 1;

      em.playing_solitaire = 1;
      r.lobbyElementDiv.remove();
      r.lobbyElementDiv = null;
      r.lobbyElement = null;
      r.solitaireElementDiv = new DivElement();
      r.parent.children.add(r.solitaireElementDiv);
      r.solitaireElement = new SolitaireElement(r.solitaireElementDiv);
      r.solitaireElementDiv.children.add(leaveGame);
    }
  }

  void exitGame(Event e) {
    print("exiting " + playerId.toString());
    deRenderGame();
    em.delete_player_id = playerId;
    em.gameState.id = null;
    em.gameState.gameType = null; //null gameState after leaving
    playerId = 0;
  }
}
//Lobby functions



//old functions
  //void
//  void checkLogin() {
//    if(em.flush_user == 1) {
//      return;
//    }
//
//    if(em.logged_in == 1) {
//      r.loginElementDiv.remove();
//    }else {
//      r.loginElement.failedLogin=1;
//      em.user.userName = r.loginElement.username.value;
//      em.user.password = r.loginElement.password.value;
//    }
//  }
//  void checkUser() {
//    if(em.logged_in == 1) {
//      h.user = em.user.userName;
//      h.credits = em.user.credits;
//    }
//  }
//  void updateChat() {
//    if(em.chat.messages == null) {
//      //exit
//    }
//    else if(em.chat.messages.length > cr.messageCount) {
//      while(cr.messageCount < em.chat.messages.length) {
//        new MessageRender(em.chat.messages[cr.messageCount], cr.messageWindow, cr.chatManager);
//        ++cr.messageCount; //this will end with the count being the exact message count, which means it will resume and pick up the next new message at the right spot
//      }
//    }
//  }
//
//  void updateList() {
//    if(em.lobby.blackjackRooms == null) {
//
//    }
//    else {
//      cl.removeList(); //since this may be called in a few cases, and will likely need to be recalled multiple times
//      for(int i = 0; i < em.lobby.blackjackRooms.length;++i) {
//        new RoomElement(em.lobby.blackjackRooms[i],gamePlaceholder, listManager, cl); //check to see if this is right
//      }
//
//    }
//
//  }
//  void joinGame() {
//    cl.removeList();
//    cl.renderGameBoard();
//    //bj.initGame();
//  }
//
//  void sendMessage(Event e) {
//
//    outMessage = new Message();
//    outMessage.username = chatManager.user.userName;
//    outMessage.text = inputMessage.value;
//    outMessage.time = new DateTime.now().toString();
//    chatManager.outbox.add(outMessage);
//    chatManager.flush_chat = 1;
//    print("Message sending");
//    print(chatManager.outbox);
//    print(chatManager.chat.messages);
//    // new MessageRender(outMessage, messageWindow, chatManager); use only for testing
//    inputMessage.value=''; //Avoids spamming
//  }
//
//  void generateRegister(Event e) {
//    if (loginStatus == 0) {
//      username.setAttribute('placeholder', 'New User');
//      password.setAttribute('placeholder', 'New Password');
//      submit.text = 'Register';
//      register.text = 'Back';
//      loginStatus = 1;
//    }
//    else {
//      reGenerateLogin();
//      loginStatus = 0;
//    }
//  }


