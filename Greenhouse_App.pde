import processing.serial.*;

Serial myPort;
String receivedData = "";
float temperature = 0;
int lightValue = 0;

void setup() {
  size(400, 300);
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(50);
  
  // Temperature bar
  fill(200, 100, 100);
  rect(50, 50, temperature * 10, 20); // bar width proportional to temp
  fill(255);
  text("Temp: " + nf(temperature,0,1) + " °C", 50, 45);
  
  // Light circle
  fill(255, 255, 100, lightValue / 4); // alpha proportional to light
  ellipse(200, 150, 50 + lightValue/10, 50 + lightValue/10);
  fill(255);
  text("Light: " + lightValue, 50, 150);
}

void serialEvent(Serial myPort) {
  receivedData = myPort.readStringUntil('\n');
  if (receivedData != null) {
    receivedData = trim(receivedData);
    if (receivedData.contains("Light level:")) {
      String[] parts = split(receivedData, "|");
      if (parts.length == 2) {
        lightValue = int(trim(parts[0].replace("Light level:", "")));
        temperature = float(trim(parts[1].replace("Temperature level:", "").replace("°C","")));
      }
    }
  }
}
