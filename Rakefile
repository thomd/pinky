require 'rubygems'
require 'rake'
require 'pinky.rb'

task :default => 'fetch'

desc "fetch current number of installs from userscripts.org and save"
task :fetch do
  
  # parse data from userscript.org
  Pinky.fetch_installs_from_userscripts_org
  
  # generate nice output
  puts "parsing " + UserscriptsUrl + Time.now.strftime(' on %m/%d/%Y at %I:%M%p')
  userscripts = Userscript.all(:order => [:script_name.asc])
  max = userscripts.map{|u| u.script_name.length}.max
  userscripts.each do |u|
    puts u.script_name.ljust(max+1) + ": " + u.installs.last.installs.to_s
  end
end

desc "parse data from userscripts.org each night and insert it into database"
task :cron do
  if Time.now.hour == 0  # (herokus cron runns every hour)
    Pinky.fetch_installs_from_userscripts_org
    puts "cron on #{Time.now} !"
  end
end
