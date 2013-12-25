//WiFi Localization

//Register with the server
imp.configure("Localization", [], []);


// Device Statistics
function device_statistics()
{
    // Device ID
    server.log("device id: " + hardware.getdeviceid());
    // Display Mac Address
    server.log("device mac address: " + imp.getmacaddress());
    // Current Memory
    server.log("Imp Free Memory: " + imp.getmemoryfree());
    //Get hardware voltage
    server.log("Hardware Voltage: " + hardware.voltage());
    // Display fw rev
    server.log("Device Started (version: " + imp.getsoftwareversion() + ")");
    // Display environment
    server.log("Environment: " + imp.environment() + ":" + ENVIRONMENT_CARD);
}

// WiFi statistics
function wifi_statistics()
{
    // Display Device rssi
    server.log("raw rssi: " + imp.rssi());
    // Display BSSID
    server.log("BSSID: " + imp.getbssid());
    // Display SSID
    server.log("SSID: " + imp.getssid());
}


// xively rssi plots
function sample_rssi()
{
    // Send data to Agent
    rssi_parse <- { key = "rssi", value = imp.rssi() };
    local rssi_str = rssi_parse.key + ", " + rssi_parse.value
    server.log(rssi_str)
    agent.send("SendToXively", rssi_str);    
    //wakeup and reiterate
    //imp.wakeup(0.1, sample_rssi);
}


// Scan for Networks (APs)
function scan_handler() 
{
    local scan_results = imp.scanwifinetworks();
    foreach (idx,val in scan_results) 
    {
        server.log("SSID="+ scan_results[idx].ssid + 
        " BSSID="+ scan_results[idx].bssid + 
        " Ch="+scan_results[idx].channel + 
        " RSSI="+scan_results[idx].rssi +
        " Open=" +scan_results[idx].open );
    }
}

// Change Connection


device_statistics();
wifi_statistics();
sample_rssi();
scan_handler();

// event handler for agent to call into device
function nupic_handler(data) {  server.log("nupic prediction: " + data); }
agent.on("nupic", nupic_handler);


// End of code.
