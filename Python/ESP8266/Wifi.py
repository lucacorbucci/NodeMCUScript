import network

ap = network.WLAN(network.AP_IF)
ap.config(essid="NodeMCU", password="YOUR_PASSWORD")
ap.active(True)
