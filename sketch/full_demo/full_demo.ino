

//----------------------------------------------------------------------------
// I2C constant
//----------------------------------------------------------------------------

#define I2C_CSR_SYNC_RESET             1
#define I2C_CSR_START                  2
#define I2C_CSR_STOP                   0

#define I2C_CSR_READ                   4
#define I2C_CSR_WRITE                  0

#define I2C_CSR_MASTER                 8
#define I2C_CSR_SLAVE                  0

#define I2C_CSR_RESTART               16

#define I2C_CSR_IRQ_ENABLE           128
#define I2C_CSR_IRQ_DISABLE            0


#define I2C_MASTER_IDLE_FLAG         128
#define I2C_MASTER_NO_ACK_FLAG        64
#define I2C_MASTER_DATA_READY         32
#define I2C_MASTER_DATA_REQ           16

#define I2C_SLAVE_NO_ACK_FLAG          8
#define I2C_SLAVE_DATA_READY           4
#define I2C_SLAVE_DATA_REQ             2
#define I2C_SLAVE_ADDR_MATCH           1

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



class Step_CYC10_I2C
{
    public:
        void masterWrite(uint8_t i2c_addr, uint8_t reg_addr, uint8_t data);
        void masterRead(uint8_t i2c_addr, uint8_t reg_addr, uint8_t buf[], uint8_t buf_size);
        
    private:
        void _I2C_wait(uint8_t flag, uint8_t data);
  
};

Step_CYC10_I2C I2C;

void Step_CYC10_I2C::_I2C_wait(uint8_t flag, uint8_t data = 0xFF)
{
  uint8_t t;
  
   do {
        t = (*REG_I2C_CSR);
   } while (!(t & flag));

   if (flag & I2C_MASTER_DATA_REQ) {
         (*REG_I2C_DATA) = data;
   }
  
} // End of _I2C_wait()




//----------------------------------------------------------------------------
// Master_Write()
//
// Parameters:
//      i2c_addr    : I2C address, 7 bit
//      reg_addr    : address for the register to be read from the slave device
//      data        : write data
//
// Return Value:
//      return 0 if it runs ok. Otherwise it will return the CSR value
//
// Remarks:
//      Function to write data to I2C slave 
//----------------------------------------------------------------------------

void Step_CYC10_I2C::masterWrite(uint8_t i2c_addr, uint8_t reg_addr, uint8_t data)
{
   uint8_t t;

   
   (*REG_I2C_CSR) = I2C_CSR_MASTER | I2C_CSR_WRITE | I2C_CSR_SYNC_RESET;
   
   t = ((uint8_t)i2c_addr) & 127;
   t <<= 1;
   
   _I2C_wait (I2C_MASTER_IDLE_FLAG);
     
   (*REG_I2C_DATA) = t;

   (*REG_I2C_CSR) = I2C_CSR_START | I2C_CSR_WRITE | I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;

   _I2C_wait (I2C_MASTER_DATA_REQ, reg_addr);


   _I2C_wait (I2C_MASTER_DATA_REQ, data); 

   _I2C_wait (I2C_MASTER_DATA_REQ); 
  
   (*REG_I2C_CSR) = I2C_CSR_STOP | I2C_CSR_WRITE | I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;

   _I2C_wait (I2C_MASTER_IDLE_FLAG);
   
} // End of I2C_Master_Write()


//----------------------------------------------------------------------------
// masterRead()
//
// Parameters:
//      i2c_addr    : I2C address, 7 bit
//      reg_addr    : address for the register to be read from the slave device
//      buf         : data buffer to be filled
//      buf_size    : read length in bytes
//
// Return Value:
//      return 0 if it runs ok. Otherwise it will return the CSR value
//
// Remarks:
//      Function to read data from I2C slave 
//----------------------------------------------------------------------------

void Step_CYC10_I2C::masterRead(uint8_t i2c_addr, uint8_t reg_addr, uint8_t buf[], uint8_t buf_size)
{
   uint8_t t, i;

   uint32_t interrupt_saved_mstatus    = read_csr (mstatus);
    
   
   (*REG_I2C_CSR) = I2C_CSR_MASTER | I2C_CSR_WRITE | I2C_CSR_SYNC_RESET;
   
   t = ((uint8_t)i2c_addr) & 127;
   t <<= 1;

   _I2C_wait (I2C_MASTER_IDLE_FLAG);

    
   (*REG_I2C_DATA) = t;
   (*REG_I2C_CSR)  = I2C_CSR_START | I2C_CSR_WRITE | I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;

   
    _I2C_wait (I2C_MASTER_DATA_REQ, reg_addr);

    
    t = ((uint8_t)i2c_addr) & 127;
    t <<= 1;
 
    _I2C_wait (I2C_MASTER_DATA_REQ, t);
   

    (*REG_I2C_CSR) = I2C_CSR_RESTART |  I2C_CSR_READ | I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;

    _I2C_wait (I2C_MASTER_IDLE_FLAG);

    (*REG_I2C_CSR) = I2C_CSR_START| I2C_CSR_READ | I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;

    write_csr (mstatus, 0);
      for (i = 0; i < buf_size; ++i) {
          _I2C_wait (I2C_MASTER_DATA_READY);
          
          buf[i] = (*REG_I2C_DATA);
          (*REG_I2C_DATA) = 0;
          
      }
    write_csr (mstatus, interrupt_saved_mstatus);
     
   (*REG_I2C_CSR) = I2C_CSR_STOP| I2C_CSR_MASTER | I2C_CSR_IRQ_DISABLE;
  
   _I2C_wait(I2C_MASTER_IDLE_FLAG);
    
} // End of I2C_Master_Read()


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
      
}

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
    
}

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
}

//================================================================================================================
// Class CYC10_7_seg_display
//================================================================================================================

class CYC10_7_seg_display
{
    public:
        void reset (uint16_t value_to_display, uint32_t refresh_rate_in_Hz, uint8_t active_dp_mask  = 0)
        {
            value_ = value_to_display;
            index_ = 0;
            active_dp_mask_ = active_dp_mask;
            
            refresh_count_ = TIMER_RESOLUTION / refresh_rate_in_Hz;
        }

        CYC10_7_seg_display (uint16_t value_to_display, uint32_t refresh_rate_in_Hz) 
        {
            reset (value_to_display, refresh_rate_in_Hz); 
        }

        void set_display_value (uint16_t value, uint8_t active_dp_mask)
        {
            value_          = value;
            active_dp_mask_ = active_dp_mask;
        }
        
        void start_refresh ()
        { 
            timer_advance_ (refresh_count_);
            attachInterrupt (INT_TIMER_INDEX, seven_segment_display_timer_isr_, RISING);
        }

        void stop_refresh ()
        {
            detachInterrupt (INT_TIMER_INDEX);      
        }

       

    private:
        static uint16_t value_;
        static uint8_t index_;
        static uint8_t active_dp_mask_;
        static uint32_t refresh_count_;

        static constexpr uint8_t seven_seg_display_encoding_ [16] = {
           0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 
        };

        static void timer_advance_ (uint32_t count)
        {
            uint32_t low, high;
            uint64_t finish_time, current_time;
            uint32_t interrupt_saved_mstatus_timer_advance;

            interrupt_saved_mstatus_timer_advance = read_csr (mstatus);
            
            write_csr (mstatus, 0);
                low  = (*REG_MTIME_LOW);
                high = (*REG_MTIME_HIGH);
            finish_time = ((uint64_t)high << 32) + (uint64_t)(low) + (uint64_t)count;
    
                low  = finish_time & 0xFFFFFFFF;
                high = (finish_time >> 32) & 0xFFFFFFFF;
    
            (*REG_MTIMECMP_LOW) = 0xFFFFFFFF;
            (*REG_MTIMECMP_HIGH) = high;
            (*REG_MTIMECMP_LOW)  = low ;    

            write_csr (mstatus, interrupt_saved_mstatus_timer_advance);
        }

        static void _refresh ()
        {
            uint8_t t;

            GPIO_P1 = 1 << index_;
            t = (value_ >> (index_ * 4)) & 0xF;
            
            GPIO_P0 = seven_seg_display_encoding_[t] | ((active_dp_mask_ >> index_) & 1) << 7;
            index_ = (index_ + 1) % 4;

        }

        static void seven_segment_display_timer_isr_()
        {
            _refresh ();
            timer_advance_ (refresh_count_);
        }

};

uint16_t CYC10_7_seg_display::value_;
uint32_t CYC10_7_seg_display::refresh_count_;
uint8_t  CYC10_7_seg_display::index_;
uint8_t  CYC10_7_seg_display::active_dp_mask_;


CYC10_7_seg_display SEVEN_SEG_DISPLAY (0xbeef, 400);




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
}    



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
}




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

}


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

}
