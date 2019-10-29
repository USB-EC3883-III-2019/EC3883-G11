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
  int [][] lidar= new int[72][2];
  int [][] sonar= new int[72][2]; 
  int [][] fusion= new int[72][2]; 
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
 
  
/*{!!--Variables de prueba--!!}*/  
  
  //byte [] prueba={72,40,41,50};
  //int wait, time;
  //int kk=-1;
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
  dibujo(green,bground); // Se empieza mostrando el SONAR, si se quiere ver el LIDAR se debe presionar el boton
                 // Green es el color de los arcos y lineas que se dibujan 
  output = createWriter("Posiciones.txt"); //se crea el documento donde se guardaran las posiciones cuando se clickee en SAVE
  
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 115200);
   //wait=10;
   //time=millis();
   //prueba[0]=0;
   //prueba[3]=byte(1010010);
}
  
void draw() {
    
            //if(counter <= 70)
            //{
            // /*codigo de prueba*/
            // while(millis()-time < wait) //Timer
            //{ };
            //time=millis();
            //if(prueba[0]==72 ||prueba[0]==0) kk=-kk;
            //prueba[0]=byte(prueba[0]+kk);
            //prueba[3]=byte(prueba[3]+100*pow(-1,counter));
            ////println(int(prueba[0]));
            
            //----fin codigo de prueba-----//
              
            while (myPort.available() > 0 && stop==false) {           // Cada vez que haya algo en el puerto se lee
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
            
            //if(sonar_mode==true){ //Si se presiono el boton SONAR (SONAR se muestra por defecto)
            dibujo(green,bground);        //Refresca la pantalla y muestra todo en verde, cambiar los colores es facil (ir a preambulo)
            strokeWeight(2);          
            stroke(#FFFFFF);
            line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[0])*PI*3/142+angulo_ini),alto/2+radio*sin(int(datos[0])*PI*3/142+angulo_ini)); //Linea 
            //stroke(#00FF00);
            if(sonar_mode==true) {sonar(datos, sonar, counter); println("entro sonar");} //La funcion sonar recibe los datos, la matriz sonar para guardar los datos e imprimirlos todos en cada ciclo 
            if(lidar_mode==true) {lidar(datos, lidar, counter); println("entro lidar");}
            if(fusion_mode==true) {fusion(datos, fusion, counter);}
            sonar[counter][0]=int(map(float(sonar[counter][0]),0,340,0,80));
            lidar[counter][0]=int(map(float(lidar[counter][0]),0,340,0,80));
            fusion[counter][0]=int(map(float(fusion[counter][0]),0,340,0,80));
             output.println("Sonar_rad: "+ sonar[counter][0] + " Sonar_ang: " + sonar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
             output.println("Lidar_rad: "+ lidar[counter][0] + " Lidar_ang: " + lidar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
             output.println("Solindar_rad: "+ fusion[counter][0] + " Solindar_ang: " + fusion[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());// Escribe las posiciones de SONAR 
            sonar[counter][0]=int(map(float(sonar[counter][0]),0,80,0,340));
            lidar[counter][0]=int(map(float(lidar[counter][0]),0,80,0,340));
            fusion[counter][0]=int(map(float(fusion[counter][0]),0,80,0,340));
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
    boton(500+450,350,"SONAR",500+430,355,red);
    boton(500+450,350+100,"LIDAR",500+430,350+105, violet);
    boton(500+450,350+200,"FUSION",500+430,350+205, blue);
    boton(500+450,350+300,"SAVE",500+435,350+305, white);
    
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
      println(lidar[0]);
      dibujo(green,bground);
      
  }

  //Boton3
  if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350-100-35,350-100+35)==true)
  {
     if(stop==true) {stop=false;
     sonar= new int[72][2];
     lidar= new int[72][2]; 
     fusion= new int[72][2];
   }
     else if(stop==false){
                           stop=true;
                           sonar= new int[72][2];
                           lidar= new int[72][2]; 
                           fusion= new int[72][2];
                           println("Pause");  
                           
                         }
                            
  }
  //Boton4
    //if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+300-35, 350+300+35)==true)
    //{
    //  output.println("Sonar_rad: "+ sonar[counter][0] + " Sonar_ang: " + sonar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
    //  output.println("Lidar_rad: "+ lidar[counter][0] + " Lidar_ang: " + lidar[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());
    //  output.println("Solindar_rad: "+ fusion[counter][0] + " Solindar_ang: " + fusion[counter][1]+ ""+ " A las "+ hour()+":"+minute()+":"+second());// Escribe las posiciones de SONAR 
    //  output.flush(); // Escribe la data latente en el archivo
    //  println("Guardado");
    //}

   //Boton5
    if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+200-35, 350+200+35)==true) 
  {
      println("presionado boton 3");
      //if(sonar_mode==true) sonar_mode=false;
      //else if(lidar_mode==true) lidar_mode=false;
      if(fusion_mode== true)fusion_mode=false;
      else fusion_mode=true;
      fusion= new int[72][2];
      dibujo(green,bground);
   }
}
//      //Boton6
//    if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,435,485)==true)
//  {
//   if(ch3==true){
//       ch3=false;}else if(ch3==false) ch3=true;
//       x1=10;
//       x2=10;
//       dibujo();
//   }
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
            
            Lidar[Counter][0]=ir;
            Lidar[Counter][1]=Datos[0];
            
            stroke(violet[0],violet[1],violet[2]);
            
            for(int i=0; i<=Counter;i++){
            if(Lidar[i][0]!=0) circle(ancho/2+Lidar[i][0]*cos( Lidar[i][1]*PI/47.5+angulo_ini),alto/2+Lidar[i][0]*sin(Lidar[i][1]*PI/47.5+angulo_ini), 10);
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
            
            stroke(#FF0000);
            
            for(int i=0; i<=Counter;i++){
            if(Sonar[i][0]!=0) circle(ancho/2+Sonar[i][0]*cos( Sonar[i][1]*PI/47.5+angulo_ini),alto/2+Sonar[i][0]*sin(Sonar[i][1]*PI/47.5+angulo_ini), 10);
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
            
            Fusion[Counter][0]=fu;
            Fusion[Counter][1]=Datos[0];
            
            stroke(0, 187, 252);
            for(int i=0; i<=Counter;i++){
            if(Fusion[i][0]!=0) {circle(ancho/2+Fusion[i][0]*cos(Fusion[i][1]*PI/47.5+angulo_ini),alto/2+Fusion[i][0]*sin(Fusion[i][1]*PI/47.5+angulo_ini), 10);}
            };
            
            textSize(12);
            if(int(Datos[1] & 64)==0){
            fill(#FFFFFF);
            text("Filter OFF",ancho/2-10,680);
            }else {fill(#FFFFFF);
            text("Filter ON",ancho/2-10,680);}
            fill(0);
}
 


void boton(int x, int y, String texto, int xt, int yt, int [] Color)  //dibujar un bonton
{
  stroke(0);
  fill(Color[0],Color[1],Color[2]);
  ellipse(x,y,70,70);
  fill(0);
  textSize(12);
  text(texto,xt,yt);
}
