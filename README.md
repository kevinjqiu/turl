```
 _              _
| |_ _   _ _ __| |
| __| | | | '__| |
| |_| |_| | |  | |
 \__|\__,_|_|  |_|
```

A *t*iny *url* shortener service

data model
==========

original:string
shortened:string

limitation
----------

`original`: string(2083) 2048 for chrome
`shortened`: string(TBD)

alphabet
--------

shortener alphabet:

- urlsafe base64
- remove ambiguous characters: 0, 1, i, I, l, O, o

considerations
==============

- does not prevent url encoded javascript
- add a checksum to prevent enumeration and expensive database lookup

Things you may want to cover:

* Ruby version

* System dependencies

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

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
