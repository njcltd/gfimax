#MAXfocus Dashing Dashboard

##The End Result

![max_dashboard](https://cloud.githubusercontent.com/assets/8008695/12797377/8a6eba5c-cabb-11e5-95e3-29fd47a8fa7c.jpg)

##Getting There!

First ensure you have an install of dashing.io installed (for more on that check out http://dashing.io), working and ready.

Then Upload the Job and widgets, to the coresponding folders, the widget names are important to remain as they are!

Change the API key to yours from the dashboard in the maxfocus.rb file (Dashboard, Settings, General Settings, API)

Once they are uploaded configure your dashboard file, sample.erb located in the dashboard folder by adding the lines below, you can change the layout if you wish.

```
<li data-row="2" data-col="2" data-sizex="1" data-sizey="1" >
      <div data-id="max_servers_offline" data-view="Statusnum" data-title="Offline Servers"></div>
    </li>

<li data-row="3" data-col="2" data-sizex="1" data-sizey="1" >
      <div data-id="max_mob_status" data-view="Statusnum" data-title="MOB Status"></div>
    </li>

<li data-row="3" data-col="3" data-sizex="1" data-sizey="1" >
      <div data-id="max_mav_status" data-view="Statusnum" data-title="MAV Status"></div>
    </li>

<li data-row="2" data-col="3" data-sizex="1" data-sizey="1" >
      <div data-id="max_servers_issues" data-view="Statusnum" data-title="Server Issues"></div>
    </li>

<li data-row="2" data-col="4" data-sizex="1" data-sizey="1" >
      <div data-id="max_ws_issues" data-view="Statusnum" data-title="Workstation Issues"></div>
    </li>

<li data-row="3" data-col="4" data-sizex="1" data-sizey="1" >
      <div data-id="max_clients_sites" data-view="Maxinfo" data-title="monitoring">
    </li>
```

## Wrapping it up

You will need to ensure you have Nokogiri in your Gemfile which is located in the Dashing root Directory

```
gem 'nokogiri'
```

Once added you will need to run the following from your root dashing directory

```
sudo bundle install
```

NOTE: if you get an error after doing this your ruby install you may need to install the following

```
sudo apt-get install ruby-dev zlib1g-dev liblzma-dev
sudo gem install nokogiri
```

and then run the 'bundle install' again
