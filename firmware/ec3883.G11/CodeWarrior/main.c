/* ###################################################################
**     Filename    : main.c
**     Project     : Prueba-02
**     Processor   : MC9S08QE128CLK
**     Version     : Driver 01.12
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2019-11-27, 13:34, # CodeGen: 0
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
#include "AS1.h"
#include "AS2.h"
#include "Bit1.h"
#include "Bit2.h"
#include "Bit3.h"
#include "Bit4.h"
#include "Bit5.h"
#include "Bit6.h"
#include "PWM1.h"
#include "Bit7.h"
#include "TI1.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"

/* User includes (#include below this line is not maintained by Processor Expert) */
bool step[8][4] = {
		{TRUE,FALSE,TRUE,FALSE},
		{TRUE,FALSE,FALSE,FALSE},
		{TRUE,FALSE,FALSE,TRUE},
		{FALSE,FALSE,FALSE,TRUE},
		{FALSE,TRUE,FALSE,TRUE},
		{FALSE,TRUE,FALSE,FALSE},
		{FALSE,TRUE,TRUE,FALSE},
		{FALSE,FALSE,TRUE,FALSE}
};
char flag=0;
char vars[3]={0,0,0};
int IR;
int IR0;
int IR1;
int IR2;
char med[4]={0,0,0,0};
int US;
int US0;
int US1;
int US2;
int US3;
char *point;
bool filtro=1;
char zone=0;
char zone1=0;
char msj[4];
char msje[4];
char msjr[4];
char msj0[4];
char msj1[4];
char msj2[8];
char maslave=0;
char CHAR;
char i=0;
char n=0;

//******************************  FUNCIONES  ******************************
void movemotor(char vars[3]){
	char pos= vars[0]; //posicion 
	char dir= vars[1]; //direccion 0 antihorario, 1 horario
	char cont= vars[2]; //contador para recorrer el arreglo de Qn
	
	if(dir==0){ //dir = 0 mover en sentido horario
		Bit1_PutVal(step[cont][0]);
		Bit2_PutVal(step[cont][1]);
		Bit3_PutVal(step[cont][2]);
		Bit4_PutVal(step[cont][3]);
		pos=pos+1; //aumento en uno la posición
		if(cont== 7) cont=0;
		else {cont=cont+1;}
	}
		else if(dir!=0){
			Bit1_PutVal(step[cont][0]);
					Bit2_PutVal(step[cont][1]);
					Bit3_PutVal(step[cont][2]);
					Bit4_PutVal(step[cont][3]);
					pos=pos-1; // disminuyo en uno la posición
					if(cont== 0) cont=7;
					else cont=cont-1;
		}
	 if(pos==71){
		 dir=1;
		 }
	 else if(pos==0){
		 dir=0;
	 }
	 
	 vars[0]=pos;
	 vars[1]=dir;
	 vars[2]=cont;
	
} 

void move2zone(char zone, char vars[3]){
	    char pos= vars[0]; //posicion 
	    Bit7_NegVal();
		switch(zone){
		case 1:
			if(pos<66){
				vars[1]=0;
				do{
					movemotor(vars);
				}while(vars[0]==66);
				
			}
			else if(pos>66){
				vars[1]=1;
				do{
				movemotor(vars);
				}while(vars[0]==66);

			}
		break;
		case 2:			
			if(pos<54){
			vars[1]=0;
			do{
			movemotor(vars);
			}while(vars[0]==54);
		}
		else if(pos>54){
			vars[1]=1;
			do{
			movemotor(vars);
			}while(vars[0]==54);

					
		}
	break;
		case 3:
			if(pos<42){
			vars[1]=0;
			do{
			movemotor(vars);
			}while(vars[0]==42);

		}
		else if(pos>42){
			vars[1]=1;
			do{
			movemotor(vars);
			}while(vars[0]==42);

					
		}
			break;
		case 4:
			if(pos<30){
			vars[1]=0;
			do{
			movemotor(vars);
			}while(vars[0]==30);

		}
		else if(pos>30){
			vars[1]=1;
			do{
			movemotor(vars);
			}while(vars[0]==30);

					
		}
			break;
		case 5:
			if(pos<18){
			vars[1]=0;
			do{
			movemotor(vars);
			}while(vars[0]==18);

		}
		else if(pos>18){
			vars[1]=1;
			do{
			movemotor(vars);
			}while(vars[0]==18);

					
		}
			break;
		case 6:			if(pos<6){
			vars[1]=0;
			do{
			movemotor(vars);
			}while(vars[0]==6);

		}
		else if(pos>6){
			vars[1]=1;
			do{
			movemotor(vars);
			}while(vars[0]==66);

					
		}
			break;
		default: 
				break;
			
}
}

char read_serial(char msj[4],char maslave, char zone){
	maslave=msj[0] & 32; // Hago and con bit de master o slave
	//msj[0]=msj[0] & 223; // hago and con el negado de ese bit
	zone= msj[2]& 56;  // Hago and con z_0
	if(zone!=0){//Si hay zona a mover
		zone=zone>>3; //bajo a los tres bits menos significativos
		return zone+maslave; //devuelvo la suma de zona y master 
	}	
	else zone= msj[2]& 7; 
	if(zone!=0)
		return zone+maslave;
	else zone= msj[3]& 56;		
	if(zone!=0){
		zone = zone>>3;
		return zone+maslave;
	}
	else zone= msj[3]& 7;
	if(zone!=0){
		return zone+maslave;
	}
	return zone+maslave;
	}
char slavepack(char msj[4]){
	char aux0;
	aux0=msj[2];
	aux0=aux0&56;
	if(aux0!=0){
		msj[2]=msj[2]&199;
		return 0;
	}
	aux0=msj[2];
	aux0=aux0&7;
	if(aux0!=0){
			msj[2]=msj[2]&192;
			msj[3]=0;
			return 1;
		}
	aux0=msj[3];
	aux0=aux0&56;
	if(aux0!=0){
		msj[2]=msj[2]&192;
		msj[3]=msj[3]&199;
		return 2;
	}
	aux0=msj[3];
		aux0=aux0&7;
	if(aux0!=0){
			msj[3]=msj[3]&192;
			msj[2]=msj[2]&192;
			return 3;
		}
	
}
void main(void)
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
  
  /* For example: for(;;) { } */
  
while(1){
	
	AS2_EnableEvent();
	AS1_EnableEvent();
	if(flag==1){
		AS1_DisableEvent();
		AS2_DisableEvent();
		Bit6_NegVal();	
		zone=read_serial(msj, maslave, zone);
		
					if(zone>7) {
					maslave=1;
					zone=read_serial(msj, maslave, zone);
					zone=zone-32;
					AS1_DisableEvent();
					AS2_DisableEvent();
					AS2_Disable();
					AS1_Disable();
					/*
					zone=zone-32;*/
					move2zone(zone, vars);
					AS1_EnableEvent();
					AS2_EnableEvent();
					AS2_Enable();
					AS1_Enable();
					Bit5_NegVal();						
					msj0[0]=msj[0] & 223;
					msj0[1]=msj[1];
					msj0[2]=msj[2];
					msj0[3]=msj[3];
					CHAR=slavepack(msj0);
					AS2_SendBlock(msj0,4,&point);
					AS2_EnableEvent();
					if(msj0[2]==0 && msj0[3]==0){
					AS1_SendBlock(msj0,4,&point);
					}
					}
					else {
						maslave=0;
						if(msj1[2]!=msj0[2] && msj1[3]!=msj0[3]){
							zone1=read_serial(msj1, maslave, zone1);
							Bit5_NegVal();
							AS1_Disable();
							AS2_Disable();
							move2zone(zone1, vars);
							AS1_Enable();
							AS2_Enable();
							AS2_EnableEvent();

							CHAR=slavepack(msj1);
							msje[0]=msj1[0];
							msje[1]=msj1[1];
							msje[2]=msj1[2];
							msje[3]=msj1[3];
							AS1_SendBlock(msje, 4, &point);
							AS2_SendBlock(msje, 4, &point);
						}
						
						flag=2;
					}
					flag=0;
					AS2_EnableEvent();
					AS1_EnableEvent();
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
