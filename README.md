# PGR301 - Infrastructure

Infrastructure for exam in class PGR301 at Kristiania University College as seen at [https://github.com/pgr301-2019/labguide/blob/master/eksamen.md].

## Modules

This project contains the following terraform modules:


-   config.tf is configuration variables for heroku, and sets up an application name, used when logging to Logz.io
-   variables.tf contains the variables used for the pipeline
-   pipeline.tf will set up three applications on Heroku, a development, staging and a production environment.
-   monitoring.tf will set up Statuscake http tests for specific ping controllers.
-   alert.tf sets up OpsGenie with three users, two teams, a schedule with a following rotation and an escalation from one team to the other.
- provider.tf is where the terraform.state.tf file will be saved, this location will have to be manually changed if the name is already in use.

## Getting started

To build this project, it's set up so that Travis will handle it for you. Set up Travis to work on your project by navigating to [travis-ci.com] and connecting Travis to your repo. For Travis to set up everything correctly, you will have to set a few variables as well.

To set the variables required, you can run the following travis command for each of the listed required variables.
>`travis encrypt SOMEVAR="secretvalue" --add`

### Variables required:
- HEROKU_EMAIL
- HEROKU_API_KEY
- STATUSCAKE_USERNAME
- STATUSCAKE_APIKEY
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- OPSGENIE_API_KEY

When the variables have been set in the `.travis.yml` file, you are good to go. Push the changes and Travis should be able to run your script `build.sh`.