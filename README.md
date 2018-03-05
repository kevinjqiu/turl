```
 _              _
| |_ _   _ _ __| |
| __| | | | '__| |
| |_| |_| | |  | |
 \__|\__,_|_|  |_|
```

A *t*iny *url* shortener service

Configuration
=============

Database creation
=================

For local development, run a development postgresql docker image:

    ./reset-db.sh

Database initialization
=======================

    rails db:migrate
    rails db:seed

Add `RAILS_ENV=test` for testing environment. By default, the `development` environment will be used.

How to run the test suite
=========================

    ./reset-db.sh
    rails db:mgirate RAILS_ENV=test
    rails test

Deployment instructions
=======================

