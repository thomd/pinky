require 'rubygems'
require 'rake'
require 'pinky.rb'

task :default => 'fetch'

desc "fetch current number of installs from userscripts.org and save"
task :fetch do
  Pinky.fetch_installs_from_userscripts_org
end

desc "parse data from userscripts.org each night at midnight and put it into database"
task :cron => :environment do
  if Time.now.hour == 0
    Pinky.fetch_installs_from_userscripts_org
  end
end
