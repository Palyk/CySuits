import 'dart:html';
import '../Controller/CardList.dart';

//use this class as a base for building all other custom elements we use.
class CardElement {
  int cardCode;

  ImageElement cardImage;
  DivElement parent;
  bool hidden;
  bool horizontal;
  bool blank;
  //place all needed elements and variables here. no getters and setters required
  //all sub elements are also here

  CardElement(DivElement parentDiv) {
    //this is your constructor. Make sure to initialize any default values and ALL Element type objects. Get it set up so that something is on the screen and filled with default values.
    //also be sure to add all the Element stuff to the children of this.
    this.parent = parentDiv;
    this.cardCode = cardCode;
    this.blank = false;
    hidden = true;
    horizontal = false;
    cardImage = new ImageElement();
    cardImage

      ..setAttribute('src', '../resources/cards/hidden.jpg')

      ..setAttribute('class', 'card')
      ..style.setProperty('height', '100px')
      ..style.setProperty('width', '50px');
    parent.children.add(cardImage);
  }

  void render() {
    //this method is called on every tick. This method uses the variables to set attributes of the Elements in this.children

    if (blank) {
      cardImage.setAttribute('src', '../resources/cards/blank.png');
    } else if(hidden) {
      cardImage.setAttribute('src', '../resources/cards/hidden.jpg');
    } else {
      cardImage.setAttribute('src', '../resources/cards/${cardName(cardCode)}.png');

    }
  }
}
