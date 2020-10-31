# README

## To run

### Development

`bundle exec rails server`
`./bin/webpack-dev-server --watch`

### Brew postgres debugging

If `brew services list` shows Postgresql running but the app can't connect to it, try:
`rm -f /usr/local/var/postgres/postmaster.pid`
`brew services restart postgresql`
