require 'nokogiri'
require 'open-uri'

DASHBOARD_HOST = 'www.systemmonitor.co.uk'
API_KEY = 'ENTER YOUR API KEY HERE'

site_list = []
SCHEDULER.every '1h',  :first_in => 0  do
# Build a list of sites every hour as list server APi requires SITEID

sitescount = 0

# Get List of clients
    list_clients_api = "https://#{DASHBOARD_HOST}/api/?apikey=#{API_KEY}&service=list_clients"
     doc = Nokogiri::XML(open(list_clients_api))
     clientcount = doc.xpath('//client').count
     doc.xpath('//client').each do |clients|
        client_id = clients.xpath('clientid').text
       # Get List of Sites
         list_sites_api = "https://#{DASHBOARD_HOST}/api/?apikey=#{API_KEY}&service=list_sites&clientid=#{client_id}"
           doc1 = Nokogiri::XML(open(list_sites_api))
           sitescount = sitescount + doc1.xpath('//site').count
	   doc1.xpath('//site').each do |sites|
           site_list << sites.xpath('siteid').text
          end
        end


    send_event('max_clients_sites', { clientsnum: clientcount, sitesnum: sitescount, site_list: site_list})


end




SCHEDULER.every '60s' do

#reset offline counter
offlinenum = 0

    #Loop sites from site array
   site_list.each do |site_list|
     server_list_api = "https://#{DASHBOARD_HOST}/api/?apikey=#{API_KEY}&service=list_servers&siteid=#{site_list}" 
     #this can also be narrowed down to a site if needed
        #remotely call and parse response from max API
        #WARNING: you will need to 'gem install nokogiri' for this, feel free to use alternatives
        doc = Nokogiri::XML(open(server_list_api))
        #count the server tags with online = 0 value
        siteofflinecount = 0
        siteofflinecount = doc.xpath('//online[text()="0"]').count
         if siteofflinecount > 0
         offlinenum = offlinenum + siteofflinecount
         end
    end


      failing_list_api = "https://#{DASHBOARD_HOST}/api/?apikey=#{API_KEY}&service=list_failing_checks" 
	#remotely call and parse response from max API
	doc = Nokogiri::XML(open(failing_list_api))
	mobnum = doc.xpath('//check_type[text()="1002"]').count
        mavnum  = doc.xpath('//check_type[text()="1026"]').count
        mavnum = mavnum +  doc.xpath('//check_type[text()="1034"]').count
        servissues = doc.xpath('//server').count
        wsissues = doc.xpath('//workstation').count

# Set Status Warning

offlinestatus = case offlinenum
  when 0 then 'ok'
  else 'warning'
end


mobstatus = case mobnum
  when 0 then 'ok'
  else 'warning'
end


mavstatus = case mavnum
  when 0 then 'ok'
  when 1..4 then 'danger'
  else 'warning'
end


servistatus = case servissues
  when 0 then 'ok'
  when 1..9 then 'danger'
  else 'warning'
end

wsistatus = case wsissues
  when 0 then 'ok'
  when 1..9 then 'danger'
  else 'warning'
end


      send_event('max_servers_offline', { num: offlinenum, status: offlinestatus})

      send_event('max_mob_status', { num: mobnum, status: mobstatus})

      send_event('max_mav_status', {num:  mavnum, status: mavstatus})

      send_event('max_servers_issues', { num: servissues, status: servistatus})

      send_event('max_ws_issues', { num: wsissues, status: wsistatus})


end
