require 'rubygems'
require 'rake'
require 'pinky.rb'

task :default => 'fetch'

desc "fetch current number of installs from userscripts.org and save"
task :fetch do
  Pinky.fetch_installs_from_userscripts_org
end

desc "parse data from userscripts.org each night and insert it into database"
task :cron do
  if Time.now.hour == 0  # (herokus cron runns every hour)
    Pinky.fetch_installs_from_userscripts_org
  end
end
