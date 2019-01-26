import 'dart:html';
import '../Views/RoomElement.dart';

class LobbyElement {
  DivElement parent;

  DivElement blackjackRooms;
  DivElement solitaireRooms;
  DivElement niRooms;


  List<RoomElement> blackjackList;
  List<DivElement> blackjackDivList;

  List<RoomElement> niList;
  List<DivElement> niDivList;





  List<RoomElement> solitaireList;
  List<DivElement> solitaireDivList;



  ButtonElement playSolitaire;

  //add different lists for different games in the future

  LobbyElement(DivElement parent) {
    this.parent = parent;

    blackjackList = []; //instantiate the list

    blackjackDivList = []; //instantiate the list
    solitaireList = [];
    solitaireDivList = [];

    niList = [];
    niDivList = [];


    playSolitaire = new ButtonElement();
    playSolitaire.text = 'play solitaire';
    parent.children.add(playSolitaire);


    blackjackRooms = new DivElement();
    niRooms = new DivElement();

    blackjackRooms.text = "Blackjack Rooms";
    niRooms.text = "Ni Rooms";

    parent.children.add(blackjackRooms);
    parent.children.add(niRooms);
  }

  void render() {
    blackjackList.forEach((curr) {
      curr.render();
    });

    solitaireList.forEach((curr) {
      curr.render();
    });
    niList.forEach((curr) {

      curr.render();
    });
  }
}