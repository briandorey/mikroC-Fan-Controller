#line 1 "D:/Electronics/Projects/Arduino Solar Logger/Code/PIC Temperature Monitor/Temperature Monitor.c"




const unsigned short TEMP_RESOLUTION = 12;

char *text = "000.00";
unsigned temp;

void Display_Temperature(unsigned int temp2write) {
 const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
 char temp_whole;


 if (temp2write & 0x8000) {
 text[0] = '-';
 temp2write = ~temp2write + 1;
 }


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

 TRISA = 0;
 PORTA = 0;
 PORTA.B1 = 1;

 do {

 Ow_Reset(&PORTA, 2);
 Ow_Write(&PORTA, 2, 0xCC);
 Ow_Write(&PORTA, 2, 0x44);
 Delay_us(120);

 Ow_Reset(&PORTA, 2);
 Ow_Write(&PORTA, 2, 0xCC);
 Ow_Write(&PORTA, 2, 0xBE);

 temp = Ow_Read(&PORTA, 2);
 temp = (Ow_Read(&PORTA, 2) << 8) + temp;



 Display_Temperature(temp);

 Delay_ms(2000);
 } while (1);
}
