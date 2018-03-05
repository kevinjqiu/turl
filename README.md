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

Testing:

    $ curl -v -XPOST -H"Content-Type:application/json" alpha.lvh.me:3000/links -d'{"original": "http://google.com"}'
    Note: Unnecessary use of -X or --request, POST is already inferred.
    *   Trying 127.0.0.1...
    * Connected to alpha.lvh.me (127.0.0.1) port 3000 (#0)
    > POST /links HTTP/1.1
    > Host: alpha.lvh.me:3000
    > User-Agent: curl/7.47.0
    > Accept: */*
    > Content-Type:application/json
    > Content-Length: 33
    >
    * upload completely sent off: 33 out of 33 bytes
    < HTTP/1.1 201 Created
    < Content-Type: application/json; charset=utf-8
    < ETag: W/"cac520a82916d4fd3b3db6373d184799"
    < Cache-Control: max-age=0, private, must-revalidate
    < X-Request-Id: 7d1cc0c1-799c-4572-b7e9-5efbcb233680
    < X-Runtime: 0.404482
    < Transfer-Encoding: chunked
    <
    * Connection #0 to host alpha.lvh.me left intact
    {"original":"http://google.com","shortened":"http://alpha.lvh.me:3000/2sEC"}
