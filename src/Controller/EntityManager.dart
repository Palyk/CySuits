import 'dart:html';
import '../Entities/User.dart';
import 'dart:convert';
import '../Entities/GameState.dart';
import '../Entities/Solitaire/SolitaireState.dart';
import '../Entities/Chat.dart';
import '../Entities/Message.dart';
import '../Entities/Player.dart';
import '../Entities/Lobby.dart';
import '../Entities/Room.dart';

class EntityManager {
  //data variables
  User user;
  GameState gameState;
  SolitaireState solitaireState;
  Chat chat;
  List<Message> outbox;
  Lobby lobby;

  //control and status variables
  String key;
  int flush_user;
  int flush_gameState;
  int flush_chat;
  int create_player;
  int delay_lobby;
  int playing_solitaire;
  int solitaire_save;
  int solitaire_load;
  int logged_in;
  int delete_gameState_id;
  int delete_player_id;
  int create_user;

  int login_waiting;
  int getUser_waiting;
  int updateUser_waiting;
  int createUser_waiting;
  int getGameState_waiting;
  int updateGameState_waiting;
  int createGameState_waiting;
  int deleteGameState_waiting;
  int getSolitaireState_waiting;
  int updateSolitaireState_waiting;
  int getChat_waiting;
  int updateChat_waiting;
  int getLobby_waiting;
  int createPlayer_waiting;
  int deletePlayer_waiting;

  EntityManager() {
    user = new User();
    gameState = new GameState();
    solitaireState = new SolitaireState();
    chat = new Chat();
    chat.messages = [];
    outbox = [];
    lobby = new Lobby();

    key = '';
    flush_user = 0;
    flush_gameState = 0;
    flush_chat = 0;
    create_player = 0;
    delay_lobby = 0;
    playing_solitaire = 0;
    solitaire_save = 0;
    solitaire_load = 0;
    logged_in = 0;
    delete_gameState_id = 0;
    delete_player_id = 0;
    create_user = 0;

    login_waiting = 0;
    getUser_waiting = 0;
    updateUser_waiting = 0;
    createUser_waiting = 0;
    getGameState_waiting = 0;
    updateGameState_waiting = 0;
    createGameState_waiting = 0;
    deleteGameState_waiting = 0;
    getSolitaireState_waiting = 0;
    updateSolitaireState_waiting = 0;
    getChat_waiting = 0;
    updateChat_waiting = 0;
    getLobby_waiting = 0;
    createPlayer_waiting = 0;
    deletePlayer_waiting = 0;

  }

  void run() {
    if (flush_user == 1 && logged_in == 0) {
      login();

    }
    if (flush_user == 1 && logged_in == 1) {
      updateUser();
    }
    if (create_user == 1) {
      createUser();
    }
    if (flush_user == 0 && logged_in == 1) {
      getUser();
    }
    if (create_player == 1) {
      createPlayer();
    }
    if (delete_player_id != null && delete_player_id != 0) {
      deletePlayer();
    }
    if (flush_gameState == 1 && gameState.id != null && gameState.id > 0) {
      updateGameState();
    }
    if (flush_gameState == 1 && (gameState.id == null || gameState.id == 0)) {
      createGameState();
    }
    if (playing_solitaire != 1 && gameState.id != null && gameState.id > 0) {
      getGameState();
    }
    if (flush_chat == 1) {
      updateChat();
    }

    getChat();

    if (playing_solitaire == 1) {
      if (solitaire_load == 1) {
        getSolitaireState();
      }
      if (solitaire_save == 1) {
        updateSolitaireState();
      }
    }
    if (delay_lobby > 5) {
      getLobby();
    } else {
      delay_lobby++;
    }
  }

  void login() {

    if (user.userName == null ||
        user.userName == '' ||
        user.password == null ||
        user.password == '' ||
        login_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {

      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          flush_user = 0;
          logged_in = 1;
          key = data['key'];
          user.id = data['id'];
          print(user.id);
        }

        login_waiting = 0;
      }
    });
    request.onError.listen((Event e) {

      // login_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/login.php";
    request.open("POST", url, async: true);

    var jsonData = {'username': user.userName, 'password': user.password};
    login_waiting = 1;
    request.send(JSON.encode(jsonData));


  }

  void getUser() {
    if (key == null ||
        key == '' ||
        user.id == null ||
        user.id == 0 ||
        getUser_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          user.credits = data['currency'];
          user.permission = data['permission'];
        }
        getUser_waiting = 0;
      }
    });
    request.onError.listen((Event e) {
      getUser_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/getUser.php";
    request.open("POST", url, async: true);

    var jsonData = {'key': key, 'id': user.id};
    getUser_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void updateUser() {
    if (key == null ||
        key == '' ||
        user.id == null ||
        user.id == 0 ||
        updateUser_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        if (JSON.decode(request.responseText)['error'] == 0) {
          flush_user = 0;
          getUser();
        }
        updateUser_waiting = 0;
      }
    });
    request.onError.listen((Event e) {
      updateUser_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/updateUser.php";
    request.open("POST", url, async: true);
    var jsonData = {
      'key': key,
      'id': user.id,
      'username': user.userName,
      'password': user.password,
      'currency': user.credits,
      'permission': user.permission
    };
    updateUser_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void createUser() {

    if (user.userName == null ||
        user.userName == '' ||
        user.password == null ||
        user.password == '' ||
        createUser_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          getUser();
        }
        create_user = 0;
        createUser_waiting = 0;
      }
    });
    request.onError.listen((Event e) {
      createUser_waiting = 0;
    });
    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/createUser.php";
    request.open("POST", url, async: true);

    var jsonData = {'username': user.userName, 'password': user.password};
    createUser_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void getGameState() {
    if (gameState.id == null ||
        gameState.id == 0 ||
        key == null ||
        key == '' ||
        getGameState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          if(gameState.players == null) {
            gameState.players = [];
          }
          else {
            gameState.players.clear();
          }
          data['players'].forEach((player) {
            Player p = new Player();
            p
              ..id = player['id']
              ..hand = player['cards']
              ..insurance = player['insurance']
              ..bet = player['bet']
              ..credits = player['credits']
              ..userName = player['username'];
            gameState.players.add(p);
          });


          gameState
            ..minimumBet = data['minimum_bet']
            ..pot = data['pot']
            //..id = data['id']
            ..gameType = data['game_type']
            ..dealerHand = data['dealer_cards']
            ..timer = data['timer'];

          gameState.players.forEach((player) {
            if (player.id == data['big_blind']) {
              gameState.bigBlind = player;
            }
            if (player.id == data['little_blind']) {
              gameState.littleBlind = player;
            }
            if (player.id == data['player_current']) {
              gameState.playerCurrent = player;
            }
            if (player.id == data['host_id']) {
              gameState.host = player;
            }
          });
        }
        getGameState_waiting = 0;
      }
    });
    request.onError.listen((Event e) {
      getGameState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/getGameState.php";
    request.open("POST", url, async: true);
    var jsonData = {'id': gameState.id, 'key': key};
    getGameState_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void updateGameState() {

    if (gameState.id == null ||
        gameState.id == 0 ||
        key == null ||
        key == '' ||
        updateGameState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        if (JSON.decode(request.responseText)['error'] == 0) {
          flush_gameState = 0;
        }
        getGameState();
      }
      updateGameState_waiting = 0;
    });
    request.onError.listen((Event e) {
      updateGameState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/updateGameState.php";
    request.open("POST", url, async: true);
    var jsonData = {
      'key': key,
      'id': gameState.id,
      'dealer_cards': gameState.dealerHand,
      'minimum_bet': gameState.minimumBet,
      'pot': gameState.pot,
      'big_blind': gameState.bigBlind.id,
      'little_blind': gameState.littleBlind.id,
      'player_current': gameState.playerCurrent.id,
      'timer': gameState.timer,
      'host_id': gameState.host.id,
    };
    gameState.players.forEach((player) {
      jsonData['players'].add({
        'cards': player.hand,
        'username': player.userName,
        'insurance': player.insurance,
        'bet': player.bet,
        'credits': player.credits,
        'id': player.id
      });
    });

    updateGameState_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void createGameState() {
    if (key == null || key == '' || createGameState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          flush_gameState = 0;
        }
      }
    });
    request.onError.listen((Event e) {
      createGameState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/createGameState.php";
    request.open("POST", url, async: true);

    var jsonData = {'key': key};
    request.send(JSON.encode(jsonData));
  }

  void deleteGameState() {
    if (delete_gameState_id == null ||
        delete_gameState_id == 0 ||
        key == null ||
        key == '' ||
        deleteGameState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          delete_gameState_id = 0;
        }
        deleteGameState_waiting = 0;
      }
    });
    request.onError.listen((Event e) {
      deleteGameState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/deleteGameState.php";
    request.open("POST", url, async: true);
    var jsonData = {'id': delete_gameState_id, 'key': key};
    deleteGameState_waiting = 1;
    request.send(JSON.encode(jsonData));
  }

  void getSolitaireState() {
    if (user.id == null ||
        user.id == 0 ||
        key == null ||
        key == '' ||
        getSolitaireState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == null) {
          solitaire_load = 0;
          solitaireState
            ..tableuUp = data['tableu_up']
            ..tableuDown = data['tableu_down']
            ..foundation = data['foundation']
            ..waste = data['waste']
            ..stockpile = data['stockpile']
            ..score = data['score'];
        }
        getSolitaireState_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      getSolitaireState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/getSolitaireState.php";
    request.open("POST", url, async: true);
    var jsonData = {'user_id': user.id, 'key': key};
    getSolitaireState_waiting=1;
    request.send(JSON.encode(jsonData));
  }

  void updateSolitaireState() {
    if (user.id == null ||
        user.id == 0 ||
        key == null ||
        key == '' ||
        updateSolitaireState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        getSolitaireState();
        if (JSON.decode(request.responseText)['error'] == null) {
          solitaire_save = 0;
        }
        updateSolitaireState_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      updateSolitaireState_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/updateSolitaireState.php";
    request.open("POST", url, async: true);
    var jsonData = {
      'key': key,
      'user_id': user.id,
      'score': solitaireState.score,
      'tableu_up': solitaireState.tableuUp,
      'tableu_down': solitaireState.tableuDown,
      'foundation': solitaireState.foundation,
      'waste': solitaireState.waste,
      'stockpile': solitaireState.stockpile,
    };
    updateSolitaireState_waiting=1;
    request.send(JSON.encode(jsonData));
  }

  void getChat() {
    if (key == null ||
        key == '' ||
        getChat_waiting == 1) {

      return;
    }

    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);

        if (data['error'] == 0) {
          if (chat.messages == null) {
            chat.messages = [];
          } else {
            chat.messages.clear();
          }
          data['messages'].forEach((message) {
            Message m = new Message();
            m
              ..username = message['username']
              ..text = message['text']
              ..time = message['time'];
            chat.messages.add(m);
          });
        }
        getChat_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      getChat_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/getChat.php";
    request.open("POST", url, async: false);
    var jsonData;
    if(chat.gameStateId != null) {
      jsonData = {'key': key, 'game_state_id': chat.gameStateId};
    }
    else {
      jsonData = {'key': key, 'game_state_id': 0};
    }

    getChat_waiting=1;
    request.send(JSON.encode(jsonData));
  }

  void updateChat() {
    if (outbox == null ||
        outbox.length == 0 ||
        key == null ||
        key == '' ||
        updateChat_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (data['error'] == 0) {
          flush_chat = 0;
          outbox.clear();
        }

        updateChat_waiting=0;
      }
    });

    request.onError.listen((Event e) {
      updateChat_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/updateChat.php";
    request.open("POST", url, async: true);


    var jsonData;
    if(chat.gameStateId != null) {
      jsonData = {'key': key, 'game_state_id': chat.gameStateId};
    }
    else {
      jsonData = {'key': key, 'game_state_id': 0};
    }
    jsonData['messages'] = [];

    outbox.forEach((message) {
      jsonData['messages'].add({
        'username': message.username,
        'text': message.text,
        'time': message.time
      });
    });
    updateChat_waiting=1;
    request.send(JSON.encode(jsonData));

  }

  void getLobby() {
    if(getLobby_waiting==1){
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        if (JSON.decode(request.responseText)['error'] == 0) {
          delay_lobby = 0;
          if (lobby.blackjackRooms == null) {
            lobby.blackjackRooms = [];
          } else {
            lobby.blackjackRooms.clear();
          }

          if (lobby.solitaireRooms == null) {
            lobby.solitaireRooms = [];
          }
          else {
            lobby.solitaireRooms.clear();
          }
          if (lobby.niRooms == null) {
            lobby.niRooms = [];
          }
          else {
            lobby.niRooms.clear();

          }

          data['rooms'].forEach((room) {
            Room r = new Room();
            r
              ..gameStateId = room['id']
              ..players = room['players']
              ..gameType = room['game_type'];
            
            if(r.gameType == 0) {
              lobby.blackjackRooms.add(r);
            }

            else if(r.gameType == 1) {
              lobby.solitaireRooms.add(r);
            }
            else if(r.gameType == 5) {
              lobby.niRooms.add(r);

            }
            //if (room['game_type'] == 0) {
             // lobby.blackjackRooms.add(r);
            //}
          });
        }
        getLobby_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      getLobby_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/getLobby.php";
    request.open("GET", url, async: true);
    getLobby_waiting=1;
    request.send();
  }

  void createPlayer() {
    if (gameState.id == null ||
        gameState.id == 0 ||
        user.userName == null ||
        user.userName == '' ||
        key == null ||
        key == '' ||
        createPlayer_waiting == 1 ||
        getSolitaireState_waiting == 1) {
      return;
    }
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        if (JSON.decode(request.responseText)['error'] == 0) {
          create_player = 0;
          getGameState();
        }
        createPlayer_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      createPlayer_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/createPlayer.php";
    request.open("POST", url, async: true);
    var jsonData = {
      'key': key,
      'game_state_id': gameState.id,
      'username': user.userName,
    };
    createPlayer_waiting=1;
    request.send(JSON.encode(jsonData));
  }

  void deletePlayer() {

    if (delete_player_id == null ||
        delete_player_id == 0 ||
        key == null ||
        key == '' ||
        deletePlayer_waiting == 1) {
      return;
    }
    print("delete player");
    HttpRequest request = new HttpRequest();

    request.onReadyStateChange.listen((Event e) {
      if (request.readyState == HttpRequest.DONE) {
        var data = JSON.decode(request.responseText);
        print(data);
        if (data['error'] == 0) {
          delete_player_id = 0;
        }
        deletePlayer_waiting=0;
      }
    });
    request.onError.listen((Event e) {
      deletePlayer_waiting = 0;
    });

    var url =
        "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/deletePlayer.php";
    request.open("POST", url, async: true);
    var jsonData = {'id': delete_player_id, 'key': key};
    deletePlayer_waiting = 1;
    request.send(JSON.encode(jsonData));
  }
}
