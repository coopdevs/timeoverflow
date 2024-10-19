# TimeOverflow

[![Build Status](https://github.com/coopdevs/timeoverflow/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/coopdevs/timeoverflow/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/f82c6d98a2441c84f2ef/maintainability)](https://codeclimate.com/github/coopdevs/timeoverflow/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f82c6d98a2441c84f2ef/test_coverage)](https://codeclimate.com/github/coopdevs/timeoverflow/test_coverage)

#### www.timeoverflow.org

🏦 ⌛ Time Bank management system. [Learn more about Time Banks](http://www.bdtonline.org/).

TimeOverflow is a software developed in an altruistic way to offer a system that
facilitates the interaction of the members and the management of the Time Banks.
The model on which we work is guided by the needs of the Time Banks that make use
of it and is prepared to be able to accommodate several Time Banks in a single installation,
for this account with three levels of privileges: superadmin, admin (only manages a bank)
and members of a bank.

![Demo UI](docs/images/demo_ui.jpeg)

TimeOverflow is divided into 2 large blocks:

* **Management system for administrators**
* **Social network and online banking for users**

> **NOTE** A physical Time Bank can work only with the management block, it could happen, for example, that the vast majority of its members do not use the Internet and may want to operate only with listings, checks and a management office.

### Management system

Physical Time Banks (mainly focused on TimeOverflow) often work without the Internet, perform
lists of services and members and pay the hours with heels that are finally entered in the office, therefore
the management system allows us to manage the members and their services, draw lists and keep accounting.
It is important that Bank managers (admin) have useful information about the community so that they can act on it
(for example, statistics on weak users, incident management, balance of accounts, etc.)

### Social Network and Online Banking

The social network makes it easy for members to meet and meet outside the events scheduled by the Time Bank,
as well as being able to post offers / demand ads explained in detail.

On the other hand the members can be paid the services of virtual way to save the passage through the office of the Bank
of Time and also have the possibility to consult the extract of their account.

## Docker deploying

This site is ready to be deployed in production with an optimized Docker image which uses two stages in order to minimize the final image size.

You can locally test the production deployment by the include docker-compose.yml file:

```bash
docker compose up
```

The first time running it will build the image and setup the database along with some seeds in it (testing data). If the database already exists, it will run migrations (if needed) and just start the application.

Go to `http://localhost:3000` to see the application running.

> Note that the current docker-compose.yml is not suitable for a real production deployment, it's just for testing the production Dockerfile locally.
> For production deployment you should use a real database and a reverse proxy like Nginx or Apache (with SSL enabled).
> Refer to the next section in order to see the relevant ENV variables to configure the application.

### ENV variables

In order to configure the application you can use the following ENV variables:

> Make sure to configure at least the ones without a default value (empty).

| ENV | Description | Default |
| --- | --- | --- |
| `ADMINS` | Space separated list of emails for the superadmins (ie: `admin@timeoverflow.org` | |
| `ALLOWED_HOSTS` | Put here the list of hosts allowed to access the application. Separate with spaces, for instance: `www.timeoverflow.org timeoverflow.org` | `localhost` |
| `RAILS_ENV` | Define the rails environment (not necessary to setup unless you have some special requirements) | `production` |
| `SECRET_KEY_BASE` | Secret key for the application, generate a new one with the command `rails secret` | |
| `DATABASE_URL` | Database URL, the format is `postgresql://user:password@host:port/database` | |
| `RAILS_SERVE_STATIC_FILES` | Tell the application to serve static files (you might want to turn this off if you are using an external web server to serve files from the `public` folder) | `true` |
| `RAILS_LOG_TO_STDOUT` | Tell the application to log to STDOUT (useful for Docker) | `true` |
| `RAILS_LOG_LEVEL` | Log level for the application (use `debug` for maximum information) | `info` |
| `RAILS_MAX_THREADS` | Maximum number of threads to use in the application (use `1` if multithreading is not desired) | `5` |
| `RAILS_MIN_THREADS` | Minimum number of threads to use in the application | `RAILS_MAX_THREADS` value |
| `WEB_CONCURRENCY` | Number of web server processes to use | `2` |
| `RUN_SIDEKIQ` | Run Sidekiq worker process in the docker instance (you might want to change this if want to run different docker instances for Sidekiq and Rails) | `true` |
| `RUN_RAILS` | Run Rails web server process in the docker instance | `true` |
| `SIDEKIQ_CONCURRENCY` | Number of threads to use in Sidekiq | `5` |
| `STORAGE_PROVIDER` | Storage provider for the application (currently the application supports `local` and `amazon`) | `amazon` |
| `FORCE_SSL` | Force SSL connections | `false` |
| `MAIL_LINK_HOST` | Host to use in the links sent by email (use your domain without protocol `mydomain.tld`) | |
| `MAIL_LINK_PROTOCOL` | Protocol to use in the previous host defined for links sent by email | `https` |
| `SMTP_ADDRESS` | SMTP server address (ie: `smtp.mailgun.org`) | |
| `SMTP_PORT` | SMTP server port (ie: `587`) | |
| `SMTP_DOMAIN` | SMTP domain (usually the application's domain) | |
| `SMTP_USER_NAME` | SMTP username | |
| `SMTP_PASSWORD` | SMTP password | |
| `SMTP_AUTHENTICATION` | SMTP authentication method | `plain` |
| `SMTP_ENABLE_STARTTLS_AUTO` | Enable STARTTLS | `true` |
| `SMTP_OPENSSL_VERIFY_MODE` | OpenSSL verify mode | `none` |
| `AWS_ACCESS_KEY_ID` | AWS access key ID (only if `STORAGE_PROVIDER` is `amazon`) | |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key (only if `STORAGE_PROVIDER` is `amazon`) | |
| `AWS_BUCKET` | AWS bucket name (only if `STORAGE_PROVIDER` is `amazon`) | |
| `AWS_REGION` | AWS region (only if `STORAGE_PROVIDER` is `amazon`) | |

## Contributions

Any kind of feedback, bug report, idea or enhancement are really appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add tests for behaviour changes and run the test suite:

```
bundle exec rspec
```

👉 Further information in our [Wiki](https://github.com/coopdevs/timeoverflow/wiki).

## License

> AGPL3

You can find the license file [here](LICENSE).
