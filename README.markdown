## Pinky

Pinky generates graphs on installs-over-time of your greasemonkey userscripts hosted on [userscripts.org](http://userscripts.org/). Pinky is written in Ruby using Sinatra, DataMapper and Googlecharts (with help of the loved-by-everybody Haml and Hpricot)

### Requirements

see `.gems` for required gems:

		hpricot --version '>= 0.2' --source code.whytheluckystiff.net
		dm-core --version 0.9.10
		haml --version 2.0.6
		mattetti-googlecharts --version 1.3.6 --source gems.github.com/
		do_sqlite3 --version 0.9.11


Pinky is currently using Sqlite3 for data storage. You may use any other database supported by datamapper.


### Fetch data from userscripts.org

To parse the current number of installs of your userscripts run a rake task:
		rake fetch
 
set up a cron job for daily parsing of the current number of installs. there is an other taks `rake cron` which is used by [heroku](http://docs.heroku.com/cron) for periodic jobs.



### Installation

the most easy way is to deploy Pinky on [heroku](http://www.heroku.com).


### Copying

All sources included in this distribution are made available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).



