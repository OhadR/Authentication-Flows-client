Authentication-Flows
====================

This project is a web-app client, that writen on top of Spring Security, and uses the "authentication-flows" 
JAR. The  "authentication-flows" project is here (under oAuth sample):
https://github.com/OhadR/oAuth2-sample/tree/master/authentication-flows
The Authentication-Flows has its own dependencies; read about it in its own README.

The Authentication-Flows JAR implements all authentication flows: 
* create account, 
* forgot password, 
* change password by user request, 
* force change password if password is expired,
* locks the accont after pre-configured login failures.

NOTE: Spring's generic login form is not good enought, since it lacks links as "register" and "forgot password".
So the client has its own login page, as well as other required forms. These forms can be found [in this project](client/src/main/webapp/login/)
The client, which is a WAR, includes the HTMLs and JSPs, under webapp/login directory. These html and JSPs forms
submits to a URL that the authentication-flows JAR responds to.

To make it serious, authentication-flows JAR uses cryptography in order to encrypt the data in the links that are sent to the user's email, 
upon user's registration and "forget password" flows.


Client's [Spring-Beans.XML](client/src/main/webapp/WEB-INF/spring-servlet.xml)
===========================
Component-Scan
--------------
the XML should contain to the component-scan path the following paths:
<pre>
com.ohadr.auth_flows.*
com.ohadr.crypto.*
</pre>

password encoder
----------------
add bean in the spring XML. it is in use in the `UserActionController`.

```xml
	<sec:authentication-manager alias="authenticationManager">
		<sec:authentication-provider user-service-ref="userDetailsService" >
			<sec:password-encoder hash="sha-256">
				<sec:salt-source user-property="username"/>
			</sec:password-encoder>
		</sec:authentication-provider>
	</sec:authentication-manager>

	<bean id="passwordEncoder" 	class="org.springframework.security.authentication.encoding.ShaPasswordEncoder">
		<constructor-arg value="256"/>
	</bean>
```

authentication success handler
------------------
add this to the `<form-login>` block:
<pre>
	authentication-success-handler-ref="authenticationSuccessHandler"
</pre>
after a successful login, we need to check whether the user has to change hos password (if it is expired).

Database
========
need to declare on dataSource bean, that is the connection to the DB.
The connection properties are in client.properties.
The client is responsible for creating a schema named 'auth-flows' in the DB. In this schema, there are tables,
created using the following scripts:

TABLE: policy
------------------
<pre>
CREATE TABLE `policy` (
  `POLICY_ID` int(10) unsigned NOT NULL,
  `PASSWORD_MIN_LENGTH` int(11) DEFAULT NULL,
  `PASSWORD_MAX_LENGTH` int(11) DEFAULT NULL,
  `PASSWORD_MIN_UPCASE_CHARS` int(11) DEFAULT NULL,
  `PASSWORD_MIN_LOCASE_CHARS` int(11) DEFAULT NULL,
  `PASSWORD_MIN_NUMERALS` int(11) DEFAULT NULL,
  `PASSWORD_MIN_SPECIAL_SYMBOLS` int(11) DEFAULT NULL,
  `PASSWORD_BLACKLIST` longtext,
  `MAX_PASSWORD_ENTRY_ATTEMPTS` int(11) DEFAULT NULL,
  `PASSWORD_LIFE_IN_DAYS` int(11) DEFAULT NULL,
  `REMEMBER_ME_VALIDITY_IN_DAYS` int(11) DEFAULT NULL,
  PRIMARY KEY (`POLICY_ID`)
)
</pre>

TABLE: users
------------
<pre>
CREATE  TABLE `auth-flows`.`users` (
  `USERNAME` VARCHAR(50) NOT NULL ,
  `PASSWORD` VARCHAR(100) NOT NULL ,
  `ENABLED` TINYINT(1)  NOT NULL DEFAULT 1 ,
  `LOGIN_ATTEMPTS_COUNTER` INT NOT NULL DEFAULT 0,
  `LAST_PSWD_CHANGE_DATE` DATETIME NOT NULL, 
  PRIMARY KEY (`USERNAME`) ,
  UNIQUE INDEX `idusers_UNIQUE` (`USERNAME` ASC) 
  )
</pre>
  
It is used by `JdbcAuthenticationAccountRepositoryImpl` class.

Important note: in `JdbcUserDetailsManager`, Spring expects the table-name is 'user', and that 
a column called 'username' for the authentication exists. Unless a derived class changes it, these values
must remain.
In my solution I try to keep it simple and stay as close as I can to Spring' implementation, so even though
I wanted the column name to be 'email' - I had to rename it back to 'username' in order to stay as close
as possible to Spring.

In `DaoAuthenticationProvider.additionalAuthenticationChecks()`, Spring checks the password the 
user entered, in front of the one in the DB. It calls to `passwordEncoder.isPasswordValid()`.
IT gets there only AFTER the check that user exists in 'user' table, *and in 'authorities' table*.

Since we use Spring's 'username' column name in the DB (and not 'email' as planned), it is important to
know that we expect the username to be the email of the user. we count on it by sending email to this 
address.

upon login, Spring makes the checks of creds, and some checks before and some after.
before: AbstractUserDetailsAuthenticationProvider.authenticate(), there are the checks. then
there is a call to <code>preAuthenticationChecks.check(user)</code>. There, Spring checks the
account is non-locked, enabled, and non-expired.
after: Spring checks that the account credentials are non-expired. this is great for implementations
that forces the user to change his password once in a while.

IMPORTANT: in Spring, once the account is locked, or disabled, etc - the "Authentication Failure Listener"
will not be called! (in my old algorith, I handled the 'locks', so as far as Spring concerned, the account
was never locked, or password was never expired.


Remember-Me
-----------
the "remember me" feature is *not* implemented here, since it does not serve the purpose of the authentication
flows. it is possible to read from the "policy" table that value that indicates for how long the "remember
me" cookie will be valid, but it is up to the developer to decide whether to implement it or not.
I assume the user knows how to use Spring's Remember-Me feature, otherwise read the documentations. But for a short
summary:

1. in the client's [beans.xml](client/src/main/webapp/WEB-INF/spring-servlet.xml) add the remember me tag:

```xml
	<security:remember-me 
			data-source-ref="dataSource"
			user-service-ref="userDetailsService"/>
```

2. in the <code>UserActionController.java</code>, uncomment the lines:

<pre>	
	@Autowired
	private AbstractRememberMeServices rememberMeService;</pre>

3. then, in UserActionController.java, 

<pre>	//read the value from the policy (from the DB):
	int rememberMeTokenValidityInDays = settings.getRememberMeTokenValidityInDays();

	//get the "remem-me" bean and update its validity:
	rememberMeService.setTokenValiditySeconds(rememberMeTokenValidityInDays * 60 * 60 * 24);</pre>

and you are ready to go. 


Registration Flow (Create Account)
==================================
TBD

Forgot Password Flow
====================
Currently, the user clicks on "Forgot Password", enters his password and the system generates and sends 
an email with restore-link. There are security issues that might arise here, such as how can we make sure
that this is the 'real' user? for these cases, some implementations can add a mechanism of "secret question".
In this example, I did not support this, in order to simplify the solution.

Redirect URI:
big role in authentication, lets the server know where to redirect the user to.
In this example, I did not support this, in order to simplify the solution.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/OhadR/authentication-flows/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

