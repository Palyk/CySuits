import 'dart:html';
import 'dart:math';

import '../CardList.dart';
import '../Renderer.dart';
import '../../Entities/User.dart';
import '../../Entities/Player.dart';
import '../../Controller/EntityManager.dart';
import '../../Views/CardElement.dart';

class BlackJackLogic {
  EntityManager em;
  Renderer r;

  BJLogicPlayer
      thisPlayer; // Access point for all the representations of em.user
  BJLogicPlayer
      currentPlayer; // Access point for all the representations of em.playerCurrent
  List<BJLogicPlayer> bjPlayers; // Access point for the rest of the players

  BlackJackLogic(EntityManager em, Renderer r) {
    this.em = em;
    this.r = r;

    r.blackJackElement.hit.onClick.listen(hit);
    r.blackJackElement.stand.onClick.listen(stand);
    r.blackJackElement.doubleDown.onClick.listen(doubleDown);
    r.blackJackElement.insurance.onClick.listen(insurance);
    for (int i = 0; i < r.blackJackElement.bet.children.length; i++) {
      r.blackJackElement.bet.children[i].onClick.listen(bet);
    }

    initGame();
  }

  void run() {
    if (em == null ||
        em.flush_gameState != 0 ||
        em.gameState == null ||
        r == null ||
        thisPlayer == null) {
      return;
    }

    if (em.gameState.dealerHand == null && currentPlayer != null) {
      if (em.gameState.timer < 20000) {
        em.gameState.timer++;
      } else if (em.gameState.timer >= 20000){
        deal();
        em.gameState.timer = 0;
      }
    } else if (em.gameState.dealerHand != null && currentPlayer == null) {
      // All inGame players have finished their turns
      runDealer();
      settle();
    }

    // Resolve discrepancies between em.gameState and r.renderer
    // Resolve dealer
    if (em.gameState.dealerHand.length > r.blackJackElement.dealerHand.length &&
        r.blackJackElement.dealerHand.length < 10) {
      List<CardElement> tempList = new List<CardElement>();
      for (CardElement card in r.blackJackElement.dealerHand) {
        tempList.add(card);
      }

      for (int cardID in em.gameState.dealerHand) {
        CardElement foundCard;
        for (CardElement card in tempList) {
          if (cardID == card.cardCode) {
            foundCard = card;
            break;
          }
        }
        if (foundCard != null) {
          tempList.remove(foundCard);
        } else {
          CardElement newCard = new CardElement(r.blackJackElement
              .dealerHandDivList[r.blackJackElement.dealerHand.length]);
          newCard.cardCode = cardID;
          r.blackJackElement.dealerHand.add(newCard);
        }
      }
    }
    // Resolve the rest of the players
    for (BJLogicPlayer bjPlayer in bjPlayers) {
      bjPlayer.resolve();
    }
    em.flush_gameState = 1;
  }

  // initGame initializes all necessary gameState instance
  // variables pertinent to Black Jack
  void initGame() {
    // Create BJLogicPlayers, add these BJLogicPlayers to the list bjPlayers
    bjPlayers = new List<BJLogicPlayer>();
    for (Player player in em.gameState.players) {
      BJLogicPlayer bjPlayer = new BJLogicPlayer(
          (em.user.userName == player.userName) ? em.user : null,
          player,
          (player.turn != 0)
              ? r.blackJackElement.players[player.turn - 1]
              : null,
          (player.turn != 0)
              ? r.blackJackElement.playerDivs[player.turn - 1].children
              : null,
          (player.turn != 0)
              ? r.blackJackElement.playerDivs[player.turn - 1]
              : null,
          r.blackJackElement.betAmount,
          r.blackJackElement.creditAmount);
      bjPlayers.add(bjPlayer);

      // Assign thisPlayer
      if (bjPlayer.userEntity != null) {
        thisPlayer = bjPlayer;
        if (thisPlayer.playerEntity.turn != 0) {
          if (r.blackJackElement.userHand.length > 0) {
            for (BJLogicPlayer bjPlayer in bjPlayers) {
              if (bjPlayer.playerEntity.turn == 3) {
                bjPlayer.rendererCards = r.blackJackElement.players[
                    thisPlayer.playerEntity.turn - 1];
                bjPlayer.rendererCardDivs = r.blackJackElement
                    .playerDivs[thisPlayer.playerEntity.turn - 1].children;
                bjPlayer.rendererPlayerDiv = r.blackJackElement.playerDivs[
                    thisPlayer.playerEntity.turn - 1];
                break;
              }
            }
          }

          thisPlayer.rendererCards = r.blackJackElement.userHand;
          thisPlayer.rendererCardDivs = r.blackJackElement.userHandDivList;
          thisPlayer.rendererPlayerDiv = r.blackJackElement.userDiv;
        }
      }
      // Assign currentPlayer
      if (em.gameState.playerCurrent != null) {
        if (em.gameState.playerCurrent.userName ==
            bjPlayer.playerEntity.userName) {
          currentPlayer = bjPlayer;
        }
      }
    }
  }

  // deal distributes cards to all inGame players and to the dealer.
  void deal() {
    if (em == null ||
        em.gameState == null ||
        em.gameState.host == null ||
        thisPlayer == null ||
        thisPlayer.playerEntity == null ||
        thisPlayer.playerEntity.userName != em.gameState.host.userName ||
        bjPlayers == null) {
      return;
    }

    Random rand = new Random();

    // Deal to all the players
    for (BJLogicPlayer bjPlayer in bjPlayers) {
      if (bjPlayer == null ||
          bjPlayer.playerEntity == null ||
          !bjPlayer.isInGame()) {
        continue;
      }

      int firstCard = rand.nextInt(52);
      int secondCard = rand.nextInt(52);
      bjPlayer.addCard(firstCard);
      bjPlayer.addCard(secondCard);

      int total = cardValue(firstCard) + cardValue(secondCard);
      if (total == 21) {
        // Natural black jack
        bjPlayer.win();
        nextPlayer();
      } else if (total >= 9 || total <= 11) {
        // Unlock double down option on 9, 10, and 11
        bjPlayer.playerEntity.canDoubleDown = true;
      } else if (total > 21) {
        bjPlayer.lose();
        nextPlayer();
      }
    }

    // Deal first card to dealer
    int firstCard = rand.nextInt(52);
    em.gameState.dealerHand.add(firstCard);
    CardElement rFirstCard =
        new CardElement(r.blackJackElement.dealerHandDivList[0]);
    rFirstCard.cardCode = firstCard;
    r.blackJackElement.dealerHand.add(rFirstCard);

    // Deal second card to dealer
    int secondCard = rand.nextInt(52);
    em.gameState.dealerHand.add(secondCard);
    CardElement rSecondCard =
        new CardElement(r.blackJackElement.dealerHandDivList[1]);
    rSecondCard.cardCode = secondCard;
    r.blackJackElement.dealerHand.add(rSecondCard);

    int total = cardValue(firstCard) + cardValue(secondCard);
    if (total == 21) {
      // Natural black jack, everyone loses
      for (BJLogicPlayer bjPlayer in bjPlayers) {
        if (bjPlayer.isInGame()) {
          bjPlayer.lose();
        }
      }
    } else if (cardValue(firstCard) == 1 || cardValue(secondCard) == 1) {
      // Dealer has at least one ace, insurance available
      for (BJLogicPlayer bjPlayer in bjPlayers) {
        bjPlayer.playerEntity.canInsurance = true;
      }
    }

    em.flush_gameState = 1;
  }

  void settle() {
    if (em == null ||
        em.gameState == null ||
        em.gameState.host == null ||
        thisPlayer == null ||
        thisPlayer.playerEntity == null ||
        thisPlayer.playerEntity.userName != em.gameState.host.userName ||
        em.gameState.dealerHand == null ||
        bjPlayers == null) {
      return;
    }
    int dealerTotal = 0;
    for (int cardID in em.gameState.dealerHand) {
      dealerTotal += cardValue(cardID);
    }

    for (BJLogicPlayer bjPlayer in bjPlayers) {
      if (bjPlayer == null) {
        continue;
      }
      if (dealerTotal > 21) {
        bjPlayer.win();
      } else if (bjPlayer.getCardTotal() > dealerTotal) {
        bjPlayer.win();
      } else {
        bjPlayer.lose();
      }
      bjPlayer.playerEntity.turn = 0;
    }

    em.flush_gameState = 1;
  }

  void runDealer() {
    if (em == null ||
        em.gameState == null ||
        em.gameState.host == null ||
        thisPlayer == null ||
        thisPlayer.playerEntity == null ||
        thisPlayer.playerEntity.userName != em.gameState.host.userName ||
        em.gameState.dealerHand == null ||
        bjPlayers == null) {
      return;
    }

    Random rand = new Random();

    int dealerTotal = 0;
    for (int cardID in em.gameState.dealerHand) {
      dealerTotal += cardValue(cardID);
    }

    while (dealerTotal <= 16) {
      int cardID = rand.nextInt(52);
      em.gameState.dealerHand.add(cardID);
      dealerTotal += cardValue(cardID);

      // Add card to renderer's dealerHand if there a spots left
      if (r.blackJackElement.dealerHand.length < 10) {
        CardElement newCard = new CardElement(r.blackJackElement
            .dealerHandDivList[r.blackJackElement.dealerHand.length]);
        newCard.cardCode = cardID;
        r.blackJackElement.dealerHand.add(newCard);
      }
    }

    em.flush_gameState = 1;
  }

  void nextPlayer() {
    if (currentPlayer == null || bjPlayers == null) {
      return;
    }

    int currentTurn = currentPlayer.playerEntity.turn;
    BJLogicPlayer tempPlayer = currentPlayer;

    // Find the next player by turn
    int minDiff = 100;
    for (BJLogicPlayer bjPlayer in bjPlayers) {
      if (bjPlayer == null || !bjPlayer.isInGame()) {
        continue;
      }

      if (bjPlayer.playerEntity.turn > currentTurn) {
        if (bjPlayer.playerEntity.turn - currentTurn < minDiff) {
          minDiff = bjPlayer.playerEntity.turn - currentTurn;
          tempPlayer = bjPlayer;
        }
      }
    }
    if (tempPlayer.equals(currentPlayer)) {
      // We didn't find the next player, meaning the round is over
      currentPlayer = null;
      em.gameState.playerCurrent = null;
    } else {
      currentPlayer = tempPlayer;
      em.gameState.playerCurrent = tempPlayer.playerEntity;
    }
  }

  /** ----------- Methods for buttons below this line ----------- **/

  void bet(Event e) {
    if (currentPlayer != null ||
        thisPlayer == null ||
        thisPlayer.isInGame() ||
        r == null ||
        r.blackJackElement == null ||
        bjPlayers == null ||
        em == null ||
        em.gameState == null) {
      return;
    }

    OptionElement target = e.target;
    int betAmount = int.parse(target.value);
    if (betAmount > thisPlayer.getCredits()) {
      return;
    }
    thisPlayer.setCredits(thisPlayer.getCredits() - betAmount);
    thisPlayer.setBet(betAmount);
    thisPlayer.setInGame(true);
    r.blackJackElement.bet.setAttribute("hidden", "hidden");

    // Assign turn
    int maxTurn = 0;
    for (BJLogicPlayer bjPlayer in bjPlayers) {
      if (bjPlayer == null) {
        continue;
      }

      if (bjPlayer.playerEntity.turn > maxTurn) {
        maxTurn = bjPlayer.playerEntity.turn;
      }
    }
    thisPlayer.playerEntity.turn = maxTurn++;
    if (maxTurn == 1) {
      em.gameState.host = thisPlayer.playerEntity;
      em.gameState.playerCurrent = thisPlayer.playerEntity;
      currentPlayer = thisPlayer;
    }

    em.flush_gameState = 1;
  }

  void hit(Event e) {
    if (thisPlayer == null ||
        !thisPlayer.equals(currentPlayer) ||
        thisPlayer.playerEntity == null ||
        !thisPlayer.isInGame()) {
      return;
    }

    Random rand = new Random();

    thisPlayer.addCard(rand.nextInt(52));
    List<int> cards;
    int total = 0;
    for (int cardID in cards) {
      total += cardValue(cardID);
    }

    if (total > 21) {
      thisPlayer.lose();
      nextPlayer();
    } else if (total == 21) {
      thisPlayer.win();
      nextPlayer();
    }

    em.flush_gameState = 1;
  }

  void stand(Event e) {
    if (thisPlayer == null ||
        !thisPlayer.equals(currentPlayer) ||
        thisPlayer.playerEntity == null ||
        !thisPlayer.isInGame()) {
      return;
    }

    nextPlayer();

    em.flush_gameState = 1;
  }

  void doubleDown(Event e) {
    // Did not implement
    return;
  }

  void insurance(Event e) {
    if (thisPlayer == null ||
        !thisPlayer.equals(currentPlayer) ||
        thisPlayer.playerEntity == null ||
        !thisPlayer.isInGame()) {
      return;
    }

    if (thisPlayer.getBet() > thisPlayer.getCredits()) {
      // Not enough credits for an insurance bet
      return;
    }
    thisPlayer.setCredits(thisPlayer.getCredits() - thisPlayer.getBet());
    thisPlayer.setBet(thisPlayer.getBet() * 2);

    em.flush_gameState = 1;
  }
}

// This class acts as a single access point for all representations of a player
class BJLogicPlayer {
  // Entity stuff
  User userEntity;
  Player playerEntity;

  // Renderer stuff
  List<CardElement> rendererCards;
  List<DivElement> rendererCardDivs;
  DivElement rendererPlayerDiv;
  int rendererBetAmount;
  int rendererCreditAmount;

  // Constructor
  BJLogicPlayer(
      User user,
      Player playerEntity,
      List<CardElement> rendererCards,
      List<DivElement> rendererCardDivs,
      DivElement rendererPlayerDiv,
      int rendererBetAmount,
      int rendererCreditAmount) {
    this.playerEntity = playerEntity;
    this.rendererCards = rendererCards;
    this.rendererCardDivs = rendererCardDivs;
    this.rendererPlayerDiv = rendererPlayerDiv;
    this.rendererBetAmount = rendererBetAmount;
    this.rendererCreditAmount = rendererCreditAmount;
  }

  // ------------------- Getters and Setters --------------------
  bool isInGame() {
    return playerEntity.inGame;
  }

  void setInGame(bool inGame) {
    playerEntity.inGame = inGame;
  }

  int getBet() {
    return playerEntity.bet;
  }

  void setBet(int betAmount) {
    playerEntity.bet = betAmount;
    rendererBetAmount = betAmount;
  }

  int getCredits() {
    return playerEntity.credits;
  }

  void setCredits(int creditAmount) {
    playerEntity.credits = creditAmount;
    userEntity.credits = creditAmount;
    rendererCreditAmount = creditAmount;
  }

  int getCardTotal() {
    if (playerEntity.hand = null) {
      return 0;
    }

    int total;
    for (int cardID in playerEntity.hand) {
      total += cardValue(cardID);
    }
    return total;
  }

  void addCard(int cardID) {
    playerEntity.hand.add(cardID);
    // Only add card to the renderer if there are any open spots left
    if (rendererCards.length < 10) {
      CardElement newCard =
          new CardElement(rendererCardDivs[rendererCards.length]);
      newCard.cardCode = cardID;
      rendererCards.add(newCard);
    }
  }

  // ---------------- Other methods ---------------------------
  void win() {
    int winnings = getBet() * 2;
    setCredits(getCredits() + winnings);
    setBet(0);

    playerEntity.inGame = false;
  }

  void lose() {
    setBet(0);
    playerEntity.inGame = false;
  }

  // resolve takes care of all discrepancies between the version
  // of this player stored in the database, and the player rendered
  // on screen. Ideally, this shouldn't have to do anything.
  void resolve() {
    // Resolve cards
    if (playerEntity.hand.length > rendererCards.length &&
        rendererCards.length < 10) {
      // Figure out which cards are missing from the renderer
      List<CardElement> tempList = new List<CardElement>();
      for (CardElement card in rendererCards) {
        tempList.add(card);
      }

      for (int cardID in playerEntity.hand) {
        CardElement foundCard;
        for (CardElement card in tempList) {
          if (cardID == card.cardCode) {
            foundCard = card;
            break;
          }
        }
        if (foundCard != null) {
          tempList.remove(foundCard);
        } else {
          CardElement newCard =
              new CardElement(rendererCardDivs[rendererCards.length]);
          newCard.cardCode = cardID;
          rendererCards.add(newCard);
        }
      }
    }

    // Resolve bet
    if (getBet() != rendererBetAmount) {
      rendererBetAmount = getBet();
    }
    // Resolve credits
    if (getCredits() != rendererCreditAmount) {
      rendererCreditAmount = getCredits();
    }
  }

  bool equals(BJLogicPlayer other) {
    return this.playerEntity.userName == other.playerEntity.userName;
  }
}
