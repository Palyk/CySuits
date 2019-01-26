import 'dart:html';
import 'CardElement.dart';

class PokerElement {
  DivElement parent;

  DivElement User = new DivElement();//will always be used, in spectate mode will be used as p1
  List<CardElement> userHand;
  List<DivElement> userHandDiv;

  DivElement p2 = new DivElement(); //p2-p4 may not be used depending on number of players, the elements will still exist in their spots
  List<CardElement> p2Hand;
  List<DivElement> p2HandDiv;


  DivElement p3 = new DivElement();
  List<CardElement> p3Hand;
  List<DivElement> p3HandDiv;


  DivElement p4 = new DivElement();
  List<CardElement> p4Hand;
  List<DivElement> p4HandDiv;

  DivElement Dealer = new DivElement(); //will always be used
  List<CardElement> dealerHand; //In poker, dealerHand will refer to the set of cards in the center that are set by the dealer
  List<DivElement> dealerHandDiv;


  ButtonElement bet = new ButtonElement();
  ButtonElement check = new ButtonElement();
  ButtonElement fold = new ButtonElement();
  ButtonElement call = new ButtonElement();

  ImageElement gameBoard;


  PokerElement(DivElement parent) {
    this.parent = parent;
    User = new DivElement();
    p2 = new DivElement();
    p3 = new DivElement();
    p4 = new DivElement();
    Dealer = new DivElement();
    bet = new ButtonElement();
    check = new ButtonElement();
    fold = new ButtonElement();
    call = new ButtonElement();
    gameBoard = new ImageElement();
    gameBoard.setAttribute("src", "../resources/icons/table.jpg");

    bet..setAttribute('id', 'b1')
      ..setAttribute('class', 'pokerButton')
      ..text = 'Bet';
    check..setAttribute('id', 'b2')
      ..setAttribute('class', 'pokerButton')
      ..text = 'Check';
    fold..setAttribute('id', 'b3')
      ..setAttribute('class', 'pokerButton')
      ..text = 'Fold';
    call..setAttribute('id', 'b4')
      ..setAttribute('class', 'pokerButton')
      ..text = 'Call';

    parent.children.add(bet);
    parent.children.add(check);
    parent.children.add(fold);
    parent.children.add(call);

    User.setAttribute('class', 'user');
    p2.setAttribute('class', 'user');
    p3.setAttribute('class', 'user');
    p4.setAttribute('class', 'user');
    Dealer.setAttribute('class', 'user');
    User.setAttribute('id', 'p_user');
    p2.setAttribute('id', 'p_p2');
    p3.setAttribute('id', 'p_p3');
    p4.setAttribute('id', 'p_p4');
    Dealer.setAttribute('id', 'p_dealer');

    User.text = 'User';
    p2.text = 'Player 2';
    p3.text = 'Player 3';
    p4.text = 'Player 4';
    Dealer.text = 'Dealer';

    userHand = [];
    userHandDiv = [];
    p2Hand = [];
    p2HandDiv = [];
    p3Hand = [];
    p3HandDiv = [];
    p4Hand = [];
    p4HandDiv = [];
    dealerHand = [];
    dealerHandDiv = [];

    parent.children.add(User);
    parent.children.add(p2);
    parent.children.add(p3);
    parent.children.add(p4);
    parent.children.add(Dealer);



  }

  void render() { //blackjack logic will handle rendering cards and making sure the hand is updated, just render all the cards
    userHand.forEach((card){
      card.render();
    });
    p2Hand.forEach((card){
      card.render();
    });
    p3Hand.forEach((card){
      card.render();
    });
    p4Hand.forEach((card){
      card.render();
    });
    dealerHand.forEach((card) {
      card.render();
    });
  }
}