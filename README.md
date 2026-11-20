# CAPONEU

Source code of the [CAPONEU](https://caponeu.eu) platform — *Cartography of the
Political Novel in Europe*. The platform is a public catalogue of political
novels, their editions, authors, translators, organizations, events and
thematic collections, with an administration interface for editors.

Developed by [Slobodna domena Zadruga za otvoreni kod i dizajn](https://github.com/Slobodna-domena).

## Stack

- Ruby 2.7.5, Ruby on Rails 7.0
- PostgreSQL
- [ActiveAdmin](https://activeadmin.info/) + Devise for the admin interface
- CarrierWave for uploads, FriendlyId for slugs, PaperTrail for versioning
- Sprockets / Sass for assets, WickedPDF for PDF export

## Getting started

Requirements: Ruby (see `.ruby-version`), PostgreSQL, Node.js and Yarn.

```sh
bundle install
yarn install

# database (the role must be able to create databases)
createdb -O caponeu caponeu_development
# set the environment variables from "Configuration" in your shell

bin/rails db:schema:load
bin/rails db:seed      # development only: creates an admin user and a sample news item
bin/rails server
```

The site runs on <http://localhost:3000> and the admin interface is served by
ActiveAdmin (see `config/routes.rb`).

## Configuration

Configuration is read from environment variables:

| Variable | Purpose | Default |
|---|---|---|
| `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD` | PostgreSQL connection | `localhost`, `caponeu`, – |
| `DB_NAME`, `DB_NAME_TEST` | Database names | `caponeu_development` (production: `caponeu`), `caponeu_test` |
| `SECRET_KEY_BASE` | Rails secret (required in production; generate with `bin/rails secret`) | – |
| `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD` | Outgoing e-mail | `localhost`, `587` |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | Admin created by `db:seed` in development | `admin@example.com`, `change-me-please` |
| `GOOGLE_MAPS_API_KEY` | Google Maps JavaScript API key (browser key; restrict it by HTTP referrer) | – |
| `REDIS_URL` | Action Cable in production | `redis://localhost:6379/1` |

Site name and public URL are set in `config/site_config.yml`.

### AI search

The optional AI search sends questions to an external service
(`app/models/application_record.rb`; `http://localhost:8000/query` in
development). That service is not part of this repository; without it the
feature simply returns no results.

## Notes

- Locale: the database is expected to use a UTF-8 collation suitable for
  Croatian (`hr_HR.UTF-8`) for correct sorting of names.
- Uploaded files are stored in `public/uploads` and are not part of the repository.

## License

The source code is released under the [MIT License](LICENSE).

Logos, emblems and other third-party materials included in the repository
(for example the EU, UKRI and partner-institution logos) are **not** covered by
the MIT License; see the notice at the end of [LICENSE](LICENSE).
