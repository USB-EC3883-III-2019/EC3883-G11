/* ###################################################################
**     Filename    : Events.h
**     Project     : prueba_00
**     Processor   : MC9S08QE128CLK
**     Component   : Events
**     Version     : Driver 01.02
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2019-10-07, 12:32, # CodeGen: 0
**     Abstract    :
**         This is user's event module.
**         Put your event handler code here.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file Events.h
** @version 01.02
** @brief
**         This is user's event module.
**         Put your event handler code here.
*/         
/*!
**  @addtogroup Events_module Events module documentation
**  @{
*/         

#ifndef __Events_H
#define __Events_H
/* MODULE Events */

#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include "PE_Timer.h"
#include "Bit1.h"
#include "Bit2.h"
#include "Bit3.h"
#include "Bit4.h"
#include "Bit5.h"
#include "Cap1.h"
#include "TI1.h"
#include "PWM1.h"
#include "AD1.h"

extern char flag;
/////////////////////////////////////////////////
void movemotor(char pos, bool dir, char cont);
// funcion para mover el motor, envia la secuencia de bits correspondiente
// para realizar el cambio de paso independientemente de la direccion que se desea avanzar
// Parámetros de entrada: posicion -> en cual de los 50 pasos estoy
// 						  direccion = 0 -> sentido horario
//						  direccion = 1 -> sentido antihorario
//                        contador -> Saber en que posicion del arreglo estaba
////////////////////////////////////////////////////
void TI1_OnInterrupt(void);
/*
** ===================================================================
**     Event       :  TI1_OnInterrupt (module Events)
**
**     Component   :  TI1 [TimerInt]
**     Description :
**         When a timer interrupt occurs this event is called (only
**         when the component is enabled - <Enable> and the events are
**         enabled - <EnableEvent>). This event is enabled only if a
**         <interrupt service/event> is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/

void AD1_OnEnd(void);
/*
** ===================================================================
**     Event       :  AD1_OnEnd (module Events)
**
**     Component   :  AD1 [ADC]
**     Description :
**         This event is called after the measurement (which consists
**         of <1 or more conversions>) is/are finished.
**         The event is available only when the <Interrupt
**         service/event> property is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/

void Cap1_OnCapture(void);
/*
** ===================================================================
**     Event       :  Cap1_OnCapture (module Events)
**
**     Component   :  Cap1 [Capture]
**     Description :
**         This event is called on capturing of Timer/Counter actual
**         value (only when the component is enabled - <Enable> and the
**         events are enabled - <EnableEvent>.This event is available
**         only if a <interrupt service/event> is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/

void Cap1_OnOverflow(void);
/*
** ===================================================================
**     Event       :  Cap1_OnOverflow (module Events)
**
**     Component   :  Cap1 [Capture]
**     Description :
**         This event is called if counter overflows (only when the
**         component is enabled - <Enable> and the events are enabled -
**         <EnableEvent>.This event is available only if a <interrupt
**         service/event> is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/

/* END Events */
#endif /* __Events_H*/

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
