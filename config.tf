resource "heroku_config" "dev_app_name" {
  vars = {
    APP_NAME = "PGR301_DEV"
  }
}
resource "heroku_config" "staging_app_name" {
  vars = {
    APP_NAME = "PGR301_STAGING"
  }
}
resource "heroku_config" "prod_app_name" {
  vars = {
    APP_NAME = "PGR301_PROD"
  }
}

resource "heroku_app_config_association" "development" {
  app_id = "${heroku_app.development.id}"

  vars = "${heroku_config.dev_app_name.vars}"
}

resource "heroku_app_config_association" "staging" {
  app_id = "${heroku_app.staging.id}"

  vars = "${heroku_config.staging_app_name.vars}"
}

resource "heroku_app_config_association" "production" {
  app_id = "${heroku_app.production.id}"

  vars = "${heroku_config.prod_app_name.vars}"
}
