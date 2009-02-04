## Pinky

Pinky generates graphs of your greasemonkey-userscript-installs (hosted on [userscripts.org](http://userscripts.org/)) over time. Pinky is written in Ruby using Sinatra, DataMapper and Googlecharts (with help of the loved-by-everybody Haml and Hpricot)

### Requirements

gems required:

		$ sudo gem install sinatra
		$ sudo gem install dm-core
		$ sudo gem install haml
		$ sudo gem install hpricot
		$ sudo gem install mattetti-googlecharts

Pinky is currently using Sqlite3 for data storage. You may use any other database supported by datamapper.

		$ sudo gem install do_sqlite3
  

### Fetch data from userscripts.org

To parse the current number of installs of your userscripts run a rake task:
		rake fetch
 
set up a cron job for daily parsing of the current number of installs. 



### Installation

Clone the application and run 

		ruby pinky.rb 
  
within the application directory.
  
Then point your browser to:

		http://localhost:4567



### Copying

All sources included in this distribution are made available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).



