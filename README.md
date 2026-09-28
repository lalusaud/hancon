# HaNCON website

Rails 8.1.4 application using Ruby 3.4.11, PostgreSQL, and Tailwind CSS.

## Setup

```sh
bin/rails db:prepare
bin/dev
```

## Admin content management

The password-protected `/admin` area manages news and updates, events, and photo galleries. News articles use Action Text for rich formatting and inline images, with full article pages linked from the homepage. The public homepage displays published content. Gallery and article images use Active Storage's local disk service in development.

Create the first admin with a unique password of at least 12 characters:

```sh
ADMIN_EMAIL=admin@example.org ADMIN_PASSWORD='use-a-long-unique-password' bin/rails admin:create
```

This task can also reset the password for an existing account. There is no public account registration. Admins sign in at `/session/new` and then open `/admin`.

## Deploy to Heroku

The app is configured for Heroku's Ruby buildpack and a single Heroku Postgres database. The `release` process in `Procfile` runs database migrations before each new release. Production uploads use Amazon S3 because files on Heroku dynos are temporary.

1. Create a Heroku app and add the Heroku Postgres add-on from the [Heroku Dashboard](https://dashboard.heroku.com/) or with the Heroku CLI:

   ```sh
   heroku create your-app-name
   heroku addons:create heroku-postgresql
   ```

2. In the app's **Settings → Config Vars**, set:

   - `RAILS_MASTER_KEY`: the contents of this app's `config/master.key` (keep it private).
   - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and `AWS_S3_BUCKET`: credentials for an S3 bucket used for production uploads. Give the credentials access only to that bucket.
   - `APP_HOST`: the public hostname, such as `your-app-name.herokuapp.com` (without `https://`).

   Heroku supplies `DATABASE_URL` when the Postgres add-on is attached. Do not commit secrets to the repository.

3. Configure the S3 bucket's CORS policy to allow browser uploads from the app's HTTPS hostname. Keep the bucket private; Active Storage serves files through the Rails app.

4. Push the deploy branch to Heroku. For a local `main` branch:

   ```sh
   git push heroku main
   ```

   The build creates the production assets, then the release process migrates the database. Check the release and web dyno logs in the Heroku Dashboard if the app does not start.

5. Create the first admin account. Temporarily set `ADMIN_EMAIL` and `ADMIN_PASSWORD` as config vars in the dashboard, run the task, then remove `ADMIN_PASSWORD` from Config Vars:

   ```sh
   heroku run bin/rails admin:create --app your-app-name
   ```

   Use a unique password of at least 12 characters. Admins sign in at `/session/new`.

For production password reset emails, configure an SMTP provider and the SMTP settings in `config/environments/production.rb` before relying on email delivery. This starter configuration does not include a mail provider.
