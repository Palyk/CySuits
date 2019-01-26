import 'dart:html';
import '../Views/CardElement.dart';
import '../Controller/Renderer.dart';
import '../Controller/EntityManager.dart';
import '../Entities/User.dart';
import 'dart:convert';


void login(Event e) {
  HttpRequest request = new HttpRequest();

  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE) {
	print(request.responseText);
      var data = JSON.decode(request.responseText);
      querySelector('#t_username').text = data['username'];
      querySelector('#t_currency').text = data['currency'];
      querySelector('#currency')..setAttribute('value',data['currency'])
        ..attributes.remove('hidden');
      querySelector('#t_user').attributes.remove('hidden');
	querySelector('#submit').onClick.listen(updateCurrency);
    }
  });

  var url = "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/login.php";
  request.open("POST", url, async: false);

  InputElement iusername = querySelector('#username');
  var username = iusername.value;
  InputElement ipassword = querySelector('#password');
  var password = ipassword.value;
  String jsonData = '{"username":"${username}","password":"${password}"}';
  request.send(jsonData);
}


void updateCurrency(Event e) {
  HttpRequest request = new HttpRequest();

  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE) {
      var data = JSON.decode(request.responseText);
      querySelector('#t_username').text = data['username'];
      querySelector('#t_currency').text = data['currency'];
      querySelector('#currency').setAttribute('value',data['currency']);
      querySelector('#submit').onClick.listen(updateCurrency);
    }
  });

  var url = "http://proj-309-dk-01.cs.iastate.edu/cysuits-kihlken/DK-01-CySuits/public/api/login.php";
  request.open("POST", url, async: false);

  InputElement iusername = querySelector('#username');
  var username = iusername.value;
  InputElement ipassword = querySelector('#password');
  var password = ipassword.value;
  InputElement icurrency = querySelector('#currency');
  var currency = icurrency.value;
  String jsonData = '{"username":"${username}","password":"${password}","currency":"${currency}"}';
  request.send(jsonData);
}

void main() {
  querySelector('#submit').onClick.listen(login);
}
