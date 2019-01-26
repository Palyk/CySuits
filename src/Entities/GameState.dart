import 'Player.dart';

class GameState {
  int id;       // GameState id
  int gameType; // Value corresponding to Black Jack, Poker, etc.

  List<Player> players;   // Player's participating in this GameState
  List<int> dealerHand;  // Dealer for this GameState
  Player playerCurrent;   // Player in the GameState whose turn it is
  int minimumBet;         // Minimum bet amount for this GameState

  Player host; // Player who's computer is responsible for running non-turn based methods
  int timer; // Janky way to keep track of time elapsed

  // These items are Poker specific
  int pot;            // Poker -
  Player bigBlind;    // Poker -
  Player littleBlind; // Poker -
  int betToMatch;
  int maxBet;
  int potLimit;
}