import 'dart:html';

class RulesElement {
  HeadingElement title = new HeadingElement.h1();
  ParagraphElement p = new ParagraphElement();
  DivElement parent = querySelector('#menu');

  RulesElement(DivElement parentDiv) {

    title.text = 'Rules:';
    p.text = 'placeholder for all the rules here';
    title.text = 'Rules:';
    p.text = 'placeholder for all the rules here';
    parentDiv.children.add(title);
    parentDiv.children.add(p);
  }
  void render() {
  }
}