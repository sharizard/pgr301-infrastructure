provider "opsgenie" {
  version = "0.2.3"
  api_url = "api.eu.opsgenie.com"
}

#Users
resource "opsgenie_user" "superuser" {
  username  = "super@some.domain.com"
  full_name = "Super Usersson"
  role      = "Owner"
  locale    = "no_NO"
  timezone  = "Europe/Oslo"
}

resource "opsgenie_user" "user1" {
  username  = "user1@some.domain.com"
  full_name = "User1 Usersson"
  role      = "User"
  locale    = "no_NO"
  timezone  = "Europe/Oslo"
}

resource "opsgenie_user" "user2" {
  username  = "user2@some.domain.com"
  full_name = "User2 Usersson"
  role      = "User"
  locale    = "no_NO"
  timezone  = "Europe/Oslo"
}
#End users

#User contact
resource "opsgenie_user_contact" "user1_sms" {
  username = "${opsgenie_user.user1.username}"
  to       = "47-99356459"
  method   = "sms"
}

resource "opsgenie_user_contact" "user1_email" {
  username = "${opsgenie_user.user1.username}"
  to       = "user1@usermail.no"
  method   = "email"
}

resource "opsgenie_user_contact" "user1_voice" {
  username = "${opsgenie_user.user1.username}"
  to       = "47-99356459"
  method   = "voice"
}

resource "opsgenie_user_contact" "user2_email" {
  username = "${opsgenie_user.user2.username}"
  to       = "user2@second.work.email.com"
  method   = "email"
}

resource "opsgenie_user_contact" "user2_voice" {
  username = "${opsgenie_user.user2.username}"
  to       = "47-99999999"
  method   = "voice"
}

resource "opsgenie_user_contact" "user2_sms" {
  username = "${opsgenie_user.user2.username}"
  to       = "47-99999999"
  method   = "sms"
}

resource "opsgenie_user_contact" "super" {
  username = "${opsgenie_user.superuser.username}"
  to       = "47-99999999"
  method   = "voice"
}
#End user contact

# Teams
resource "opsgenie_team" "tier_one" {
  name        = "Tier 1"
  description = "This team deals with the basic shit"

  member {
    id   = "${opsgenie_user.user1.id}"
    role = "user"
  }
  member {
    id   = "${opsgenie_user.user2.id}"
    role = "user"
  }
}

resource "opsgenie_team" "supermen" {
  name        = "Superadmins"
  description = "This team fixes all the things that has Tier 1 can't handle"

  member {
    id   = "${opsgenie_user.superuser.id}"
    role = "admin"
  }
}
# End teams

#Schedule
resource "opsgenie_schedule" "tier_one_schedule" {
  name          = "Tier 1 schedule - Exam deliveries"
  description   = "Schedule for the Tier 1 team"
  timezone      = "Europe/Oslo"
  owner_team_id = "${opsgenie_team.tier_one.id}"
}

resource "opsgenie_schedule" "supermen_schedule" {
  name          = "supermen_schedule_no_sleep"
  description   = "Schedule for the supermen"
  timezone      = "Europe/Oslo"
  owner_team_id = "${opsgenie_team.supermen.id}"
}
# End schedule

# Schedule rotation
resource "opsgenie_schedule_rotation" "tier_1_rotation" {
  schedule_id = "${opsgenie_schedule.tier_one_schedule.id}"
  name        = "Tier 1 Schedule Rotation"
  start_date  = "2019-11-04T23:00:00Z"
  end_date    = "2019-12-04T08:00:00Z"
  type        = "hourly"
  length      = 8

  participant {
    type = "team"
    id   = "${opsgenie_team.tier_one.id}"
  }

  time_restriction {
    type = "time-of-day"

    restriction {
      start_hour = 0
      start_min  = 0
      end_hour   = 8
      end_min    = 0
    }
  }
}

resource "opsgenie_schedule_rotation" "supermen_rotation" {
  schedule_id = "${opsgenie_schedule.supermen_schedule.id}"
  name        = "Supermen Schedule Rotation"
  start_date  = "2019-11-04T23:00:00Z"
  end_date    = "2019-12-04T08:00:00Z"
  type        = "hourly"
  length      = 24

  participant {
    type = "team"
    id   = "${opsgenie_team.supermen.id}"
  }

  time_restriction {
    type = "time-of-day"

    restriction {
      start_hour = 0
      start_min  = 0
      end_hour   = 23
      end_min    = 0
    }
  }
}

#End schedule rotation

#Escalation

resource "opsgenie_escalation" "tier_1_on_call" {
  name          = "Give Tier 1 something to do"
  description   = "Something bad happened"
  owner_team_id = "${opsgenie_team.tier_one.id}"

  rules {
    condition   = "if-not-acked"
    notify_type = "default"
    delay       = 0

    recipient {
      type = "schedule"
      id   = "${opsgenie_schedule.tier_one_schedule.id}"
    }
  }
  rules {
    condition   = "if-not-acked"
    notify_type = "default"
    delay       = 10

    recipient {
      type = "team"
      id   = "${opsgenie_team.tier_one.id}"
    }
  }
}

resource "opsgenie_escalation" "tier1_to_supermen" {
  name          = "Tier 1 is too slow"
  description   = "Escalates to the supermen"
  owner_team_id = "${opsgenie_team.tier_one.id}"

  rules {
    condition   = "if-not-closed"
    notify_type = "default"
    delay       = 60

    recipient {
      type = "team"
      id   = "${opsgenie_team.supermen.id}"
    }
  }
}
