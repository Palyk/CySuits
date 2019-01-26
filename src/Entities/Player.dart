class Player{
  int id;           // Player's ID used to match with a User
  String userName;  // Player's username
  int credits;      // Player's credit amount

  List<int> hand;  // Player's current hand
  int turn;         // Player's turn
  int bet;          // Player's current bet amount
  bool inGame;      // Whether or not the Player is participating

  // These items are Black Jack specific
  bool canDoubleDown;   // Black Jack - Can the Player double down?
  bool hasDoubledDown;  // Black Jack - Has the Player doubled down?
  int insurance;        // Black Jack - Player's current insurance bet amount
  bool canInsurance;    // Black Jack - Is the Player participating?
}

