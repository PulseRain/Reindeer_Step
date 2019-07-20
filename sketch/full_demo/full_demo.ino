//==================================================================================================
// Full Demonstration for Step CYC10 board.
// 
// Using Ctrl-U to compile and upload this sketch,
// then use Ctrl-Shift-M to open Serial Monitor
//
// This sketch will demo:
// 1) Update/refresh the 7 segment display through system timer
// 2) Receive message on UART. Users can send message through the input box at the top of 
//    the Serial Monitor. And such message will be displayed on Serial Monitor
// 3) 5 way navigation switch. Press of the navigation switch will be displayed on Serial
//    Monitor
// 4) DIP Switch will be read by the processor, and reflected on the LED
// 5) Read X-Y-Z value from the ADXL345 sensor (3-axis accelerometer). And if the user moves
//    the board, such move will be detected by the ADXL345 and report as an activity trigger.
//    When software sees the activity trigger, it will light up the REB LED on the board.
//==================================================================================================




#include "Step_CYC10_I2C.h"
#include "Step_CYC10_Seven_Seg_Display.h"

#define ADXL345_I2C_ADDR              0x53
#define ADXL345_DEVICE_ID             0xE5

constexpr uint8_t ADXL345_THRESH_ACT    = 0x24;
constexpr uint8_t ADXL345_THRESH_INACT  = 0x25;
constexpr uint8_t ADXL345_TIME_INACT    = 0x26;
constexpr uint8_t ADXL345_ACT_INACT_CTL = 0x27;
constexpr uint8_t ADXL345_TAP_AXES      = 0x2A;

constexpr uint8_t ADXL345_BW_RATE       = 0x2C;
constexpr uint8_t ADXL345_POWER_CTL     = 0x2D;
constexpr uint8_t ADXL345_INT_ENABLE    = 0x2E;
constexpr uint8_t ADXL345_INT_MAP       = 0x2F;

constexpr uint8_t ADXL345_INT_SOURCE    = 0x30;

constexpr uint8_t ADXL345_DATA_FORMAT   = 0x31;
constexpr uint8_t ADXL345_FIFO_CTL      = 0x38;


//----------------------------------------------------------------------------
// chceck_ADXL345_Interrupt_Status()
//
// Parameters:
//      None
//
// Return Value:
//      return interrupt source of ADXL345
//
// Remarks:
//      Function to read ADXL345_INT_SOURCE
//----------------------------------------------------------------------------

uint8_t chceck_ADXL345_Interrupt_Status()
{
      uint8_t buf[8];
      uint8_t t;
      
      I2C.masterRead(ADXL345_I2C_ADDR, ADXL345_INT_SOURCE, buf, 1);
      
      t = buf[0];

      return t;
      
} // End of chceck_ADXL345_Interrupt_Status()

//----------------------------------------------------------------------------
// ADXL345_init()
//----------------------------------------------------------------------------

void ADXL345_init()
{
    
    uint8_t t;
    
    I2C.masterRead(ADXL345_I2C_ADDR, 0, &t, 1);

    if (t != ADXL345_DEVICE_ID) {
        Serial.println ("ADXL345 device ID unrecognized!!!!!");
    }

    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_POWER_CTL, 0x08);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_THRESH_ACT, 0x6);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_THRESH_INACT, 0x3);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_TIME_INACT, 0x03);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_ACT_INACT_CTL, 0xFF);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_BW_RATE, 0x07);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_INT_MAP, 0x0);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_INT_ENABLE, 0x10);
    
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_DATA_FORMAT, 0xB);
    I2C.masterWrite(ADXL345_I2C_ADDR, ADXL345_FIFO_CTL, 0x80);

    chceck_ADXL345_Interrupt_Status();
    
} // End of ADXL345_init()

//----------------------------------------------------------------------------
// get_ADXL345_XYZ()
//----------------------------------------------------------------------------

uint8_t get_ADXL345_XYZ(int16_t *pX, int16_t *pY, int16_t *pZ)
{
    uint8_t buf[8];
    int16_t temp;
    uint8_t t;

    static uint8_t led_color = 0x5A;

    I2C.masterRead(ADXL345_I2C_ADDR, 0, &t, 1);
    if (t != ADXL345_DEVICE_ID) {
        Serial.println ("ADXL345 device ID unrecognized!!!!!");
        Serial.println(t, HEX);
        while(1);
    }

    t = chceck_ADXL345_Interrupt_Status();

    if (t & 0x80) {
        
        I2C.masterRead(ADXL345_I2C_ADDR, 0x32, buf, 6);
        
        temp = (((int16_t)buf[1] << 8) | buf[0]) & 0x1FFF ;
        
        if (temp & 0x1000) {
            temp |= 0xE000;    
        }
        
        *pX = temp;


        temp = (((int16_t)buf[3] << 8) | buf[2]) & 0x1FFF ;
        
        if (temp & 0x1000) {
            temp |= 0xE000;    
        }
        
        *pY = temp;

        
        temp = (((int16_t)buf[5] << 8) | buf[4]) & 0x1FFF ;
        
        if (temp & 0x1000) {
            temp |= 0xE000;    
        }
        
        *pZ = temp;
        
    }

    if (t & 0x10) {
        Serial.println("AXDL345 ACTIVITY");
        GPIO_P2 = led_color;
        led_color = ~led_color;
        
    }

    if (t & 0x08) {
         // Serial.println("AXDL345 INACTIVITY");
    }

    if (t & 0x01) {
        // Serial.println("AXDL345 OVERRUN!!!!!");
    }

    return t;
    
} // End of get_ADXL345_XYZ()



//================================================================================================================
// UART receive
//================================================================================================================

uint8_t uart_rx_buf [256] = {0};
uint8_t uart_rx_index_write_point = 0;
uint8_t uart_rx_index_read_point = 0;

void uart_rx_isr()
{
    uint8_t t;
    
    t = Serial.read();    
    uart_rx_buf [uart_rx_index_write_point++] = t;
    
} // End of uart_rx_isr()



//================================================================================================================
// 5 way navigation switch
//================================================================================================================

uint8_t keys[256] ={0};
uint8_t key_write_point = 0;
uint8_t key_read_point = 0;

void int0_keys_isr()
{
    uint8_t t;

    t = GPIO_P0 & 0x1F;
    if (t) {
        keys[key_write_point++] = t;
    }
} // End of int0_keys_isr()


//================================================================================================================
// setup()
//================================================================================================================

void setup() {
    delay(1000);

    ADXL345_init();

    SEVEN_SEG_DISPLAY.start_refresh();
   

    attachInterrupt (INT_UART_RX_INDEX, uart_rx_isr, RISING);
    attachInterrupt (INT_EXTERNAL_1ST, int0_keys_isr, RISING);

    interrupts();

 //   GPIO_P2 = 0xAC;
 //   GPIO_P3 = 0xAA;
 //   delay(5000);

} // End of setup()


//================================================================================================================
// loop()
//================================================================================================================

void loop() {

    static int i = 0;

    int16_t x, y, z;
    
    uint8_t k, t, j;
  
    Serial.print (++i);
    Serial.print (": ");
    
    Serial.print("SW = 0x");
    k = GPIO_P1;

    t = 0;
    for (j = 0; j < 8; ++j) {
        t += ((k >> j) & 1) << (7 - j);
    }
    
    Serial.print(t, HEX);
    Serial.print(" ========== ");
    
    if (uart_rx_index_read_point != uart_rx_index_write_point) {
        Serial.print("\n Got Message: ");
        do {
            Serial.write(&uart_rx_buf [uart_rx_index_read_point++], 1);
        } while(uart_rx_index_read_point != uart_rx_index_write_point);
        Serial.print("\n");
    }


    if (key_read_point != key_write_point) {
        Serial.print("\n Key Pressed: ");
        do {
            k = keys[key_read_point++];

            if (k == 0x1) {
                Serial.println(" Left");
            } else if (k == 0x2) {
                Serial.println(" Center");  
            } else if (k == 0x4) {
                Serial.println(" Down");  
            } else if (k == 0x8) {
                Serial.println(" Up");  
            } else {
                Serial.println(" Right");  
            }

            Serial.println(" ");
            
        } while(key_read_point != key_write_point);
    }

    SEVEN_SEG_DISPLAY.set_display_value(i, 1);

    // RGB LED
    GPIO_P2 = 0xFF;

    // LED / DIP Switch
    GPIO_P3 = ~GPIO_P1;


    get_ADXL345_XYZ (&x, &y, &z);
    
   
    Serial.print ("X = ");
    Serial.print (x);
    
    Serial.print (", Y = ");
    Serial.print (y);
    
    Serial.print (", Z = ");
    Serial.println (z);
    
    delay(1000);

} // End of loop()
