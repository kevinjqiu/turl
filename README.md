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

Add `RAILS_ENV=test` for testing environment. By default, the `development` environment will be used.

Add some tenants. By default, tenants `alpha` and `beta` will be created using the following command:

    rails db:seed

If you want different tenants, modify `db/seeds.rb`.

How to run the test suite
=========================

    ./reset-db.sh
    rails db:mgirate RAILS_ENV=test
    rails test

Deployment instructions
=======================

To deploy it locally, use [docker-compose](https://docs.docker.com/compose/).
Go over the docker-compose manifest file `docker-compose.yml` and modify it to suit your needs.

    docker-compose up -d

Testing
-------

    $ curl -XPOST -H"Content-Type:application/json" alpha.lvh.me:3000/links -d'{"original": "http://google.com"}'
    {"original":"http://google.com","shortened":"http://alpha.lvh.me:3000/2sEC"}
