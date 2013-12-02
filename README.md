Authentication-Flows
====================

This project is the client, which is a web-app that uses Spring Security, and uses in addition the "authentication-flows" 
jar. The  "authentication-flows" project is here (under oAuth sample):
https://github.com/OhadR/oAuth2-sample/tree/master/authentication-flows
The Authentication-Flows has its own dependencies; read about it in its own README.

The Authentication-Flows JAR implements all authentication flows: 
create account, 
forgot password, 
change password by user request, 
force change password if password is expired

The client, which is a WAR, should add the HTMLs and JSPs to its project, under webapp/login directory.

This is not a game - I use here cryptography in order to encrypt the data in the links that are sent to the user's email.

NOTE:Spring's generic login.html is not good enought, since it lacks links to the "register" and "forgot password".

Client's Beans.XML
==================
the client must add to the component-scan path the following paths:
com.ohadr.auth_flows.*
com.ohadr.crypto.*

password encoder:
add bean in the spring XML. it is in use in the UAC.


TODO:
remember me - decide what to do

Authentication-Flows: sending email from HTTPS does not work with a self-signed certificate :-(

Forgot Password Flow:
Currently, the user clicks on "Forgot Password", enters his password and the system generates and sends 
an email with restore-link. There are security issues that might arise here, such as how can we make sure
that this is the 'real' user? for these cases, some implementations can add a mechanism of "secret question".
In this example, I did not support this, in order to simplify the solution.

Redirect URI:
big role in authentication, lets the server know where to redirect the user to.
In this example, I did not support this, in order to simplify the solution.
