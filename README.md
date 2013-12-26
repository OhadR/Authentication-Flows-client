Authentication-Flows
====================

This project is a web-app client, that writen on top of Spring Security, and uses the "authentication-flows" 
JAR. The  "authentication-flows" project is [here](https://github.com/OhadR/oAuth2-sample/tree/master/authentication-flows)
(under 'oAuth sample' repository).

The Authentication-Flows has its own dependencies; read about it in [its own README](https://github.com/OhadR/oAuth2-sample).

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


common-crypto
=============
The authentication-flows JAR uses cryptography in order to 
* encrypt the user's password, and 
* encrypt the links that are sent to the user's email, upon user's registration and "forget password" flows.
There is a utility JAR, called "common-crypto" that makes life easier. You can find it
[here](https://github.com/OhadR/oAuth2-sample/tree/master/common-crypto),
and it is also available in [Maven repository](http://search.maven.org/#search%7Cga%7C1%7Ccommon-crypto).
Add this dependency to your POM.xml:

```xml
<dependency>
  <groupId>com.ohadr</groupId>
  <artifactId>common-crypto</artifactId>
  <version>1.1.4</version>
</dependency>
```
Note the version - make sure you use the latest.

Authentication-Flows on Maven Repository
====================

If you do not want to download the source from GitHub (which is recommended), you can use it directly
from maven repository. Add this dependency to your POM.xml:
```xml
<dependency>
  <groupId>com.ohadr</groupId>
  <artifactId>authentication-flows</artifactId>
  <version>1.1.4</version>
</dependency>
```

Note the version - make sure you use the latest.

Configuration
=============
1. Client's [Spring-Beans.XML](client/src/main/webapp/WEB-INF/spring-servlet.xml)
---------------------------
**1.1. Component-Scan**

the XML should contain to the component-scan path the following paths:
<pre>
com.ohadr.auth_flows.*
com.ohadr.crypto.*
</pre>

**1.2. password encoder**

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

**1.3. authentication success handler**

add this to the `<form-login>` block:
<pre>
	authentication-success-handler-ref="authenticationSuccessHandler"
</pre>
after a successful login, we need to check whether the user has to change hos password (if it is expired).

2. Database
----------
need to declare on dataSource bean, that is the connection to the DB.
The connection properties are in client.properties.
The client is responsible for creating a schema named 'auth-flows' in the DB. In this schema, there are tables,
created using the following scripts:

**2.1. TABLE: policy**

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

**2.2. TABLE: users**

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


Registration Flow (Create Account)
==================================
Fully supported. For users: contact me if something is not clear enough.

Forgot Password Flow
====================
Currently, the user clicks on "Forgot Password", enters his password and the system generates and sends 
an email with restore-link. There are security issues that might arise here, such as how can we make sure
that this is the 'real' user? for these cases, some implementations can add a mechanism of "secret question".
In this example, I did not support this, in order to simplify the solution.

Notes
============
Redirect URI
-------------
"Redirect URI" has a big role in authentication, as it lets the server know where to redirect the user to.
The redirect URI *can* be transferred in the registration email, for example so after the registration is finished
and account is activated, the server still knows where to redirect the client to.
*In this example, I did not support this, in order to simplify the solution.*

Remember-Me
-----------
the "remember me" feature is *not* implemented here, since it does not serve the purpose of the authentication
flows. It is possible to read from the "policy" table that value that indicates for how long the "remember
me" cookie will be valid, but it is up to the developer to decide whether to implement it or not.
I assume the user knows how to use Spring's Remember-Me feature, otherwise read the documentations. But for a short
summary:

* in the client's [beans.xml](client/src/main/webapp/WEB-INF/spring-servlet.xml) add the remember me tag:

```xml
	<security:remember-me 
			data-source-ref="dataSource"
			user-service-ref="userDetailsService"/>
```

* in the <code>UserActionController.java</code>, uncomment the lines:

<pre>	
	@Autowired
	private AbstractRememberMeServices rememberMeService;</pre>

* then, in UserActionController.java, 

<pre>	//read the value from the policy (from the DB):
	int rememberMeTokenValidityInDays = settings.getRememberMeTokenValidityInDays();

	//get the "remem-me" bean and update its validity:
	rememberMeService.setTokenValiditySeconds(rememberMeTokenValidityInDays * 60 * 60 * 24);</pre>

and you are ready to go. 

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/OhadR/authentication-flows/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

