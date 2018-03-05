Design Decisions
================

Data model
----------

A very simple data model with two fields:
* `original:string`
* `shortened:string`

Both are indexed for quick lookup.

`original` is limited to 2083 characters as that's the longest url length allowed by Edge. Chrome and others have a slightly shorter limit. See [here](https://helpx.adobe.com/experience-manager/scene7/kb/base/is_protocol-_-forming_is/url-character-limit-get-requests.html).


Shortener token
---------------

The shortener token is based on a bijective function that takes a number and map it to a string. The algorithm used here is a modification of base64 with the following modifications:

* urlsafe characters (replace `+,` `/` with `-`, `_`)
* remove ambiguous characters: `i`, `I`, `l`, `O`, `o` (which essentially made it base59)
* no padding character `=`

Test Multi-tenancy
------------------

For testing multi-tenancy, I used `lvh.me` domain. This is a domain registered to resolve to `127.0.0.1` ip address so it can be used to test subdomains without setting them up ad-hoc in `/etc/hosts` file:

    $ dig +short lvh.me
    127.0.0.1

Other Unimplemented Considerations
----------------------------------

* add a checksum to prevent client-side enumeration and expensive database lookup
* scramble the alphabet to make it more difficult to guess the encoding algorithm
