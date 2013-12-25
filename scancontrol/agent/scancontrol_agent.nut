server.log("Agent Started");
server.log(http.agenturl());

// Request from browser url
function httphandler(request, response) 
{
    server.log("agent url request"); 
    if("on" in request.query) {
        server.log("on: " + request.query["on"]);
    }
    if("off" in request.query) {
        server.log("off: " + request.query["off"]);
    }
    
        
    device.send("nupic", "scan information"); 
    // send a response back...
    response.send(200, "OK");
    //response.send(200, renderPage("Electric Imp", "WiFi Localization"));
}
http.onrequest(httphandler);
