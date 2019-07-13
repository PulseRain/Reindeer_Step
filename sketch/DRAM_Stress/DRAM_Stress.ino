class PRBS
{
    public:
        void reset (uint32_t prbs_length, uint32_t start_value)
        {
             mask_ = ((2^(prbs_length + 1)) - 1);
             
             if (prbs_length == 7) {
                poly_ = 0xC1 >> 1;
                
             } else if (prbs_length == 9) {
                poly_ = 0x221 >> 1;
             } else if (prbs_length == 11) {
                poly_ = 0xA01 >> 1;
             } else if (prbs_length == 15) {
                poly_ = 0xC001 >> 1;
             } else if (prbs_length == 20) {
                poly_ = 0x80005 >> 1;
             } else if (prbs_length == 23) {
                poly_ = 0x840001 >> 1;
             } else { // assume it is PRBS 31
                poly_ = 0xA0000001 >> 1;
                mask_ = 0xFFFFFFFF;
             }

             state_ = start_value;
             prbs_length_ = prbs_length;
        }

        PRBS (uint32_t prbs_length, uint32_t start_value)
        {
            reset (prbs_length, start_value);
        }

        int get_next ()
        {
            uint32_t next_bit = 0;

            for (int i = 0; i < prbs_length_; ++i){
                if ((poly_ >> i) & 1) {
                    next_bit = next_bit ^ ((state_ >> i) & 1);
                }
            } // End of for loop

            //Serial.println(state_, HEX);
            
            state_ = ((state_ << 1) | next_bit) & mask_;

            return state_;
            
        } // End of get_next()
        
        

    private:
        uint32_t poly_;
        uint32_t state_;
        uint32_t prbs_length_;
        uint32_t mask_;
};

#define MEM_TEST_SIZE_IN_BYTES (4*1024*1024)

uint32_t mem_buf [MEM_TEST_SIZE_IN_BYTES/4];


PRBS prbs (31, 0xdeadbeef);

void setup() {

  delay(1000);
  
}

void loop() {
  
  uint32_t t;
  Serial.println ("Write PRBS");

  prbs.reset (31, 0xdeadbeef);
  
  for (int i = 0; i < MEM_TEST_SIZE_IN_BYTES / 4; ++i) {
      mem_buf[i] = prbs.get_next();
      if ((i % 1024) == 0) {
          Serial.print("write complete ");
          Serial.print (i);
          Serial.print ("/");
          Serial.print(MEM_TEST_SIZE_IN_BYTES);
          Serial.print (" = %");
          Serial.println (i * 100 / MEM_TEST_SIZE_IN_BYTES);
      }
  }

  Serial.println ("Write PRBS Done");

  
  Serial.println ("Memory read/verify");
  prbs.reset (31, 0xdeadbeef);
  
  for (int i = 0; i < MEM_TEST_SIZE_IN_BYTES / 4; ++i) {
      t = prbs.get_next();
      if (mem_buf[i] != t) {
          Serial.print ("!!!!!!!!!!!! mem test fail, ");
          Serial.print ("Expect ");
          Serial.print (t);
          Serial.print (" Actual ");
          Serial.println (mem_buf[i]);
          while(1);
      }
      
      if ((i % 1024) == 0) {
          Serial.print("read complete ");
          Serial.print (i);
          Serial.print ("/");
          Serial.print(MEM_TEST_SIZE_IN_BYTES);
          Serial.print (" = %");
          Serial.println (i * 100 / MEM_TEST_SIZE_IN_BYTES);
      }
  }

  Serial.println ("Mem Test Pass!!!!!!!!!!");
 
}
