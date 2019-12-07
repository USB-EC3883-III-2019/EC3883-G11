//----------------------------------//

  /*{!!--Librerías--!!}*/
  
  import processing.serial.*;   // Importamos la libreria Serial
  
  /*{!!--Variables de estilo--!!}*/
    
  int alto, ancho;                           //Dimensiones de la pantalla
  float radio, angulo_ini, angulo_fin;       //Dimensiones de la pantalla
  int [] blue={0, 187, 252};
  int [] green={0, 255, 0};
  int [] violet={255, 0, 255};
  int [] white={255, 255, 255};
  int [] red={247, 0,55};
  
  /*{!!--Variables de graficacion--!!}*/
 
  boolean lidar_mode;
  boolean sonar_mode;
  boolean fusion_mode;
  boolean fusion2_mode;
  boolean master_mode=false;

  int [][] lidar= new int[72][2];
  int [][] sonar= new int[72][2]; 
  int [][] fusion= new int[72][2]; 
  int [][] fusion2= new int[72][2]; 
  boolean stop=false; 
  int bground=0;
  
/*{!!--Variables de adquisicion--!!}*/ 
  byte[] inBuffer = new byte[4];             // Se determinan la cantidad de bytes esperados: tamaño de buffer
  Serial myPort;  // Create object from Serial class
  byte [] datos= new byte[4];
  int ir;//Infra Rojo
  int us;// Ultra Sonido
  int fu;// fusion
  int counter;
  float var_lidar=0.6476;
  float var_sonar=0.2619;
  float var_fusion=1/(1/(var_sonar*var_sonar)+1/(var_lidar*var_lidar));
  PrintWriter output;
 
 /*{!!--Variables de graficacion pantalla incial--!!}*/
 char [] direccion = new char[5];
 char mensaje;
 byte[] mensajeb = new byte[4];
 char mensajef;
 boolean ing_mod =true;
 boolean ing_msj =false;
 boolean ing_dir1= false;
 boolean ing_dir2= false;
 boolean ing_dir3= false;
 boolean ing_dir4= false;
 byte [] trama = new byte[4];
 boolean modo;
 
 /*{!!--Datos a enviar PC->micro--!!}*/

boolean sent=false;
char zona1;
  
/*{!!--Variables de prueba--!!}*/  
  
  //byte [] prueba={72,40,41,50};
  int wait, time;
void setup()
{
  
  size(1000, 700);
  alto = height;
  ancho= width;
  radio=6*alto/(2*7);
  angulo_ini=-(PI+PI/4);
  angulo_fin=PI/4;
  counter=0;
  lidar_mode= false;
  sonar_mode= true;
  fusion_mode= false;
  fusion2_mode= false;
  //dibujo(green,bground); // Se empieza mostrando el SONAR, si se quiere ver el LIDAR se debe presionar el boton

  //output = createWriter("Posiciones.txt"); //se crea el documento donde se guardaran las posiciones cuando se clickee en SAVE
  
  String portName = Serial.list()[0]; 
  //println(Serial.list());
  myPort = new Serial(this, portName, 115200);
  
    wait=100; //# milisegundos
    time=millis();
   
    clear();
    background(0);
    strokeWeight(1); 
    textSize(20);
    text("Elija modo MASTER (up) o modo SLAVE (down)",0,20);
    
   
}
  
void draw() {
  
            if(sent==true){
                enviar(trama);
                println("enviado");
              while(millis()-time < wait) //Timer
              { };
              time=millis();
              println(millis());//Despues de enviar espera wait segundos hasta que recibe
              
                if(myPort.available() > 0 && modo ==false)
                {
                  mensajeb = myPort.readBytes(); 
                  println("trama recibida");
                  println(binary(mensajeb[0]));
                  println(binary(mensajeb[1]));
                  println(binary(mensajeb[2]));
                  println(binary(mensajeb[3]));
                  
                  mensajeb[0]=byte(mensajeb[0] & 15); 
                  mensajeb[0]=byte(mensajeb[0] << 4);
                  mensajeb[1]=byte(mensajeb[1] & 15);
                  mensajef=char(mensajeb[0]+mensajeb[1]);
                  println("MENSAJE RECIBIDO: "+ mensajef);
                  println("MENSAJE RECIBIDO: "+ binary(mensajef));
                }
            }
            
            //dibujo(green,bground);
    
            //if(counter <= 70)
            //{
              
            // /*codigo de prueba*/
            //trama[0]=byte(2);
            
            
            //myPort.write(trama[1]);
            //myPort.write(trama[2]);
            //myPort.write(trama[3]);
           
            
                          //Espera wait segundos
            
          
            
            //if(prueba[0]==72 ||prueba[0]==0) kk=-kk;
            //prueba[0]=byte(prueba[0]+kk);
            //prueba[3]=byte(prueba[3]+100*pow(-1,counter));
            ////println(int(prueba[0]));
            
            //----fin codigo de prueba-----//
              
            /*while (myPort.available() > 0 && stop==false) {           // Cada vez que haya algo en el puerto se lee
             inBuffer = myPort.readBytes();             // Y se guarda en inBuffer
             myPort.readBytes(inBuffer);
            
            if (inBuffer != null) {
                        
            datos=inBuffer;           //Se almacena en datos la trama con los mensajes
            println(int(datos[0]),int(datos[1]),int(datos[2]),int(datos[3]));
            
            stroke(255,255,255);
            if(int(datos[1] & 64)==0){
            bground=#0522AD;
            }else bground=0;;
            stroke(0);
            if(int(datos[0])==71 || int(datos[0])==0) counter=0;
            us=(int((datos[1] & 63))<< 2) + (int((datos[2] & 96))>>5);
            us=int(us*61.035156/58);
            ir=(int((datos[2] & 31))<< 7) + (int((datos[3] & 127)));
            ir=int(387164.943*pow(ir,-1.30997));
            fu=int(var_fusion*(pow(var_sonar,-2)*us+pow(var_lidar,-2)*ir));
            output.println("Sonar_rad: "+ us + " Sonar_ang: " + (int(datos[0])*PI*-3/142+angulo_fin) + ""+ " A las "+ hour()+":"+minute()+":"+second());
            output.println("Lidar_rad: "+ ir + " Lidar_ang: " + (int(datos[0])*PI*-3/142+angulo_fin) + ""+ " A las "+ hour()+":"+minute()+":"+second());
            output.println("Solindar_rad: "+ fu + " Solindar_ang: " + (int(datos[0])*PI*-3/142+angulo_fin)  + ""+ " A las "+ hour()+":"+minute()+":"+second());// Escribe las posiciones de SONAR 
            
            //if(sonar_mode==true){ //Si se presiono el boton SONAR (SONAR se muestra por defecto)
            dibujo(green,bground);        //Refresca la pantalla y muestra todo en verde, cambiar los colores es facil (ir a preambulo)
            strokeWeight(2);          
            stroke(#FFFFFF);
            line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[0])*PI*-3/142+angulo_fin),alto/2+radio*sin(int(datos[0])*PI*-3/142+angulo_fin)); //Linea 
            //stroke(#00FF00);
            if(sonar_mode==true) {sonar(datos, sonar, counter);} //La funcion sonar recibe los datos, la matriz sonar para guardar los datos e imprimirlos todos en cada ciclo 
            if(lidar_mode==true) {lidar(datos, lidar, counter);}
            if(fusion_mode==true) {fusion(datos, fusion, counter);}
            if(fusion2_mode==true){fusion2(datos, fusion2, counter);}
            
            counter++;
            
           // }
            

            //if(lidar_mode==true){ // Si se presiono el boton LIDAR
            //dibujo(green,bground);
            //strokeWeight(2);     
            //stroke(#FFFFFF);
            //line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[0])*PI*3/142+angulo_ini),alto/2+radio*sin(int(datos[0])*PI*3/142+angulo_ini));
            //stroke(#00FF00);
            //lidar(datos, lidar, counter);
            //counter++;
            //}

            //if(fusion_mode==true){ // Si se presiono el boton Fusion
            //dibujo(green,bground);
            //strokeWeight(2);     
            //stroke(#FFFFFF);
            //line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[0])*PI*3/142+angulo_ini),alto/2+radio*sin(int(datos[0])*PI*3/142+angulo_ini));
            //stroke(0, 187, 252);
            //fusion(datos, lidar, counter);
            //counter++;
            //}


            }               //fin del if inbuffer
            }                //Fin del while myport
             
    */
            
                                                                       
            
            
}//Fin del draw
    
     
    




// Funcion encargada de todos los objetos mostrados en pantalla
void dibujo(int Color[],int BG)
{
    //clear();
    background(BG);
    radio=340;
    strokeWeight(1);
    stroke(Color[0], Color[1], Color[2]);
    
    noFill();
    arc(ancho/2, alto/2, alto-20, alto-20,angulo_ini, angulo_fin); 
      
    for(int k=0;k<=7;k++){
    noFill();
    arc(ancho/2, alto/2, alto-100-k*86, alto-100-k*86,angulo_ini, angulo_fin); 
    }
    stroke(Color[0], Color[1], Color[2]);
    point(500,350); 
    
    line(ancho/2,alto/2,ancho/2+340*cos(angulo_ini),alto/2+340*sin(angulo_ini));
    line(ancho/2,alto/2,ancho/2+340*cos(angulo_fin),alto/2+340*sin(angulo_fin));
    for(int k=0;k<=9;k++){
    stroke(Color[0], Color[1], Color[2]);
    line(ancho/2,alto/2,ancho/2+radio*cos(angulo_ini+k*PI/6),alto/2+radio*sin(angulo_ini+PI/6*k));
    }
   

    //for(int k=1;k<=8;k++){
    //strokeWeight(2);
    //line(ancho/2+(radio+10)*cos(angulo_ini+k*PI/6),alto/2+(radio+10)*sin(angulo_ini+PI/6*k),ancho/2+(radio+30)*cos(angulo_ini+k*PI/6),alto/2+(radio+30)*sin(angulo_ini+PI/6*k));  
    //}
    
    //for(int k=1;k<=89;k++){
    //stroke(Color[0], Color[1], Color[2]);
    //strokeWeight(1);
    //line(ancho/2+(radio+15)*cos(angulo_ini+k*PI/60),alto/2+(radio+15)*sin(angulo_ini+PI/60*k),ancho/2+(radio+25)*cos(angulo_ini+k*PI/60),alto/2+(radio+25)*sin(angulo_ini+PI/60*k));
    //}
    
    //for(int k=0;k<=59;k++){
    //stroke(Color[0], Color[1], Color[2]);
    //strokeWeight(1);
    //line(ancho/2+radio-10*k, 610,ancho/2+radio-10*k, 630);
    //}
    fill(Color[0], Color[1], Color[2]);
    textSize(12);
    text("0 cm",ancho/2,645);
    text("80 cm",ancho/2-radio,645);
    text("80 cm",ancho/2+radio,645);
   
    //boton(500+450,350-100,"PAUSE",500+430,355-105,blue);
    boton(500+450,350,"SONAR",500+430,355,red,sonar_mode);
    boton(500+450,350+100,"LIDAR",500+430,350+105, violet,lidar_mode);
    boton(500+450,350+200,"FUSION",500+430,350+205, blue,fusion_mode);
    boton(500+450,350+300,"FUSION2",500+425,350+305, white,fusion2_mode);
    
   //textSize(12);
   //fill(#FFFFFF);
   //for(int i=0;i<=7;i++){
   //text("0 cm",(ancho/2+radio-i*radio/8)*cos(angulo_ini),(alto/2+radio-i*radio/8)*sin(angulo_ini) );
   //}
   
   for(int i=0;i<=7;i++){
   fill(#FFFFFF);
   text(80-10*i+" cm",ancho/2+5+(radio-i*radio/8)*cos(angulo_ini),alto/2+10+(radio-i*radio/8)*sin(angulo_ini));
   }
   
   for(int i=0;i<=9;i++){
   fill(#FFFFFF);
   text(30*i+"°",ancho/2-8+(radio+10)*cos(angulo_ini+i*PI/6),alto/2+(radio+10)*sin(angulo_ini+i*PI/6));
   }
}



boolean buttomPressed(int mousex , int mousey, int mx, int x, int my, int y){ // Esta funcion evalua en qué boton te paraste al momento de clickear
   if((mousey>=my && mousey<= y) && (mousex>=mx && mousex<=x)) return true;  
     else return false;
}


void keyPressed() {
    
    if(keyPressed==true && keyCode==UP && ing_mod==true){   
    textSize(20);
    text("Modo MASTER activado",0,20+20);
    ing_mod=false; 
    modo=true;                             //true es MASTER
    text("Ingrese el mensaje a continuación:",0,20+20+30);
    ing_msj=true;
    keyPressed=false;
    }else if(keyPressed==true && keyCode==DOWN && ing_mod==true )
    {
    textSize(20);
    text("Modo SLAVE activado",0,20+20);
    modo=false;                            //false es SLAVE
    ing_mod=false; 
    trama[0]=byte(128);
    println(binary(trama[0]));
    enviar(trama);
    sent=true;
    keyPressed=false;
    }
    
    if(keyPressed==true && ing_msj==true){
    mensaje=key;
    textSize(20);
    text(mensaje,0,20+20+30+20);
    ing_msj=false; 
    text("Ingrese las zonas",0,20+20+30+40);
    ing_dir1=true;
    keyPressed=false;
    }
    
    
    if(keyPressed==true && ing_dir1==true && (int(key)>=49 && int(key)<=54))
    {
     direccion[0]=key;
     zona1=direccion[0];
     text("Zona 1: "+direccion[0],0,70+20+40);
     ing_dir1=false;
     ing_dir2=true;
     keyPressed=false;
     
    }
    
     if(keyPressed==true && ing_dir2==true && (int(key)>=49 && int(key)<=54))
    {
     direccion[1]=key;
     text("Zona 2: "+direccion[1],0,70+20+20+40);
     ing_dir2=false;
     ing_dir3=true;
     keyPressed=false;
    }
    
     if(keyPressed==true && ing_dir3==true && (int(key)>=49 && int(key)<=54))
    {
     direccion[2]=key;
     text("Zona 3: "+direccion[2],0,70+20+20+20+40);
     ing_dir3=false;
     ing_dir4=true;
     keyPressed=false;
    }
    
      if(keyPressed==true && ing_dir4==true && (int(key)>=49 && int(key)<=54))
    {
     direccion[3]=key;
     text("Zona 4 (fin): "+direccion[3],0,70+20+20+20+20+40);
     //ing_dir4=false;
     keyPressed=false;
     empaqueta(direccion, mensaje);
     enviar(trama);
     sent=true;
     ing_mod = true;
     ing_msj = false;
     ing_dir1= false;
     ing_dir2= false;
     ing_dir3= false;
     ing_dir4= false;
     clear();
     background(0);
     strokeWeight(1); 
     textSize(20);
     text("Elija modo MASTER (up) o modo SLAVE (down)",0,20);
    }
    
    
    
}
void enviar(byte Trama [])
{
  myPort.write(Trama);
   //while(second()-time < wait) //Timer
   //{ };
   //time=second(); 
  //myPort.write(Trama);
  println("MENSAJE: "+ mensaje);
  //if(modo !=false)println("zona "+zona1);
  //println((binary(Trama[0])));
  //println(binary((Trama[1])));
  //println((binary(Trama[2])));
  //println((binary(Trama[3])));
}
  
void empaqueta(char Direccion [], char Mensaje)
{
  
  trama[0]= byte(int(Mensaje) >> 4);
  trama[0]=byte(trama[0]+160);
  println(binary(trama[0]));
  
  Direccion[4]='5';
  //println(char2int(Direccion[4]));
  trama[1]=byte(int(Mensaje) & 15);
  println(binary(trama[1]));
  
  trama[2]=byte(char2int(direccion[1]));
  trama[2]=byte(trama[2]+(char2int(direccion[0]) << 3));
  println(binary(trama[2]));
  
  trama[3]=byte(char2int(direccion[3]));
  trama[3]=byte(trama[3]+(char2int(direccion[2]) << 3));
  println(binary(trama[3]));
  
}
int char2int(char caracter)
{
int entero=0;
switch(caracter) {
    case '1': 
    entero=1;
    break;
    case '2': 
    entero=2;
    break;
    case '3': 
    entero=3;
    break;
    case '4': 
    entero=4;
    break;
    case '5': 
    entero=5;
    break;
    case '6': 
    entero=6;
    break;
}
return entero;
}



void mouseClicked()  // Cada vez que se hace click se llama esta funcion y se evalua que boton fue presionaso y se despliega su funconalidad
{
  //Boton1    
  if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35, 350-35, 350+35 )==true)
  {
    println("presionado boton1");
    //fusion_mode=false;
    if(sonar_mode== true)sonar_mode=false;
    else sonar_mode=true;
    //lidar_mode= false;
    sonar= new int[72][2];
    dibujo(green,bground);

  }
  //Boton 2
  if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+100-35, 350+100+35)==true){
     println("presionado boton2");
      //sonar_mode= false;
      //fusion_mode=false;
      if(lidar_mode== true)lidar_mode=false;
    else lidar_mode=true;
       lidar= new int[72][2];
      //println(lidar[0]);
      dibujo(green,bground);
      
  }

  //Boton3
  //if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350-100-35,350-100+35)==true)
  //{
  //   if(stop==true) {stop=false;
  //   sonar= new int[72][2];
  //   lidar= new int[72][2]; 
  //   fusion= new int[72][2];
  // }
  //   else if(stop==false){
  //                         stop=true;
  //                         sonar= new int[72][2];
  //                         lidar= new int[72][2]; 
  //                         fusion= new int[72][2];
  //                         println("Pause");  
                           
  //                       }
                            
  //}
  //Boton4
    if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+300-35, 350+300+35)==true)
    {
       if(fusion2_mode== true)fusion2_mode=false;
       else fusion2_mode=true;
       fusion2= new int[72][2];
       dibujo(green,bground);
      
      
      //output.println("Sonar_rad: "+ sonar[counter][0] + " Sonar_ang: " + sonar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
      //output.println("Lidar_rad: "+ lidar[counter][0] + " Lidar_ang: " + lidar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
      //output.println("Solindar_rad: "+ fusion[counter][0] + " Solindar_ang: " + fusion[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());// Escribe las posiciones de SONAR 
      //output.flush(); // Escribe la data latente en el archivo
      //println("Guardado");
    }

   //Boton5
    if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+200-35, 350+200+35)==true) 
  {
      //println("presionado boton 3");
      //if(sonar_mode==true) sonar_mode=false;
      //else if(lidar_mode==true) lidar_mode=false;
      if(fusion_mode== true)fusion_mode=false;
      else fusion_mode=true;
      fusion= new int[72][2];
      dibujo(green,bground);
   }

      //Boton6
    if(buttomPressed(mouseX, mouseY, 450-35,450+35, 350-35,350+35)==true)
  {
   
    println("Presionado boton master");
    master_mode=true;
    
   }
   
}
//      //Boton7
//    if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,515,565)==true)
//  {
//   if(ch4==true)
//       ch4=false;
//else if(ch4==false) ch4=true;
  
//       x1=10;
//       x2=10;
//       dibujo();
//   }
//}

void lidar(byte Datos [], int Lidar [][], int Counter)
{
            ir=(int((Datos[2] & 31))<< 7) + (int((Datos[3] & 127)));
            ir=int(387164.943*pow(ir,-1.30997));//int(23045.73065*pow(ir,-1.015));
            ir=int(map(float(ir),0,80,0,340));
         
            if(ir>340){
            fill(#FFFFFF);
            textSize(20);
            text("Fuera del rango",ancho/2-75,580);
            ir=340;}else fill(0);
             textSize(12);
            Lidar[Counter][0]=ir;
            Lidar[Counter][1]=Datos[0];
            
            stroke(violet[0],violet[1],violet[2]);
            
            for(int i=0; i<=Counter;i++){
            if(Lidar[i][0]!=0) circle(ancho/2+Lidar[i][0]*cos( Lidar[i][1]*PI*-3/142+angulo_fin),alto/2+Lidar[i][0]*sin(Lidar[i][1]*PI*-3/142+angulo_fin), 10);
            };
            
            if(int(Datos[1] & 64)==0){
            fill(#FFFFFF);
           
            text("Filter OFF",ancho/2-10,680);
            }else {fill(#FFFFFF);
            text("Filter ON",ancho/2-10,680);}
            fill(0);
}

void sonar(byte Datos [], int Sonar [][], int Counter)
{
            us=(int((Datos[1] & 63))<< 2) + (int((Datos[2] & 96))>>5);
            //println((US));
            us=int(us*61.035156/58);
            us=int(map(float(us),0,80,0,340));
            
            if(us>340){
            fill(#FFFFFF);
            textSize(20);
            text("Fuera del rango",ancho/2-75,580);
            us=340;}else   fill(0);
            Sonar[Counter][0]=us;
            Sonar[Counter][1]=Datos[0];
            textSize(12);
            stroke(#FF0000);
            
            for(int i=0; i<=Counter;i++){
            if(Sonar[i][0]!=0) circle(ancho/2+Sonar[i][0]*cos( Sonar[i][1]*PI*-3/142+angulo_fin),alto/2+Sonar[i][0]*sin(Sonar[i][1]*PI*-3/142+angulo_fin), 10);
            };
             
            if(int(Datos[1] & 64)==0){
            fill(#FFFFFF);
            text("Filter OFF",ancho/2-10,680);
            }else {fill(#FFFFFF);
            text("Filter ON",ancho/2-10,680);}
            fill(0);
}

void fusion(byte Datos [], int Fusion [][], int Counter)
{
            us=(int((Datos[1] & 63))<< 2) + (int((Datos[2] & 96))>>5);
            us=int(us*61.035156/58);
            //us=int(map(float(us),0,80,0,340));
            
            ir=(int((Datos[2] & 31))<< 7) + (int((Datos[3] & 127)));
            ir=int(387164.943*pow(ir,-1.30997));//int(23045.73065*pow(ir,-1.015));
            //ir=int(map(float(ir),0,80,0,340));
            
            //fu=int(abs(float(ir-us)));
            fu=int(var_fusion*(pow(var_sonar,-2)*us+pow(var_lidar,-2)*ir));
            //if(fu>=3) fu=int(map(float(ir),0,80,0,340));
            //else {
            //  fu=int(map(float(us),0,80,0,340));
            //}
            fu=int(map(float(fu),0,80,0,340));
            if(fu>340){fu=340;
            fill(#FFFFFF);
            textSize(20);
            text("Fuera del rango",ancho/2-75,580);
             }else fill(0);
            textSize(12);
            Fusion[Counter][0]=fu;
            Fusion[Counter][1]=Datos[0];
            
            stroke(0, 187, 252);
            for(int i=0; i<=Counter;i++){
            if(Fusion[i][0]!=0) {circle(ancho/2+Fusion[i][0]*cos(Fusion[i][1]*PI*-3/142+angulo_fin),alto/2+Fusion[i][0]*sin(Fusion[i][1]*PI*-3/142+angulo_fin), 10);}
            };
            
            textSize(12);
            if(int(Datos[1] & 64)==0){
            fill(#FFFFFF);
            text("Filter OFF",ancho/2-10,680);
            }else {fill(#FFFFFF);
            text("Filter ON",ancho/2-10,680);}
            fill(0);
}
 
 

void fusion2(byte Datos [], int Fusion2 [][], int Counter)
{
            us=(int((Datos[1] & 63))<< 2) + (int((Datos[2] & 96))>>5);
            us=int(us*61.035156/58);
            //us=int(map(float(us),0,80,0,340));
            
            ir=(int((Datos[2] & 31))<< 7) + (int((Datos[3] & 127)));
            ir=int(387164.943*pow(ir,-1.30997));//int(23045.73065*pow(ir,-1.015));
            //ir=int(map(float(ir),0,80,0,340));
            
            fu=int(abs(float(ir-us)));
            //fu=int(var_fusion*(pow(var_sonar,-2)*us+pow(var_lidar,-2)*ir));
            if(fu>=3) fu=int(map(float(ir),0,80,0,340));
            else {
              fu=int(map(float(us),0,80,0,340));
            }
            if(fu>340){fu=340;
            fill(#FFFFFF);
            textSize(20);
            text("Fuera del rango",ancho/2-75,580);
             }else fill(0);
            textSize(12);
            Fusion2[Counter][0]=fu;
            Fusion2[Counter][1]=Datos[0];
            
            stroke(#FFFFFF);
            for(int i=0; i<=Counter;i++){
            if(Fusion2[i][0]!=0) {circle(ancho/2+Fusion2[i][0]*cos(Fusion2[i][1]*PI*-3/142+angulo_fin),alto/2+Fusion2[i][0]*sin(Fusion2[i][1]*PI*-3/142+angulo_fin), 10);}
            };
            
            textSize(12);
            if(int(Datos[1] & 64)==0){
            fill(#FFFFFF);
            text("Filter OFF",ancho/2-10,680);
            }else {fill(#FFFFFF);
            text("Filter ON",ancho/2-10,680);}
            fill(0);
}


void boton(int x, int y, String texto, int xt, int yt, int [] Color, boolean btn_on)  //dibujar un bonton
{
  
  if(btn_on==true)
  {
  stroke(0);
  fill(Color[0],Color[1],Color[2]);
  ellipse(x,y,70,70);
  fill(0);
  textSize(12);
  text(texto,xt,yt);
  }
  else
  {
      stroke(0);
  fill(#898989);
  ellipse(x,y,70,70);
  fill(0);
  textSize(12);
  text(texto,xt,yt);
  }
}
