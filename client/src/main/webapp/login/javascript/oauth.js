var get_policy_backend_url = 		'../createAccountPage';

function InitCreateAccount()
{
	getPasswordPolicy();
}


function getPasswordPolicy()
{
	//AJAX call to get the password policy:
	$.ajax({
		url : get_policy_backend_url,
		type: 'GET',
//		dataType: "json",
		success: function(response)
		{
			populateResult(response);
		}
	});
}


function populateResult(response)
{
	if (response.indexOf("OK|") == -1)
		return;
}

//////////////////////////////////////////////////////////////////////////////////////

/*
this.InitPassReq = function()
{
   if (m_PasswordMaxLength != 100)
      return;
   var PasswordMaxLength=100;
   var PasswordMinLength=0;
   var PasswordMinLoCaseLetters=0;
   var PasswordMinNumbers=0;
   var PasswordMinSpecialSymbols=0;
   var PasswordMinUpCaseLetters=0;

   try
   { 
      eval (self.GetPassInstructions().replace(/\|/g,";"));    

      m_PasswordMaxLength=PasswordMaxLength;
      m_PasswordMinLength=PasswordMinLength;
      m_PasswordMinLoCaseLetters=PasswordMinLoCaseLetters;
      m_PasswordMinNumbers=PasswordMinNumbers;
      m_PasswordMinSpecialSymbols=PasswordMinSpecialSymbols;
      m_PasswordMinUpCaseLetters=PasswordMinUpCaseLetters;
    } 
   catch (e) {}
}
*/

function setEnc()
{
	// put the url parameters in an array (split by &)
	var ar = location.search.split('&');

	// remove the ? from the first option if there is an parameter
	if(ar.length > 0)ar[0] = ar[0].substring(1, ar[0].length);

	// make a reference to the form
	var f = document.getElementById('f');
	// loop the array we just created by splitting the location.search
	for(var i = 0; i < ar.length; i++){

		// check if the parameter has a value
		if(ar[i].indexOf('=') != -1){
			// get the parametername
			var parametername = ar[i].substring(0, ar[i].indexOf('='));

			// get the parametervalue
			var parametervalue = ar[i].substring(ar[i].indexOf('=') + 1, ar[i].length);

			// check if the form input exists
			if(typeof f[parametername] != 'undefined'){

				// set the form value
				f[parametername].value = unescape(parametervalue);
			}
		}
	}
}