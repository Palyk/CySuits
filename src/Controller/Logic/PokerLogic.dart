import 'dart:math';
import 'dart:html';

import '../../Controller/Renderer.dart';
import '../../Controller/EntityManager.dart';
import '../../Entities/Player.dart';

class Poker {
  EntityManager em;
  Renderer r;

  Poker(EntityManager em, Renderer r) {
    this.em = em;
    this.r = r;

    initGame(); // FIXME: do I need to call this here?
  }

  void run() {
    if (em.flush_gameState != 0) {
      return;
    }
    // TODO: compare game state with renderer, update when necessary
  }

  void initGame() {/*TODO*/}

  bool deal() {
    // TODO
    return false;
  }

  void ante(Event e) {
    if (em.gameState.playerCurrent != null) {
      // Placing an ante is currently unavailable
      return;
    }
    // TODO
  }

  void check(Event e) {
    if (em.user.userName != em.gameState.playerCurrent.userName) {
      // Not this player's turn
      return;
    }

    if (em.gameState.betToMatch == 0) {
      // TODO: nextPlayer()
      return;
    }
    // Cannot check if there is a bet to match
    // TODO: render element to inform the user
  }

  void bet(Event e) {
    if (em.user.userName != em.gameState.playerCurrent.userName) {
      // Not this player's turn
      return;
    }

    // TODO: Render something to retrieve bet amount, validate the bet amount
    int betAmount = -1;

    // Make sure bet is valid
    if (betAmount < em.gameState.minimumBet || betAmount > em.gameState.maxBet) {
      // TODO: render element to inform the user
      return;
    } else if (em.gameState.pot + betAmount > em.gameState.potLimit) {
      // TODO: render element to inform the user
      return;
    } else if (em.gameState.playerCurrent.credits < betAmount) {
      // TODO: render element to inform the user
      return;
    }

    if (em.gameState.betToMatch == 0) {
      // This player is the first bettor of the round
      em.gameState.betToMatch = betAmount;
      em.gameState.playerCurrent.credits -= betAmount;
    } else if (em.gameState.betToMatch == betAmount) {
      // This player is Calling
      em.gameState.playerCurrent.credits -= betAmount;
    } else if (em.gameState.betToMatch < betAmount) {
      // This player is Raising
      em.gameState.betToMatch == betAmount;
      em.gameState.playerCurrent.credits -= betAmount;
    } else {
      // The bet amount must at least match the betToMatch
      // TODO: render element to inform the user
      return;
    }
    // TODO: nextPlayer()
    em.flush_gameState = 1;
  }

  void fold(Event e) {
    if (em.user.userName != em.gameState.playerCurrent.userName) {
      // Not this player's turn
      return;
    }

    lose(em.gameState.playerCurrent);
    em.flush_gameState = 1;
  }

  void win(Player player) {
    // TODO
  }

  void lose(Player player) {
    // TODO
    // set inGame to false
    // remove player from the rotation
    // nextPlayer()
  }

  bool showdown() {
    // TODO
    return false;
  }

  List<int> shuffle(List<int> cards) {
    if (cards == null) {
      return null;
    }

    Random rand = new Random();
    for (int i = cards.length - 1; i > 0; i--) {
      int index = rand.nextInt(i + 1);

      // Swap
      int temp = cards[index];
      cards[index] = cards[i];
      cards[i] = temp;
    }
    return cards;
  }

  void reset() {
    initGame();
  }
}

class PokerAI {
  // TODO: keep this light
}
