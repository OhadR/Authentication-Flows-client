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


Database
========
need to declare on dataSource bean, that is the connection to the DB.
The connection properties are in client.properties.
The client is responsible for creating a schema named 'auth-flows' in the DB. In this schema, there are tables,
created using the following scripts:

TABLE: auth-policy
------------------
< script >

TABLE: users
------------
CREATE  TABLE `auth-flows`.`users` (
  `USERNAME` VARCHAR(50) NOT NULL ,
  `PASSWORD` VARCHAR(100) NOT NULL ,
  `ENABLED` TINYINT(1)  NOT NULL DEFAULT 1 ,
  `LOGIN_ATTEMPTS_COUNTER` INT NOT NULL,
  `LAST_PSWD_CHANGE_DATE` DATETIME NOT NULL, 
  PRIMARY KEY (`USERNAME`) ,
  UNIQUE INDEX `idusers_UNIQUE` (`USERNAME` ASC) )
  
It is used by JdbcAuthenticationAccountRepositoryImpl class.

Important note: in JdbcUserDetailsManager, Spring expects the table-name is 'user', and the 
column 'username' for the authentication rxists. Unless a derived class changes it, these values
must remain.
In my solution I try to keep it simple and stay as close as I can to Spring' implementation.

In DaoAuthenticationProvider.additionalAuthenticationChecks(), Spring checks the password the 
user entered, in front of the one in the DB. It calls to passwordEncoder.isPasswordValid().
IT gets there only AFTER the check that user exists in 'user' table, *and in 'authorities' table*.

Since we use Spring's 'username' column name in the DB (and not 'email' as planned), it is important to
know that we expect the username to be the email of the user. we count on it by sending email to this 
address.


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
