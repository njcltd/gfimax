#MAXfocus Dashing Dashboard

##The End Result

![max_dashboard](https://cloud.githubusercontent.com/assets/8008695/12797377/8a6eba5c-cabb-11e5-95e3-29fd47a8fa7c.jpg)

##Getting There!

Upload the Job and widgets, to the coresponding folders, the widget names are important to remain as they are!

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



