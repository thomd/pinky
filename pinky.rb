require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'haml'
require 'dm-core'
require 'gchart'
require 'yaml'


class Pinky

  def self.fetch_installs_from_userscripts_org
    doc = Hpricot(open(UserscriptsUrl))
    (doc/"//table//tr/td").each_with_index do |td, i|

      # row 1: name and id of userscript
      if (i%6 == 1) then
        @name = td.search("a").text
        @id =   td.search("a").first[:href].gsub(/^\/scripts\/show\//, "")
        @userscript = Userscript.first_or_create(:script_name => @name, :script_id => @id)
      end

      # row 4: number of installs
      if (i%6 == 4) then
        Install.create(:userscript => @userscript, :installs => td.inner_text, :created_on => Time.now)
      end
    end
  end

end



# ----- model -----------------------------------------------------------------

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/pinkies.sqlite3"))

class Install
  include DataMapper::Resource
  property :id,             Serial
  property :userscript_id,  Integer
  property :installs,       Integer
  property :created_on,     DateTime
  belongs_to :userscript
end

class Userscript
  include DataMapper::Resource
  property :id,           Serial
  property :script_name,  String
  property :script_id,    String
  has n, :installs
end

DataMapper.auto_upgrade!



# ----- sinatra ---------------------------------------------------------------

configure do
  UserscriptsUrl = "http://userscripts.org/users/43919/scripts"   # set URL of your userscripts
  ScriptUrl      = "http://userscripts.org/scripts/show/"
  Title          = "userscripts.org install statistics"
  set :sass, :style => :expanded
end


helpers do

  def x_range(installs)
    from    = installs.first.created_on
    to      = installs.last.created_on
    tics    = (to - from) < 6 ? (to - from) : 6
    delta   = ((to - from) / tics).to_i
    x_range = (0..tics).collect { |x| (from + delta * x).strftime("%b %d") }
  end

  def y_range(installs)
    (0..4).collect { |y| y * (installs.last.installs / 4 * 1.2).to_i }
  end

  def chart(pinky)
    data     = pinky["installs"].map{ |i| i.installs }
    x_labels = x_range(pinky["installs"])
    y_labels = y_range(pinky["installs"])
    Gchart.line(:size             => '600x200',
                :title_size       => 20,
                :title_color      => "3E3E3E",
                :data             => data,
                :max_value        => y_labels.max,
                :line_colors      => "2786C2",
                :background       => "E7E7DE",
                :chart_background => "FFFFFF",
                :axis_with_labels => ['x','y','r'],
                :axis_labels      => [x_labels, y_labels, y_labels])
  end
end


get '/' do
  redirect '/userscripts'
end

get '/userscripts' do
  @pinkies = []
  Userscript.all.each do |userscript|
    @pinkies.push({"id" => userscript.script_id, "name" => userscript.script_name, "installs" => userscript.installs(:order => [:created_on.asc])})
  end
  haml :stats
end

get '/userscript/:id' do
  redirect chart({"installs" => Userscript.first(:script_id => params[:id]).installs(:order => [:created_on.asc])})
end

get '/beauty.css' do
  content_type 'text/css'
  sass :beauty
end

error do
  "my pity is limited."
end

use_in_file_templates!
__END__

@@stats
!!! Strict
%html
  %head
    %meta{'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"}
    %link{:rel => 'stylesheet', :href => '/beauty.css', :type => 'text/css'}
    %title= Title
  %body
    #container
      %h1= Title
      %p
        of
        %a{:href => UserscriptsUrl}= UserscriptsUrl
      %ul
        - @pinkies.each do |pinky|
          %li
            %a{:href => ScriptUrl + pinky["id"]}= pinky["name"]
            %img{:src => "/userscript/" + pinky["id"]}
    %p.footer
      %a{:href => "http://github.com/thomd/pinky/commits/master"} Pinky
      is deployed on 
      %a{:href => "http://heroku.com"} Heroku

@@beauty
*
  :margin 0
  :padding 0
body
  :font-family Helvetica Neue, Helvetica, Arial, sans-serif
  :background #E7E7DE
#container
  :width 620px
  :margin 40px auto 0
  :padding 20px 40px
  :background #FFF
  :-moz-border-radius 20px
  :-webkit-border-radius 20px
  :text-align center
  :color #929388
  h1
    :color #3E3E3E
    :font-size 238%
    :margin-bottom 8px
  p
    :font-size 18px
    :margin 0 0 50px
  ul
    :list-style none
    :padding 0
    :font-size 120%
  li
    :border 10px solid #E7E7DE
    :background #E7E7DE
    :-moz-border-radius 8px
    :-webkit-border-radius 8px
    :margin-bottom 40px
    a
      :font-size 85%
a
  :color #2786C2
  :text-decoration none
  :padding 0 3px
a:hover
  :color #FFF
  background: #2786C2
p.footer
  :width 620px
  :margin 10px auto 40px
  :color #666
  :font-size 75%
  :text-align center