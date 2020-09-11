# Cypress Advanced Topics
#### Mohsen Asfia
##### Service Delivery - Container Flow Optimization
##### Ace (Automated Cargo Execution)



### Service Delivery
<img src="service-delivery.jpg" alt="drawing" width="600"/>


<img src="cake.jpeg" alt="drawing" width="400"/>



## What happened last time?
- Cypress Overview
- How to Setup?
- Cypress Project Structure
- Cypress Common Commands
- Cypress Advanced Commands
- Tricks to More Efficient Selectors
- Aliases


- Custom Commands
- Cypress & Command Line
- Page Object Model
- Fixtures
- Interaction with Files
- Testing APIs
- Cypress UI



## What's in the menu this time?
- Authenticating Via Azure/AD
- Integration with Cucumber
- Generating The Environment Configs From CI Pipeline
- Caching Cypress Binary In CI Pipeline



## Authenticating Via Azure/AD
``` [11]
cypress   
└───fixtures
│   │   credentials.json
└───integration
│   │   login-page.spec.ts
└───plugins
└───support
└───videos
└───page-objects
|   cypress.json
|   cypress.env.json
|   cypress-config-generator.js
```


### cypress.env.json
```js [1-14|10-13]
{
  "adalConfig": {
    "instance": "https://login.microsoftonline.com",
    "tenantId": "Your Tenant ID!!",
    "clientId": "Your Client ID",
    "clientSecret": "Your Client Secret",
    "redirectUri": "http://localhost:4200",
    "cacheLocation": "sessionStorage"
  },
  "credentials": {
    "username": "e2e user name",
    "password": "e2e password"
  }
}
```


### Consuming The Environment Configs
```js  [1-21|2-4|6|9|11-18|19|23-33]
Cypress.Commands.add('login', () => {
  const adalConfig = Cypress.env('adalConfig');
  const userCredentials = Cypress.env('credentials');
  const authContext = new (window as any).AuthenticationContext(adalConfig);

  if (!authContext.getCachedToken(adalConfig.clientId)) {
    cy.request({
      method: 'POST',
      url: `https://login.microsoftonline.com/${adalConfig.tenantId}/oauth2/token`,
      form: true,
      body: {
        grant_type: 'password',
        client_id: adalConfig.clientId,
        client_secret: adalConfig.clientSecret,
        resource: adalConfig.clientId,
        password: userCredentials.password,
        username: userCredentials.username
      }
    }).then((response) => authenticate(response, authContext, adalConfig));
  }
});

const authenticate = (response, authContext, adalConfig) => {
  authContext._saveItem(
    `${authContext.CONSTANTS.STORAGE.ACCESS_TOKEN_KEY}${adalConfig.clientId}`,
    response.body[authContext.CONSTANTS.ACCESS_TOKEN]
  );
  authContext._saveItem(authContext.CONSTANTS.STORAGE.IDTOKEN, response.body[authContext.CONSTANTS.ACCESS_TOKEN]);
  authContext._saveItem(`${authContext.CONSTANTS.STORAGE.EXPIRATION_KEY}${adalConfig.clientId}`, response.body.expires_on);
  authContext._saveItem(authContext.CONSTANTS.STORAGE.TOKEN_KEYS, `${adalConfig.clientId}${authContext.CONSTANTS.RESOURCE_DELIMETER}`);
};
```



## Generating The Environment Configs From CI Pipeline
``` [12]
cypress   
└───fixtures
│   │   credentials.json
└───integration
│   │   login-page.spec.ts
└───plugins
└───support
└───videos
└───page-objects
|   cypress.json
|   cypress.env.json
|   cypress-config-generator.js
```


```js [1-29|5|8-22|10-17|18-21|29]
const fs = require('fs');
const path = require('path');

// Fetch the sample file
const config = fs.readFileSync(path.join(__dirname, './cypress.env.json'), { encoding: 'utf8' });

let configJson = JSON.parse(config);
configJson = {
  ...configJson,
  adalConfig: {
    instance: process.env.instance,
    tenantId: process.env.tenantId,
    clientId: process.env.clientId,
    clientSecret: process.env.clientSecret,
    redirectUri: process.env.redirectUri,
    cacheLocation: process.env.cacheLocation
  },
  credentials: {
    username: process.env.username,
    password: process.env.password
  }
};

// Logging the config
if (process.env.VERBOSE) {
  console.log(configJson);
}

fs.writeFileSync(path.join(__dirname, './cypress.env.json'), JSON.stringify(configJson, null, 2));
```


### Finally Running The Node Module in The CI Pipeline
```yml [1-13|2|5-13]
- script: |
    node apps/foo-app/cypress-config-generator.js
  displayName: 'Generate the Cypress config'
  workingDirectory: '.'
  env:
    username: $(EMAIL)
    password: $(PASSWORD)
    instance: $(Instance)
    tenantId: $(TenantId)
    clientId: $(ClientId)
    clientSecret: $(lientSecret)
    redirectUri: $(RedirectUrl)
    cacheLocation: $(CacheLocation)
```



## Caching Cypress Binary In CI Pipeline
```yml [1-41|1-7|4|5|6|7|8-16|10|17-22|20|21|22|23-35|36-41]
- task: Cache@2
  displayName: 'Cache NPM Modules'
  inputs:
    key: npm_modules | $(Agent.OS)| $(System.DefaultWorkingDirectory)/package-lock.json
    path: $(System.DefaultWorkingDirectory)/node_modules
    restoreKeys: npm_modules | $(Agent.OS)| $(System.DefaultWorkingDirectory)/package-lock.json
    cacheHitVar: CACHE_RESTORED
- task: Npm@1
  displayName: 'NPM Install'
  condition: ne(variables.CACHE_RESTORED, 'true')
  inputs:
    command: 'install'
    workingDir: '.'
    verbose: false
    customRegistry: 'useFeed'
    customFeed: '48010dce-d8fb-4c8a-8318-b81fe4c8a42a'
- task: Cache@2
  displayName: 'Cache Cypress Binary'
  inputs:
    key: cypress | $(Agent.OS) | $(System.DefaultWorkingDirectory)/node_modules/cypress/package.json
    path: /home/vsts/.cache/Cypress
    restoreKeys: cypress | $(Agent.OS) | $(System.DefaultWorkingDirectory)/node_modules/cypress/package.json
- script: |
    node apps/foo-app/cypress-config-generator.js
  displayName: 'Generate the Cypress config'
  workingDirectory: './ui/src'
  env:
    username: $(E2E_EMAIL)
    password: $(E2E_PASSWORD)
    instance: $(AuthenticationInstance)
    tenantId: $(TenantId)
    clientId: $(ClientId)
    clientSecret: $(ClientSecret)
    redirectUri: $(RedirectUrl)
    cacheLocation: $(CacheLocation)
- task: Npm@1
  displayName: 'Run Cypress E2E Tests'
  inputs:
    command: custom
    customCommand: run e2e:ci:foo-app
    workingDir: './ui/src'
```



## Integration with Cucumber
```bash
npm install cypress-cucumber-preprocessor
```


### In package.json
```js
"cypress-cucumber-preprocessor": {
  "nonGlobalStepDefinitions": true,
  "stepDefinitions": "./src/integration"
}
```


### In cypress.json
```js [16]
{
  "fileServerFolder": ".",
  "fixturesFolder": "./src/fixtures",
  "integrationFolder": "./src/integration",
  "pluginsFile": "./src/plugins/index.js",
  "supportFile": "./src/support/index.ts",
  "video": true,
  "videosFolder": "../../dist/cypress/apps/foo-app/videos",
  "screenshotsFolder": "../../dist/cypress/apps/foo-app/screenshots",
  "reporter": "junit",
  "reporterOptions": {
    "mochaFile": "../../test-unit-reports/junit-foo-app.xml",
    "toConsole": true,
    "attachments": true
  },
  "testFiles": "**/*.feature",
  "chromeWebSecurity": false,
  "viewportWidth": 1504,
  "viewportHeight": 1002
}
```


``` [1-19|3-12|4-5|6-12|11|7-8]
cypress   
└───fixtures
└───integration
    └───common
|   |   common.ts
    └───search
        change-loc-filter
|   |   |   change-loc-filter.spec.ts        
        change-port-filter
|   |   |   change-port-filter.spec.ts
|   |   change-loc-filter.feature
|   |   change-port-filter.feature
└───plugins
└───support
└───videos
└───page-objects
|   cypress.json
|   cypress.env.json
|   cypress-config-generator.js
```

Note:
- cypress/integration. Will contain all .feature files then as a sibling there’s folder with the same name of the feature. File that will contain the .js step definition file


### In a ".feature" file
```js
Feature: As a user, I want to filter search results by a brand code

    Background: User is logged in and has navigated to the search overview (results) page

    Scenario: Show the results in the list
        Given I open the port call overview page
        When I type mmc into the brands input and press Enter
        Then Every port call item in the results section should contain the selected regional brand in their href as a query param
```


### In the corresponding spec file
```js
import { Then, When } from 'cypress-cucumber-preprocessor/steps';
import { OverviewPage } from '../../../page-objects';

Given(`I open the port call overview page`, () => {
  OverviewPage.visit();
});

When(`I type mmc into the brands input and press Enter`, () => {
  OverviewPage.typeInBrandsFiilter('mmc {enter}');
});

Then(`Every port call item in the results section should contain the selected regional brand in their href as a query param`, () => {
  OverviewPage.getFirstPortCallResultItem()
    .should('have.attr', 'href')
    .and('match', /regionalBrands=code:MCC/);
});
```


### Parametrizing the feature files


#### Supplying a single value


##### In feature file
```js [7]
Feature: As a user, I want to filter search results by a city

    Background: User is logged in and has navigated to the front page

    Scenario: Show the results in the list
        Given I open the search page
        When I type "copenhagen" into the brands input and press Enter
        Then Every result item in the results section should belong to "copenhagen"
```


##### In the step definition file
```js [8-10]
import { Then, When } from 'cypress-cucumber-preprocessor/steps';
import { SearchPage } from '../../../page-objects';

Given(`I open the search page`, () => {
  SearchPage.visit();
});

When(`I type {string} into the brands input and press Enter`, (city) => {
  SearchPage.typeInCitiesFiilter(`${city} {enter}`);
});

Then(`Every result item in the results section should belong to {string}`, (city) => {
  SearchPage.allResultItemsShouldBelongTo(city);
});
```


#### Supplying a data table


##### In feature file
```js [7-9]
Feature: Login

    I want to log into the website

    Scenario: Website login
        Given I open the login page
        When I type in
          | username | password |
          | mohsen | foobar |
        And I click on sign in button
        Then The front page should be shown
```


##### In the step definition file
```js [8-13]
import { Then, When } from 'cypress-cucumber-preprocessor/steps';
import { LoginPage, FrontPage } from '../../../page-objects';

Given(`I open the login page`, () => {
  LoginPage.visit();
});

When(`I type in`, (credentials) => {
  credentials.hashes().forEach((credential) => {
    cy.get('[data-test-username]').type(credential.username);
    cy.get('[data-test-password]').type(credential.password);
  });
});

When('I click on sign in button', () {
  cy.get('[data-test-log-in-button]').click();
});

Then(`The front page should be shown`, (city) => {
  FrontPage.isVisible()
});
```


### Debugging the feature files with tags


##### Run a specific tag
```js [5]
Feature: As a user, I want to filter search results by a brand code

    Background: User is logged in and has navigated to the search overview (results) page

    @brandFilter
    Scenario: Show the results in the list
        Given I open the port call overview page
        When I type mmc into the brands input and press Enter
        Then Every port call item in the results section should contain the selected regional brand in their href as a query param
```


```bash
npx cypress-tags run -e TAGS='@brandFilter'
```


```bash
npx cypress-tags run -e TAGS='not @brandFilter'
```


```bash
npx cypress-tags run -e TAGS='@brandFilter and not @ui'
```



## Thank you for your time and feel free to reach out if you have any questions :-)
##### Reach me on Slack @mohsen asfia 