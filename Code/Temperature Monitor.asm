
_Display_Temperature:

;Temperature Monitor.c,10 :: 		void Display_Temperature(unsigned int temp2write) {
;Temperature Monitor.c,15 :: 		if (temp2write & 0x8000) {
	BTFSS      FARG_Display_Temperature_temp2write+1, 7
	GOTO       L_Display_Temperature0
;Temperature Monitor.c,16 :: 		text[0] = '-';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      45
	MOVWF      INDF+0
;Temperature Monitor.c,17 :: 		temp2write = ~temp2write + 1;
	COMF       FARG_Display_Temperature_temp2write+0, 1
	COMF       FARG_Display_Temperature_temp2write+1, 1
	INCF       FARG_Display_Temperature_temp2write+0, 1
	BTFSC      STATUS+0, 2
	INCF       FARG_Display_Temperature_temp2write+1, 1
;Temperature Monitor.c,18 :: 		}
L_Display_Temperature0:
;Temperature Monitor.c,21 :: 		temp_whole = temp2write >> RES_SHIFT ;
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R1+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R1+1
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
;Temperature Monitor.c,23 :: 		if (temp_whole >= 40){
	MOVLW      40
	SUBWF      R1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Display_Temperature1
;Temperature Monitor.c,24 :: 		PORTA.B1 = 0;
	BCF        PORTA+0, 1
;Temperature Monitor.c,25 :: 		Delay_ms(20000);
	MOVLW      203
	MOVWF      R11+0
	MOVLW      236
	MOVWF      R12+0
	MOVLW      132
	MOVWF      R13+0
L_Display_Temperature2:
	DECFSZ     R13+0, 1
	GOTO       L_Display_Temperature2
	DECFSZ     R12+0, 1
	GOTO       L_Display_Temperature2
	DECFSZ     R11+0, 1
	GOTO       L_Display_Temperature2
	NOP
;Temperature Monitor.c,26 :: 		}
	GOTO       L_Display_Temperature3
L_Display_Temperature1:
;Temperature Monitor.c,28 :: 		PORTA.B1 = 1;
	BSF        PORTA+0, 1
;Temperature Monitor.c,29 :: 		}
L_Display_Temperature3:
;Temperature Monitor.c,30 :: 		}
L_end_Display_Temperature:
	RETURN
; end of _Display_Temperature

_main:

;Temperature Monitor.c,32 :: 		void main() {
;Temperature Monitor.c,34 :: 		TRISA = 0;
	CLRF       TRISA+0
;Temperature Monitor.c,35 :: 		PORTA = 0;
	CLRF       PORTA+0
;Temperature Monitor.c,36 :: 		PORTA.B1 = 1;
	BSF        PORTA+0, 1
;Temperature Monitor.c,38 :: 		do {
L_main4:
;Temperature Monitor.c,40 :: 		Ow_Reset(&PORTA, 2);// Onewire reset signal
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;Temperature Monitor.c,41 :: 		Ow_Write(&PORTA, 2, 0xCC);// Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;Temperature Monitor.c,42 :: 		Ow_Write(&PORTA, 2, 0x44);// Issue command CONVERT_T
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;Temperature Monitor.c,43 :: 		Delay_us(120);
	MOVLW      79
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	NOP
	NOP
;Temperature Monitor.c,45 :: 		Ow_Reset(&PORTA, 2);
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;Temperature Monitor.c,46 :: 		Ow_Write(&PORTA, 2, 0xCC);// Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;Temperature Monitor.c,47 :: 		Ow_Write(&PORTA, 2, 0xBE);// Issue command READ_SCRATCHPAD
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;Temperature Monitor.c,49 :: 		temp =  Ow_Read(&PORTA, 2);
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	CLRF       _temp+1
;Temperature Monitor.c,50 :: 		temp = (Ow_Read(&PORTA, 2) << 8) + temp;
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R2+1
	CLRF       R2+0
	MOVF       _temp+0, 0
	ADDWF      R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;Temperature Monitor.c,54 :: 		Display_Temperature(temp);
	MOVF       R0+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       R0+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	CALL       _Display_Temperature+0
;Temperature Monitor.c,56 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
;Temperature Monitor.c,57 :: 		} while (1);
	GOTO       L_main4
;Temperature Monitor.c,58 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
