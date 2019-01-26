import 'dart:html';
import '../Views/CardElement.dart';

class BlackJackElement {
  DivElement parent;

  ButtonElement hit;
  ButtonElement stand;
  ButtonElement insurance;
  ButtonElement doubleDown;
  SelectElement bet;

  DivElement betAmountDiv;
  int betAmount; // Bet amount of this particular user.

  DivElement creditAmountDiv;
  int creditAmount; // Credit amount of this particular user.

  List<CardElement> dealerHand;
  List<DivElement> dealerHandDivList;
  DivElement dealerDiv;

  List<CardElement> p1Hand;
  List<DivElement> p1HandDivList;
  DivElement p1Div;

  List<CardElement> p2Hand;
  List<DivElement> p2HandDivList;
  DivElement p2Div;

  List<CardElement> userHand;
  List<DivElement> userHandDivList;
  DivElement userDiv;

  List<CardElement> p4Hand;
  List<DivElement> p4HandDivList;
  DivElement p4Div;

  List<CardElement> p5Hand;
  List<DivElement> p5HandDivList;
  DivElement p5Div;

  List<List<CardElement>> players;
  List<DivElement> playerDivs;

  BlackJackElement(DivElement parent) {
    this.parent = parent;

    hit = new ButtonElement();
    stand = new ButtonElement();
    insurance = new ButtonElement();
    doubleDown = new ButtonElement();

    bet = new SelectElement();
    for (int i = 1; i <= 5; i++) {
      OptionElement option = new OptionElement();
      option.value = "${i*10}";
      bet.children.add(option);
    }

    this.parent.children.add(hit);
    this.parent.children.add(stand);
    this.parent.children.add(insurance);
    this.parent.children.add(doubleDown);
    this.parent.children.add(bet);

    players = new List<List<CardElement>>();
    playerDivs = new List<DivElement>();

    // Initialize dealer
    dealerHand = new List<CardElement>();
    dealerHandDivList = new List<DivElement>(10);
    dealerDiv = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      dealerHandDivList[i] = cardDiv;
      dealerDiv.children.add(cardDiv);
    }
    parent.children.add(dealerDiv);

    // Initialize p1
    p1Hand = new List<CardElement>();
    p1HandDivList = new List<DivElement>();
    p1Div = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      p1HandDivList[i] = cardDiv;
      p1Div.children.add(cardDiv);
    }
    parent.children.add(p1Div);
    players.add(p1Hand);
    playerDivs.add(p1Div);

    // Initialize p2
    p2Hand = new List<CardElement>();
    p2HandDivList = new List<DivElement>();
    p2Div = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      p2HandDivList[i] = cardDiv;
      p2Div.children.add(cardDiv);
    }
    parent.children.add(p2Div);
    players.add(p2Hand);
    playerDivs.add(p2Div);

    // Initialize user
    userHand = new List<CardElement>();
    userHandDivList = new List<DivElement>();
    userDiv = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      userHandDivList[i] = cardDiv;
      userDiv.children.add(cardDiv);
    }
    parent.children.add(userDiv);
    players.add(userHand);
    playerDivs.add(userDiv);

    // Initialize p4
    p4Hand = new List<CardElement>();
    p4HandDivList = new List<DivElement>();
    p4Div = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      p4HandDivList[i] = cardDiv;
      p4Div.children.add(cardDiv);
    }
    parent.children.add(p4Div);
    players.add(p4Hand);
    playerDivs.add(p4Div);

    // Initialize p5
    p5Hand = new List<CardElement>();
    p5HandDivList = new List<DivElement>();
    p5Div = new DivElement();

    for (int i = 0; i < 10; i++) {
      DivElement cardDiv = new DivElement();
      p5HandDivList[i] = cardDiv;
      p5Div.children.add(cardDiv);
    }
    parent.children.add(p5Div);
    players.add(p5Hand);
    playerDivs.add(p5Div);

    betAmountDiv = new DivElement();
    creditAmountDiv = new DivElement();
    this.parent.children.add(betAmountDiv);
    this.parent.children.add(creditAmountDiv);
  }

  void render() {
    userHand.forEach((card) {
      card.render();
    });
    p1Hand.forEach((card) {
      card.render();
    });
    p2Hand.forEach((card) {
      card.render();
    });
    p4Hand.forEach((card) {
      card.render();
    });
    p5Hand.forEach((card) {
      card.render();
    });
    dealerHand.forEach((card) {
      card.render();
    });

    applyStyle();
  }

  void applyStyle() {
    bet.text = 'Bet';
    bet.style.setProperty('left', '20%');

    hit.text = 'Hit';
    hit.style.setProperty('left', '30%');

    stand.text = 'Stand';
    stand.style.setProperty('left', '40%');

    doubleDown.text = 'Double Down';
    doubleDown.style.setProperty('left', '50%');

    insurance.text = 'Insurance';
    insurance.style.setProperty('left', '60%');

    // Style dealer hand
    dealerDiv.style.setProperty('position', 'absolute');
    dealerDiv.style.setProperty('height', '200px');
    dealerDiv.style.setProperty('width', '250px');
    dealerDiv.style.setProperty('left', '40%');
    dealerDiv.style.setProperty('top', '5%');

    int j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = dealerHandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style user hand
    userDiv.style.setProperty('position', 'absolute');
    userDiv.style.setProperty('height', '200px');
    userDiv.style.setProperty('width', '250px');
    userDiv.style.setProperty('left', '40%');
    userDiv.style.setProperty('top', '75%');

    j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = userHandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style p1 hand
    p1Div.style.setProperty('position', 'absolute');
    p1Div.style.setProperty('height', '200px');
    p1Div.style.setProperty('width', '250px');
    p1Div.style.setProperty('left', '1%');
    p1Div.style.setProperty('top', '40%');

    j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = p1HandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style p2 hand
    p2Div.style.setProperty('position', 'absolute');
    p2Div.style.setProperty('height', '200px');
    p2Div.style.setProperty('width', '250px');
    p2Div.style.setProperty('left', '1%');
    p2Div.style.setProperty('top', '60%');

    j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = p2HandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style p4 hand
    p4Div.style.setProperty('position', 'absolute');
    p4Div.style.setProperty('height', '200px');
    p4Div.style.setProperty('width', '250px');
    p4Div.style.setProperty('right', '1%');
    p4Div.style.setProperty('top', '60%');

    j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = p4HandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style p5 hand
    p5Div.style.setProperty('position', 'absolute');
    p5Div.style.setProperty('height', '200px');
    p5Div.style.setProperty('width', '250px');
    p5Div.style.setProperty('right', '1%');
    p5Div.style.setProperty('top', '75%');

    j = 0;
    for (int i = 0; i < 10; i++, j++) {
      if (j >= 4) {
        j = 0;
      }

      DivElement cardDiv = p5HandDivList[i];
      cardDiv.style.setProperty('position', 'absolute');
      cardDiv.style.setProperty('height', '100px');
      cardDiv.style.setProperty('width', '50px');
      cardDiv.style.setProperty('float', 'left');
      cardDiv.style.setProperty('background-color', 'green');
    }

    // Style bet
    betAmountDiv.style.setProperty('position', 'absolute');
    betAmountDiv.style.setProperty('left', '25%');
    betAmountDiv.style.setProperty('top', '95%');
    betAmountDiv.text = 'Bet: ${betAmount}';

    // Style credits
    creditAmountDiv.style.setProperty('position', 'absolute');
    creditAmountDiv.style.setProperty('right', '25%');
    creditAmountDiv.style.setProperty('top', '95%');
    creditAmountDiv.text = 'Credits: ${creditAmount}';
  }
}
