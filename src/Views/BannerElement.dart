import 'dart:html';


class BannerElement {
  DivElement parent;
  HeadingElement titleText;

  BannerElement(DivElement parent) {
    this.parent = parent;
    titleText = new HeadingElement.h1();
    titleText.setAttribute('id', 'TitleText');
    titleText.text = 'CySuits';
    parent.children.add(titleText);
  }

  void render(){

  }
}