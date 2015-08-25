# jedi

The jedi R package is intended to help R programmers who work with Salesforce. By using the Force.com REST API, jedi provides a quick, but powerful, way to access Salesforce information. For more details about the Force.com REST API, please following this [link](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_what_is_rest_api.htm).

## Authentication Disclaimer
The following next section, "Understanding Authentication", is borrowed from the [Salesforce API documentation](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_authentication.htm), all credit for the content goes to Salesforce. Unlike the [RForcecom](https://github.com/hiratake55/RForcecom) package, jedi uses only the Force.com REST API, not a combination of REST and SOAP, and therefore a connected app must be setup in Salesforce. See the next section for more details.

## Understanding Authentication
Salesforce uses the OAuth protocol to allow users of applications to securely access data without having to reveal username and password credentials.
Before making REST API calls, you must authenticate the application user using OAuth 2.0. To do so, you’ll need to:
* Set up your application as a connected app in the Salesforce organization.
* Determine the correct Salesforce OAuth endpoint for your connected app to use.
* Authenticate the connected app user via one of several different OAuth 2.0 authentication flows. An OAuth authentication flow defines a series of steps used to coordinate the authentication process between your application and Salesforce. Supported OAuth flows include:
    * Web server flow, where the server can securely protect the consumer secret.
    * User-agent flow, used by applications that cannot securely store the consumer secret.
    * Username-password flow, where the application has direct access to user credentials.

After successfully authenticating the connected app user with Salesforce, you’ll receive an access token which can be used to make authenticated REST API calls.
