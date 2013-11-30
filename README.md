Authentication-Flows
====================

this project is the use case for the "authentication-flows" jar, that its project is here (under oAuth sample)
https://github.com/OhadR/oAuth2-sample/tree/master/authentication-flows

this JAR implements all authentication flows: create account, forgot password, change password, etc.

the client uses the HTMLs in the project.
the login.html is not good - it does not contain the links to the "register" ans "forgot password".

the client must add to the component-scan path the following paths:
com.ohadr.auth_flows.*
com.ohadr.crypto.*


remember me - decide what to do

password encoder:
add bean in the spring XML. it is in use in the UAC.


