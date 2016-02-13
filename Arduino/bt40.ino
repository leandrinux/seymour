/* SEYMOUR: IMPLEMENTACION DE SISTEMA DE RIEGO INTELIGENTE
 * Hackaton IoTMdP 2016 
 * Leandro.JoseLuis.Lucas
 * 
 * Pin 13 salida de bomba de riego 
 * Pin A0 sensor de humedad
 * Pin TX 14, Pin RX 15 BT4
 *  
 */

#include <SoftwareSerial.h>

SoftwareSerial mySerial(15, 14); // RX, TX  

void setup() {  
  Serial.begin(9600);           // debug
  mySerial.begin(9600);         // conexion BT
}

void loop() {  
  /*
   * Leemos el sensor de humedad y enviamos por bluetooth el
   * valor codificado en ASCII:
   * 
   * MUY HUMEDO = 0
   * MUY SECO = 1023
   * 
   */
   
  int humedad = analogRead(A0);     // lectura sensor de humedad suelo
  mySerial.print(humedad);
  delay(2000);
  
}
