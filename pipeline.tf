# Create Heroku apps for ci, staging and production
resource "heroku_app" "development" {
  name   = "${var.app_prefix}-app-dev"
  region = "eu"
}

resource "heroku_addon" "db_development" {
  app  = "${heroku_app.development.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_app" "staging" {
  name   = "${var.app_prefix}-app-staging"
  region = "eu"
}

# Create a database, and configure the app to use it
resource "heroku_addon" "db_stage" {
  app  = "${heroku_app.staging.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_app" "production" {
  name   = "${var.app_prefix}-app-prod"
  region = "eu"
}

# Create a database, and configure the app to use it
resource "heroku_addon" "db_prod" {
  app  = "${heroku_app.production.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_pipeline" "exam" {
  name = "${var.pipeline_name}"
}

# Couple apps to different pipeline stages
resource "heroku_pipeline_coupling" "development" {
  app      = "${heroku_app.development.name}"
  pipeline = "${heroku_pipeline.exam.id}"
  stage    = "development"
}

resource "heroku_pipeline_coupling" "staging" {
  app      = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.exam.id}"
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.exam.id}"
  stage    = "production"
}
