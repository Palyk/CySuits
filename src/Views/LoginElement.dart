import 'dart:html';

class LoginElement {
  ImageElement profile;
  InputElement username;
  InputElement password;
  InputElement confirmPass;
  ButtonElement submit;
  ButtonElement register;
  DivElement parent;
  int failedLogin;
  int failedRegister;
  DivElement failedLoginDiv;
  DivElement failedRegisterDiv;

  LoginElement(DivElement parent) {
    this.parent = parent;
    profile = new ImageElement();
    username = new InputElement();
    password = new InputElement();
    confirmPass = new InputElement();
    submit = new ButtonElement();
    register = new ButtonElement();
    failedLogin = 0;
    failedRegister = 0;
    failedLoginDiv = new DivElement();

    failedLoginDiv.text = "Login Failed. Please try again";
    failedRegisterDiv = new DivElement();
    failedRegisterDiv.text = "Passwords do not match, please try again";
    profile.setAttribute('src', '../resources/icons/defprofile.jpg');
    profile.setAttribute('id', 'Title');

    username.setAttribute('placeholder', 'username');
    username.setAttribute('id', 'Username');

    password.setAttribute('placeholder', 'password');
    password.setAttribute('id', 'Password');

    submit.setAttribute('id', 'Submit');
    submit.text = 'Login';

    register.setAttribute('id', 'Register');
    register.text = 'Register';

    parent.children.add(profile);
    parent.children.add(username);
    parent.children.add(password);
    parent.children.add(submit);
    parent.children.add(register);
  }

  void render(){
    if(failedLogin==1){
      parent.children.add(failedLoginDiv);
    }else{
      failedLoginDiv.remove();
    }
    if(failedRegister == 1) {
      parent.children.add(failedRegisterDiv);
    }
    else {
      failedRegisterDiv.remove();
    }
  }
}
