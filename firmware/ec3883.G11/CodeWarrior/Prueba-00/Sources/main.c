/* ###################################################################
  **     Filename    : main.c
**     Project     : prueba_00
**     Processor   : MC9S08QE128CLK
**     Version     : Driver 01.12
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2019-10-07, 12:32, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.12
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */


/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "Bit1.h"
#include "Bit2.h"
#include "Bit3.h"
#include "Bit4.h"
#include "Bit5.h"
#include "Cap1.h"
#include "TI1.h"
#include "PWM1.h"
#include "AD1.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"


/* User includes (#include below this line is not maintained by Processor Expert) */
int step[8][4] = {
		{1,0,1,0},
		{1,0,0,0},
		{1,0,0,1},
		{0,0,0,1},
		{0,1,0,1},
		{0,1,0,0},
		{0,1,1,0},
		{0,0,1,0}
};
char flag;
int vars[3]={0,0,0};
int IR;
int med[4];
int US;
int leerADC12_00(int var){//Leo el ADC y lo mando a una variable de 12bits
	char error;
	AD1_Measure(TRUE);
	do{
	error=AD1_GetValue16(&var);
	}while(error!=ERR_OK);
	return var;
}
int captura_00(int var){//Leo el ADC y lo mando a una variable de 12bits
	char error;
	do{
	error=Cap1_GetCaptureValue(&var);
	}while(error!=ERR_OK);
	return var;
}
void movemotor(int vars[3]){
	int pos= vars[0];
	int dir= vars[1];
	int cont= vars[2];
	
	if(dir==0){ //dir = 0 mover en sentido horario
		Bit1_PutVal(step[cont][0]);
		Bit2_PutVal(step[cont][1]);
		Bit3_PutVal(step[cont][2]);
		Bit4_PutVal(step[cont][3]);
		pos=pos+1; //aumento en uno la posici�n
		if(cont== 7) cont=0;
		else {cont=cont+1;}
	}
		else if(dir!=0){
			Bit1_PutVal(step[cont][0]);
					Bit2_PutVal(step[cont][1]);
					Bit3_PutVal(step[cont][2]);
					Bit4_PutVal(step[cont][3]);
					pos=pos-1; // disminuyo en uno la posici�n
				
					if(cont== 0) cont=7;
							else cont=cont-1;
		}
	 if(pos==75){
		 dir=1;
		 }
	 else if(pos==0){
		 dir=0;
	 }
	 
	 vars[0]=pos;
	 vars[1]=dir;
	 vars[2]=cont;
	
} 
void paquete(char med[4], int vars[3],int IR,int US){
	int aux1,aux2;
	aux1=US;
	med[0]=vars[0]& 0b01111111;
	med[1]=(aux1 >> 2)& 0b01111111;
	med[1]=med[1]+128;
	aux1=US;
	aux1=aux1 & 0b00000011;
	aux1=aux1<<5;
	aux2=IR;
	aux2=aux2>>7;
	aux2=aux2& 0b00011111;
	med[2]=aux1+aux2;
	med[2]=med[2]+128;
	aux2=IR;
	aux2=aux2& 0b01111111;
	med[3]=aux2+128;
}

void main(void){
  /* Write your local variable definition here */
	
  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
  /* For example: for(;;) { } */
while(1){
	
	/*switch(flag)
	case 0 :
		movemotor(vars);
		paquete(med);
		break;
	case 1 ;
	IR=*/
	if (flag==0){
		//movemotor(vars);		
				
		flag=1;
	}
	
	
	
	
	
}
  
  
  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.3 [05.09]
**     for the Freescale HCS08 series of microcontrollers.
**
** ###################################################################
*/
