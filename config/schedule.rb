set :environment, "production"
set :output, "log/cron_log.log"

every :monday, at: "9am" do
  runner "OrganizationNotifierService.new(Organization.all).
          send_recent_posts_to_online_members"
end

# Cada vez que se modifique este archivo, crontab debe actualizarse:
# whenever --update-crontab

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#  rake "pruebas:hello" #task en lib/tasks para comprobar el funcionamiento de
# whenever
