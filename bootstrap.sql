CREATE USER turl WITH PASSWORD 'sekret' CREATEDB;
CREATE DATABASE turl_development;
GRANT ALL PRIVILEGES ON DATABASE turl_development TO turl;
CREATE DATABASE turl_test;
GRANT ALL PRIVILEGES ON DATABASE turl_test TO turl;
