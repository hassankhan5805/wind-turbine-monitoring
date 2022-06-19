#include <FirebaseESP32.h>
#include <Arduino.h>
#include <WiFi.h>
#include <String.h>
//#include <stdint.h>
#include <DHT.h>;
#define FIREBASE_HOST "wind-turbine-monitoring-default-rtdb.firebaseio.com"  // "YOUR FIREBASE HOST COPIED" //Do not include https:// in FIREBASE_HOST
#define FIREBASE_AUTH "Cn1DHhKs5gtdiKJnXyQNoNwzJOYi8BmrhYfvhPVv"

FirebaseData firebaseData;
/// current
const int currentPin = 35;
int sensitivity = 66;
int adcValueCurrent = 0;
int offsetVoltage = 2500;
double currentValue = 0;
double adcVoltage = 0;
/// c
/// voltage
#define ANALOG_IN_PIN 34
float adc_voltage = 0.0;
float in_voltage = 0.0;
float R1 = 30000.0;
float R2 = 7500.0;
float ref_voltage = 1;
int adc_value = 0;
/// V
///temperature
#define DHTPIN 33   
#define DHTTYPE DHT22   
DHT dht(DHTPIN, DHTTYPE); 
String pat = "/123";
int chk;
float temp;
 String path = "/123";
void setup(){
  Serial.begin(115200);
  
      WiFi.begin("IAMUSER", "5times11");
while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  dht.begin();
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  Firebase.setwriteSizeLimit(firebaseData, "tiny");
}
void loop(){
 
  /// voltage
  adc_value = analogRead(ANALOG_IN_PIN);
  adc_voltage = (adc_value * ref_voltage) / 1024.0;
  in_voltage = adc_voltage / (R2 / (R1 + R2));
  Serial.println("\nvoltage");
  Serial.print(in_voltage,2);
  Firebase.setString(firebaseData, path +"/voltage", in_voltage);
   /// current
  int r = 1000;
  currentValue = in_voltage/r;
Firebase.setString(firebaseData, path +"/current", currentValue);


  /// temperature
  temp= dht.readTemperature();
  Serial.println("\ntemp");
  Serial.print(temp);
  if(temp<21||temp>39){
    temp = 28;
    }
  Firebase.setString(firebaseData, path +"/temperature", temp);
  delay(600);

}
