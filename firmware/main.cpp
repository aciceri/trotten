#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include "secrets.h"

#define HOSTNAME "trotten"
#define UP_PIN 12 // NodeMCU's D6
#define DOWN_PIN 13 // NodeMCU's D7

AsyncWebServer server(80);

const char* PARAM_TIME = "time";

enum t_direction {UP, DOWN};

struct t_state {
  t_direction direction;
  unsigned long remaining_time = 0;
  unsigned long since_last_command = 0;
  
} state;

enum {GOING_UP, GOING_DOWN, STOP} motor = STOP;
unsigned long last_time;

void notFound(AsyncWebServerRequest *request) {
  request->send(404, "text/plain", "Not found");
}

void goUp(AsyncWebServerRequest *request) {
  if (!request->hasParam(PARAM_TIME)) {
    request->send(400, "text/plain", "Time not specified");
    return; 
  }
  
  unsigned long time = request->getParam(PARAM_TIME)->value().toInt();
  
  if (time > state.remaining_time || state.direction == DOWN) {
    state = {UP, time};
    request->send(200, "text/plain", "Going up");
  } else
    request->send(200, "text/plain", "Keeping to go up");
}

void goDown(AsyncWebServerRequest *request) {
  if (!request->hasParam(PARAM_TIME)) {
    request->send(400, "text/plain", "Time not specified");
    return; 
  }
  
  unsigned long time = request->getParam(PARAM_TIME)->value().toInt();
  
  if (time > state.remaining_time || state.direction == UP) {
    state = {DOWN, time};
    request->send(200, "text/plain", "Going down");
  } else
    request->send(200, "text/plain", "Keeping to go down");
}

void setup() {
  pinMode(UP_PIN, OUTPUT);    
  pinMode(DOWN_PIN, OUTPUT);    
  Serial.begin(115200);
  WiFi.hostname(HOSTNAME);
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASSWORD);
  
  if (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("WiFi Failed!");
    return;
  }
  
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  server.on("/up", HTTP_GET, goUp);
  server.on("/down", HTTP_GET, goDown);
  server.onNotFound(notFound);
  
  server.begin();

  last_time = millis();
}

void loop() {
  unsigned long delta;
  
  if (state.remaining_time > 0)
    switch (state.direction) {
    case UP:
      if (motor != GOING_UP) {
	motor = GOING_UP;
	Serial.println("Going up");
	digitalWrite(DOWN_PIN, LOW);
	digitalWrite(UP_PIN, HIGH);
      }
      break;
    case DOWN:
      if (motor != GOING_DOWN) {
	motor = GOING_DOWN;
	Serial.println("Going down");
	digitalWrite(UP_PIN, LOW);
	digitalWrite(DOWN_PIN, HIGH);
      }
      break;
    }
  else {
    if (motor != STOP) {
      motor = STOP;
      Serial.println("Stopping");
      digitalWrite(UP_PIN, LOW);
      digitalWrite(DOWN_PIN, LOW);
    }
  }

  delta = millis() - last_time;
  state.remaining_time = state.remaining_time >= delta ? state.remaining_time - delta : 0; 
  last_time = millis();
}
