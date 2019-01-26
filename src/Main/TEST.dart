import 'dart:html';
import '../Controller/Renderer.dart';
import '../Controller/Logic/SolitaireLogic.dart';
import '../Controller/EntityManager.dart';
import '../Entities/Solitaire/SolitaireState.dart';
import '../Views/ChatBoxElement.dart';
import '../Views/SolitaireElement.dart';
import '../Views/CardElement.dart';
import '../Controller/CardList.dart';

Renderer r;
EntityManager em;
DivElement parent = querySelector("main");
SolitaireLogic  soli;
void main(){


  r = new Renderer(parent);
  em = new EntityManager();
  soli = new SolitaireLogic(em,r);
  em.solitaireState = new SolitaireState();
  r.solitaireElementDiv = new DivElement();
  r.solitaireElement = new SolitaireElement(r.solitaireElementDiv);
/*
  r.solitaireElement.tableuList = new List();
  r.solitaireElement.tableuList.add(new List());


  r.solitaireElement.tableuList[0].add( new CardElement(r.solitaireElement.tableuDivs[0]));
  r.solitaireElement.tableuList[0][0].cardCode = 2;
  r.solitaireElement.tableuList[0][0].hidden = true;
*/
  r.render();



}