//  Set TEMP_RESOLUTION to the corresponding resolution of used DS18x20 sensor:
//  18S20: 9  (default setting; can be 9,10,11,or 12)
//  18B20: 12

const unsigned short TEMP_RESOLUTION = 12;

char *text = "000.00";
unsigned temp;

void Display_Temperature(unsigned int temp2write) {
  const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
  char temp_whole;

  // Check if temperature is negative
  if (temp2write & 0x8000) {
     text[0] = '-';
     temp2write = ~temp2write + 1;
     }

  // Extract temp_whole
  temp_whole = temp2write >> RES_SHIFT ;

  if (temp_whole >= 40){
       PORTA.B1 = 0;
       Delay_ms(20000);
    }
    else{
       PORTA.B1 = 1;
    }
}

void main() {
  //ADDN=0x06;
  TRISA = 0;
  PORTA = 0;
  PORTA.B1 = 1;
  //Main loop
  do {
    //--- Perform temperature reading
    Ow_Reset(&PORTA, 2);// Onewire reset signal
    Ow_Write(&PORTA, 2, 0xCC);// Issue command SKIP_ROM
    Ow_Write(&PORTA, 2, 0x44);// Issue command CONVERT_T
    Delay_us(120);

    Ow_Reset(&PORTA, 2);
    Ow_Write(&PORTA, 2, 0xCC);// Issue command SKIP_ROM
    Ow_Write(&PORTA, 2, 0xBE);// Issue command READ_SCRATCHPAD

    temp =  Ow_Read(&PORTA, 2);
    temp = (Ow_Read(&PORTA, 2) << 8) + temp;

    //--- Format and display result on Lcd

    Display_Temperature(temp);

    Delay_ms(2000);
  } while (1);
}