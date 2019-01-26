// CardList is a non-object oriented file holding constants and functions
// revolving around cards as a utility.
const FaceDown = -1;

const AceClubs = 0;
const AceDiamonds = 1;
const AceHearts = 2;
const AceSpades = 3;

const TwoClubs = 4;
const TwoDiamonds = 5;
const TwoHearts = 6;
const TwoSpades = 7;

const ThreeClubs = 8;
const ThreeDiamonds = 9;
const ThreeHearts = 10;
const ThreeSpades = 11;

const FourClubs = 12;
const FourDiamonds = 13;
const FourHearts = 14;
const FourSpades = 15;

const FiveClubs = 16;
const FiveDiamonds = 17;
const FiveHearts = 18;
const FiveSpades = 19;

const SixClubs = 20;
const SixDiamonds = 21;
const SixHearts = 22;
const SixSpades = 23;

const SevenClubs = 24;
const SevenDiamonds = 25;
const SevenHearts = 26;
const SevenSpades = 27;

const EightClubs = 28;
const EightDiamonds = 29;
const EightHearts = 30;
const EightSpades = 31;

const NineClubs = 32;
const NineDiamonds = 33;
const NineHearts = 34;
const NineSpades = 35;

const TenClubs = 36;
const TenDiamonds = 37;
const TenHearts = 38;
const TenSpades = 39;

const JackClubs = 40;
const JackDiamonds = 41;
const JackHearts = 42;
const JackSpades = 43;

const QueenClubs = 44;
const QueenDiamonds = 45;
const QueenHearts = 46;
const QueenSpades = 47;

const KingClubs = 48;
const KingDiamonds = 49;
const KingHearts = 50;
const KingSpades = 51;

const Joker = 52;

// This will only ever be used for printing purposes
// during testing. So it only exists in one place.
List<String> cardNames = [
  "ace_of_clubs",
  "ace_of_diamonds",
  "ace_of_hearts",
  "ace_of_spades",
  "2_of_clubs",
  "2_of_diamonds",
  "2_of_hearts",
  "2_of_spades",
  "3_of_clubs",
  "3_of_diamonds",
  "3_of_hearts",
  "3_of_spades",
  "4_of_clubs",
  "4_of_diamonds",
  "4_of_hearts",
  "4_of_spades",
  "5_of_clubs",
  "5_of_diamonds",
  "5_of_hearts",
  "5_of_spades",
  "6_of_clubs",
  "6_of_diamonds",
  "6_of_hearts",
  "6_of_spades",
  "7_of_clubs",
  "7_of_diamonds",
  "7_of_hearts",
  "7_of_spades",
  "8_of_clubs",
  "8_of_diamonds",
  "8_of_hearts",
  "8_of_spades",
  "9_of_clubs",
  "9_of_diamonds",
  "9_of_hearts",
  "9_of_spades",
  "10_of_clubs",
  "10_of_diamonds",
  "10_of_hearts",
  "10_of_spades",
  "jack_of_clubs",
  "jack_of_diamonds",
  "jack_of_hearts",
  "jack_of_spades",
  "queen_of_clubs",
  "queen_of_diamonds",
  "queen_of_hearts",
  "queen_of_spades",
  "king_of_clubs",
  "king_of_diamonds",
  "king_of_hearts",
  "king_of_spades",
  "red_joker"
];

// cardValue takes a cardID and converts it to it's numerical value.
// Aces are always returned as 1, face cards as 10.
int cardValue(int cardID) {
  // Early out for face down cardID
  if (cardID < 0) {
    return FaceDown;
  }
  int cardValue = (cardID ~/ 4) + 1;
  if (cardValue > 10) {
    cardValue = 10;
  }
  return cardValue;
}

// Quick conversion of a cardID into a readable name.
// Should only be used for testing.
String cardName(int cardID) {
  if (cardID < 0) {
    return "Face Down";
  } else if (cardID > 52) {
    return "Invalid Card";
  }
  return cardNames[cardID];
}
