# Sky Gazer

Welcome to the simplest weather application you've ever used. It does three things:

1. You can add/update/delete forecast locations
2. View a seven day forecast for the location

> I thought you said three?

### System dependencies

#### Ruby version

Please see the [`.ruby-version`](.ruby-version) file in the project.

#### MapQuest API key

1. [Create a MapQuest developer account](https://developer.mapquest.com/user/login/sign-up) and get an API key.
1. Add a `mapquest_api_key` [Custom Credential](https://guides.rubyonrails.org/security.html#custom-credentials).

Docs: https://developer.mapquest.com/documentation/place-search-js/v1.0/

#### National Weather Service API

1. Add a `nws_user_agent` [Custom Credential](https://guides.rubyonrails.org/security.html#custom-credentials).
 
Docs: https://www.weather.gov/documentation/services-web-api

- [x] Determine the "rails way" to do the above in a less manual way. ***Answer:** [Custom Credentials](https://guides.rubyonrails.org/security.html#custom-credentials)*

### Getting started

```shell
git clone git@github.com:michaelwestphal/sky-gazer.git
cd sky-gazer
bin/setup
bin/rails server
```

### How to run the test suite

```shell
bin/rails test
bin/rails test:system
```

### Deploy to [Fly.io](https://fly.io)

1. [Getting started](https://fly.io/docs/rails/getting-started/)
1. [Configure for SQLite3](https://fly.io/docs/rails/advanced-guides/sqlite3/)

### Further Configuration

*At the moment this setup is **not** necessary, but once Geolocation is working, we need a secure connection locally.*

1. `openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt`
2. `bin/rails s -b 'ssl://localhost:3000?key=path/to/file/localhost.key&cert=path/to/file/localhost.crt'`
   
[Source](https://madeintandem.com/blog/rails-local-development-https-using-self-signed-ssl-certificate/)

### Tips

- `bin/rails --tasks`
- `bin/rails routes -c <ControllerName>`
- `http://localhost:3000/rails/info/routes`
