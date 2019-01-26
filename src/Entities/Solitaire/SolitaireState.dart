class SolitaireState {
  List<List<int>> tableuUp;
  List<List<int>> tableuDown;
  List<List <int>> foundation;
  List<int> waste;
  List<int> stockpile;
  int score;
  int game_status;
  int id;
  SolitaireState(){
    tableuDown = new List<List>();
    tableuUp = new List<List>();
    foundation = new List<List>();
    waste = new List<int>();
    stockpile = new List<int>();
    score = 0;
    game_status = 0;
  }
}