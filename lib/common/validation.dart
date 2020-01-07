
class Validation {

  //  VALIDATION  START
  String validateEmail(String value)
  {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
//  String validatePassword(String value)
//  {
//    if(value.length < 8)
//    {
//      return "Password must be of 8 digit";
//    }
//    else
//    {
//      return null;
//    }
//  }

  String loginEmail(String value)
  {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please Enter Validate Email Address';
    else
      return null;
  }
  String loginPassword(String value)
  {
    if(value.length < 2)
    {
      return "Please Enter Registered Password";
    }
    else
    {
      return null;
    }
  }


//  VALIDATION  END
}
