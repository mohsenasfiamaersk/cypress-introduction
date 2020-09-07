# Cypress Introduction
#### Mohsen Asfia
##### Service Delivery - Container Flow Optimization
##### Ace (Automated Cargo Execution)



### 
![Copenhill Race](dynamic-net.png)



## Table content
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



## Overview
- https://docs.cypress.io/guides/overview/why-cypress.html#In-a-nutshell
- Frontend testing tool
- Open source
- Unit, integration and e2e


 - JS 
 - Mocha
 - Chai


### Nice Features
- Time travel
- Real time reload
- Spies, stubs and clocks
- Debuggability
- Automatic waiting
- Network traffic control
- Screenshots and videos



## Cypress Project Structure
``` [1|2|3|4|5|6|7|8|9|10]
cypress   
└───fixtures
└───integration
└───plugins
└───support
│   │   index.js
│   │   commands.js
└───videos
└───page-objects
|   cypress.json
```


## Setting Up Cypress
As simple as 
```bash 
npm install cypress 
```


### Before Cypress


- Framework
  - Mocha
  - Jasmine
  - QUnit
  - Karma


- Assertion library
  - Chai
  - Expect.js


- Install selenium    
  - Protractor
  - Nightwatch
  - Web driver


- Additional libraries
	- Sinon
	- TestDouble



## Common Cypress Commands


```js
cy.visit('/');
```


```js
cy.get('input[type="email"]')
```


```js
cy.get('input[type="email"]').type('mohsen.asfia@maersk.com')
```


```js
cy.get('.btn').contains('User profile')
```


```js
cy.get('.btn').should('be.visible')
```


```js
cy.get('.btn').text()
```



## More Advanced Cypress Commands


### Page Title
```js
cy.title().should('eq', 'hello world')
```


### URL Protocol
```js
cy.location('protocol').should('eq', 'https')
```


### Verify We're In a Correct Page
```js
cy.contains('your feed').should('be.visible')
```


### Change The Timeout on a Command
```js
cy.contains('your feed', { timeout: 10000 }).should('be.visible')
```


### Verify The URL Hash
```js [1|2]
cy.hash().should('include', '#/editor')
cy.location('hash').should('include', '#/editor')
```


### Current URL of The Application
```js
cy.url().should('include', 'article')
```


### Navigate in Browser History
```js [1|2|3]
cy.go('back')
cy.go(-1)
cy.reload()
```



## Tricks to more efficient selectors


### within()
```js [1|2|3]
cy.get('form').within(($form) => {
  cy.get('input[type="email"]')… //=> looks only within the contentext of the selected form
  cy.root().submit() //=> will submit the form
});
```


### children()
```js [1|2|3|4|5|6]
cy.get('.nav-bar').children().contains('click') // => children() willl return all children of an element
                  .parent()
                  .parentsUntil()
                  .sibling()
                  .prev()
                  .next()
```


### first(), last(), eq()
```js [1|2|3|4]
cy.get('.btn-search').first()
                     .last()
                     .eq(1) // == first 
                     .eq(2) // == second
```



## Custom Command
In `commands.js`
```js
Cypress.Commands.add('login', () => { ... });
```


### Consumption
```js [2|3]
describe('fave icon', () => {
  beforeEach(()=> {
    cy.login();
  });
  it('click on fave icon should add the item to the favorite items', () => { ... });
})
```


Mocha hooks
  - before()
  - after()
  - beforeEach()
  - afterEach()



## Key Configurations
- baseUrl
- port
- timeout
- default folders:
  - fixtures
  - tests
  - snapshots
- Browser settings
- Configure the viewport


### Overriding global configs for a specific test
```js [3]
describe('fave icon', () => {
  beforeEach(()=> {
    cypress.config('pageLoadTimeout', 10000)
  });
  it('click on fave icon should add the item to the favorite items', () => { ... });
})
```



## .then(() => { ... }) command
```js
cy.get('form').then(($form) => {
  $form.get('input[type="email"]');
  // ...
});
```


### Can Be Used For
- Debugging
- Compare before and after
- When working with aliases in order to share context



## Aliases
```js [2|6|11]
describe('a suite', () => {
  let text;

  beforeEach(() => {
    cy.button().then(($btn) => {
      text = $btn.text()
    })
  })

  it('does have access to text', () => {
    text
  })
})
```


```js [2|6]
beforeEach(() => {
  cy.get('button').invoke('text').as('text')
})

it('has access to text', function () {
  this.text // or cy.get('@text')
})
```



## Run Cypress from Command Line


```bash
npx cypress run
```


### All Spec Files in a Specific Folder
```bash
npx cypress run —spec 'test/examples/**/*'
```


### Only
```js [12]
describe('Unit Test FizzBuzz', () => {
  beforeEach(() => {
    cy.login();
  });

  function numsExpectedToEq (arr, expected) {
    arr.forEach((num) => {
      expect(fizzbuzz(num)).to.eq(expected)
    })
  }

  it.only('returns "fizz" when number is multiple of 3', () => {
    numsExpectedToEq([9, 12, 18], 'fizz')
  })

  it('returns "buzz" when number is multiple of 5', () => {
    numsExpectedToEq([10, 20, 25], 'buzz')
  })

  it('returns "fizzbuzz" when number is multiple of both 3 and 5', () => {
    numsExpectedToEq([15, 30, 60], 'fizzbuzz')
  })
})
```


### Skip
```js [12]
describe('Unit Test FizzBuzz', () => {
  beforeEach(() => {
    cy.login();
  });

  function numsExpectedToEq (arr, expected) {
    arr.forEach((num) => {
      expect(fizzbuzz(num)).to.eq(expected)
    })
  }

  it.skip('returns "fizz" when number is multiple of 3', () => {
    numsExpectedToEq([9, 12, 18], 'fizz')
  })

  it('returns "buzz" when number is multiple of 5', () => {
    numsExpectedToEq([10, 20, 25], 'buzz')
  })

  it('returns "fizzbuzz" when number is multiple of both 3 and 5', () => {
    numsExpectedToEq([15, 30, 60], 'fizzbuzz')
  })
})
```


### Launching browser
```bash
npx cypress run --browser firefox
```


#### Currenlty supported browsers
- Canary
- Chrome
- Chromium
- Edge
- Edge Beta
- Edge Canary
- Edge Dev
- Electron
- Firefox (Beta support)
- Firefox Developer Edition (Beta support)
- Firefox Nightly (Beta support)



## Page Object Model
``` [4|9]
cypress   
└───fixtures
└───integration
│   │   search.spec.ts
└───plugins
└───support
└───videos
└───page-objects
│   │   search.object.ts
|   cypress.json
```


```js [1-2|5-7|10-12]
const BRANDS_FILTER_FIELD = '[data-test-brands-filter-field] input';
const PORT_CALL_RESULT_ITEM = '[data-test-port-call-result-item]';

export class SearchPage {
  static visit() {
    cy.login().then(() => cy.visit('/'));
    cy.server();
  }

  static typeInBrandsFiilter(query) {
    cy.get(BRANDS_FILTER_FIELD).type(query);
  }

  static getFirstPortCallResultItem() {
    return cy.get(PORT_CALL_RESULT_ITEM).first();
  }
}
```


### Consumption of a Page Object Model
```js [5|9|13-15]
import { Given } from 'cypress-cucumber-preprocessor/steps';
import { SearchPage } from '../../page-objects';

Given(`I open the port call search page`, () => {
  SearchPage.visit();
});

When(`I type mmc into the brands input and press Enter`, () => {
  SearchPage.typeInBrandsFiilter('mmc {enter}');
});

Then(`Every port call item in the results section should contain the selected regional brand in their href as a query param`, () => {
  SearchPage.getFirstPortCallResultItem()
    .should('have.attr', 'href')
    .and('match', /regionalBrands=code:MCC/);
});
```



## Fixtures 
``` [3]
cypress   
└───fixtures
│   │   credentials.json
└───integration
│   │   search.spec.ts
└───plugins
└───support
└───videos
└───page-objects
|   cypress.json
```


### credentials.json
```js
{
  "username": "foo",
  "password": "cafe"
}
```


### Integration
``` [5]
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
```


### search.spec.ts
```js [6|10]
import { Given } from 'cypress-cucumber-preprocessor/steps';
import { LoginPage } from '../../page-objects';

Given(`I open the login page`, () => {
  LoginPage.visit();
  cy.fixture('cerdentials').alias('credentials');
});

When(`I type my username into the login form and press Enter`, () => {
  LoginPage.typeInUsername(`${this.credentials.username} {enter}`);
});

//...
```



## Interacting with Files


### Write to a file
```js
	cy.writeFile('hello-world.txt', 'hello world!!', {flag: 'a+' })
```


### Read from a file and verify
```js
	cy.readfile('hello-world.txt').should('contains', 'hello world')
```



## Testing APIs


### Get
```js
cy.request('GET', 'http://google.com/api/places?id=2000')
```


### Inspecting The Response Object
```js [2|3|4]
cy.request('GET', 'http://google.com/api/places?id=2000').then((response) => {
    expect(response).to.have.property('status', 200);
    expect(response.body).to.not.be.null;
    expect(response.body.data).to.have.length(20);
});
```


### Post
```js [1|2|3|4]
cy.request('post', 'http://google.com/api/places', newPlaceItem)
  .its('body')
  .its('data')
  .should('deep.eq', newPlaceItem)
```


```js [4]
cy.request('post', 'http://google.com/api/places', newPlaceItem)
  .its('body')
  .its('data')
  .should('include', { name: 'Copenhagen' })
```


### Stubbing

#### Enable Stubbing
```js [1|2-6|3|4|5]
cy.server()           
cy.route({
  method: 'GET',      
  url: '/users/*',    
  response: []        
})
```


#### Mock The Response
```js [1|3|4]
cy.server()

cy.fixture('activities.json').as('activitiesJSON')
cy.route('GET', 'activities/*', '@activitiesJSON')
```


#### Wait for All Requests to Resolve
```js [1-2|4|6|8]
cy.server()

cy.route('activities/*', 'fixture:activities').as('getActivities')
cy.route('messages/*', 'fixture:messages').as('getMessages')

cy.visit('http://localhost:8888/dashboard')

cy.wait(['@getActivities', '@getMessages'])

cy.get('h1').should('contain', 'Dashboard')
```


#### Verify Multiple Requests
```js [8-10|12-14|16-18]
cy.server()
cy.route({
  method: 'POST',
  url: '/myApi',
}).as('apiCheck')

cy.visit('/')
cy.wait('@apiCheck').then((xhr) => {
  assert.isNotNull(xhr.response.body.data, '1st API call has data')
})

cy.wait('@apiCheck').then((xhr) => {
  assert.isNotNull(xhr.response.body.data, '2nd API call has data')
})

cy.wait('@apiCheck').then((xhr) => {
  assert.isNotNull(xhr.response.body.data, '3rd API call has data')
})
```


#### Autocomplete Example
```js [2|4|6|8-10]
cy.server()
cy.route('/search*', [{ item: 'Book 1' }, { item: 'Book 2' }]).as('getSearch')

cy.get('#autocomplete').type('Book')

cy.wait('@getSearch')

cy.get('#results')
  .should('contain', 'Book 1')
  .and('contain', 'Book 2')
```


#### Autocomplete Example with Inspecting the XHR Object

```js [7]
cy.server()
cy.route('search/*', [{ item: 'Book 1' }, { item: 'Book 2' }]).as('getSearch')

cy.get('#autocomplete').type('Book')

cy.wait('@getSearch')
  .its('url').should('include', '/search?query=Book')

cy.get('#results')
  .should('contain', 'Book 1')
  .and('contain', 'Book 2')
```


##### Multiple assertion on XHR object with a single "should" callback
```js [2|4|6-7|9-15|10|17-27|21]
cy.server()
cy.route('POST', '/users').as('new-user')

cy.get('.btn-add-new-user').click();

cy.wait('@new-user')
  .should('have.property', 'status', 201)

cy.get('@new-user') 
  .its('requestBody') // alternative: its('request.body')
  .should('deep.equal', {
    id: '101',
    firstName: 'Joe',
    lastName: 'Black'
  })

cy.get('@new-user')
  .should((xhr) => {
    expect(xhr.url).to.match(/\/users$/)
    expect(xhr.method).to.equal('POST') 
    expect(xhr.response.headers, 'response headers').to.include({
      'cache-control': 'no-cache',
      expires: '-1',
      'content-type': 'application/json; charset=utf-8',
      location: '/users/101'
    })
  })
```



## Open Cypress UI
In order to run cypress locally
```bash
npx cypress open
```



## What's coming up next week?
- Authentication with Azure/AD
- Integration with CI/CD pipeline using AzureDevops
- Integration with Cucumber



## Thank you for your time and feel free to reach out if you have any questions :-)
##### Reach me on Slack @mohsen asfia 