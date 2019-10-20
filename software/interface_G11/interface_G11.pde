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
  
  int reversa; //define el sentido del recorrido de la linea de posición
  int sw; // conmuta el sentido del recorrido 
  boolean lidar_mode;
  boolean sonar_mode;
  int [][] lidar= new int[72][2];
  int [][] sonar= new int[72][2]; 

  
 
/*{!!--Variables de adquisicion--!!}*/ 
  byte[] inBuffer = new byte[4];             // Se determinan la cantidad de bytes esperados: tamaño de buffer
  Serial myPort;  // Create object from Serial class
  byte [][] datos= new byte[73][4];
  int IR;//Infra Rojo
  int US;// Ultra Sonido
  int counter;
  
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
  dibujo(green); // Se empieza mostrando el SONAR, si se quiere ver el LIDAR se debe presionar el boton
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
    
            if(counter <= 71)
            {
            // /*codigo de prueba*/
            // while(millis()-time < wait) //Timer
            //{ };
            //time=millis();
            //if(prueba[0]==72 ||prueba[0]==0) kk=-kk;
            //prueba[0]=byte(prueba[0]+kk);
            //prueba[3]=byte(prueba[3]+100*pow(-1,counter));
            ////println(int(prueba[0]));
            
            //----fin codigo de prueba-----//
              
            while (myPort.available() > 0 ) {           // Cada vez que haya algo en el puerto se lee
            inBuffer = myPort.readBytes();             // Y se guarda en inBuffer
             myPort.readBytes(inBuffer);
            
            if (inBuffer != null) {
            
            datos[counter]=inBuffer;           //Se almacena en datos la trama con los mensajes
            println(int(datos[counter][0]),int(datos[counter][1]),int(datos[counter][2]),int(datos[counter][3]));
            
            
            
            if(sonar_mode==true){ //Si se presiono el boton SONAR (SONAR se muestra por defecto)
            dibujo(green);        //Refresca la pantalla y muestra todo en verde, cambiar los colores es facil (ir a preambulo)
            strokeWeight(2);          
            stroke(#FFFFFF);
            line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[counter][0])*PI/48+angulo_ini),alto/2+radio*sin(int(datos[counter][0])*PI/48+angulo_ini)); //Linea 
            stroke(#00FF00);
            sonar(datos, sonar, counter); //La funcion sonar recibe los datos, la matriz sonar para guardar los datos e imprimirlos todos en cada ciclo 
                                          // La funcion sonar imprime los circulos y hace el desentramado 
            }

            if(lidar_mode==true){ // Si se presiono el boton LIDAR
            dibujo(red);
            strokeWeight(2);     
            stroke(#FFFFFF);
            line(ancho/2,alto/2,ancho/2+radio*cos(int(datos[counter][0])*PI/48+angulo_ini),alto/2+radio*sin(int(datos[counter][0])*PI/48+angulo_ini));
            lidar(datos, lidar, counter);
            }
            
            
            
            } //fin del if inbuffer
            }//Fin del while myport
             counter++;  //fin del if
            }else counter=0;
    
         
}//Fin del draw
    
     
    




// Funcion encargada de todos los objetos mostrados en pantalla
void dibujo(int Color[])
{
    //clear(); 
    background(0);
  
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
   

    for(int k=1;k<=8;k++){
    strokeWeight(2);
    line(ancho/2+(radio+10)*cos(angulo_ini+k*PI/6),alto/2+(radio+10)*sin(angulo_ini+PI/6*k),ancho/2+(radio+30)*cos(angulo_ini+k*PI/6),alto/2+(radio+30)*sin(angulo_ini+PI/6*k));  
    }
    
    for(int k=1;k<=89;k++){
    stroke(Color[0], Color[1], Color[2]);
    strokeWeight(1);
    line(ancho/2+(radio+15)*cos(angulo_ini+k*PI/60),alto/2+(radio+15)*sin(angulo_ini+PI/60*k),ancho/2+(radio+25)*cos(angulo_ini+k*PI/60),alto/2+(radio+25)*sin(angulo_ini+PI/60*k));
    }
    
    for(int k=0;k<=59;k++){
    stroke(Color[0], Color[1], Color[2]);
    strokeWeight(1);
    line(ancho/2+radio-10*k, 610,ancho/2+radio-10*k, 630);
    }
    fill(Color[0], Color[1], Color[2]);
    textSize(12);
    text("0 cm",ancho/2,645);
    text("80 cm",ancho/2-radio,645);
    text("80 cm",ancho/2+radio,645);
   
    //for(int k=0;k<=59;k++){
    //stroke(Color[0], Color[1], Color[2]);
    //strokeWeight(1);
    //line(130, alto/2+radio-10*k,140 ,alto/2+radio-10*k);
    //}
    //line(0, alto/2+radio,1000 ,alto/2+radio);

    
    boton(500+450,350,"SONAR",500+430,355,green);
    boton(500+450,350+100,"LIDAR",500+430,350+105, red);
    boton(500+450,350+200,"FUSION",500+430,350+205, violet);
    boton(500+450,350+300,"SAVE",500+435,350+305, white);
    
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
    sonar_mode= true;
    lidar_mode= false;
    sonar= new int[72][2];
    dibujo(green);

  }
  //Boton 2
  if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+100-35, 350+100+35)==true){
     println("presionado boton2");
      sonar_mode= false;
      lidar_mode= true;  
      lidar= new int[72][2];
      println(lidar[0]);
      dibujo(red);
      
  }

//  //Boton3
//  if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,195,245)==true)
//  {
//   if(stop==true){
//     stop=false;}else if(stop==false){
//                         stop=true;
//                         x1=10;
//                         x2=10;
//                         dibujo();
//                          }                      
//  }
  //Boton4
    if(buttomPressed(mouseX, mouseY,500+450-35,500+450+35,350+300-35, 350+300+35)==true)
    {
      if(sonar_mode==true) output.println("Posición_radial: "+ sonar[counter][0] + " Posición_ang: " + sonar[counter][1] + " A las "+ hour()+":"+minute()+":"+second()); // Escribe las posiciones de SONAR 
      else if(lidar_mode==true) output.println("Posición_radial: "+ lidar[counter][0] + " Posición_ang: " + lidar[counter][1] + " A las "+ hour()+":"+minute()+":"+second()); // Escribe las posiciones de LIDAR 
      output.flush(); // Escribe la data latente en el archivo
      println("Guardado");
    }
}
//   //Boton5
//    if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,355,405)==true)
//  {
//   if(ch2==true){
//       ch2=false;}else if(ch2==false) ch2=true;
//       x1=10;
//       x2=10;
//       dibujo();
//   }
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

void lidar(byte Datos [][], int Lidar [][], int Counter)
{
            IR=(int((Datos[counter][2] & 31))<< 7) + (int((Datos[counter][3] & 127)));
            IR=IR*16;
            IR=int(2007193.03*pow(IR,-1.201));
            //IR=int(40*sin(second()*PI/40)+40); //PRUEBA
            //println(IR);
            IR=int(map(float(IR),0,80,0,radio));
            Lidar[Counter][0]=IR;
            Lidar[Counter][1]=datos[Counter][0];
            //println(Lidar[Counter][0],Lidar[Counter][1]);
            stroke(#00FF00);
            for(int i=0; i<=Counter;i++){
            if(lidar[i][0]!=0) circle(ancho/2+Lidar[i][0]*cos( Lidar[i][1]*PI/48+angulo_ini),alto/2+Lidar[i][0]*sin(Lidar[i][1]*PI/48+angulo_ini), 10);
            }
}

void sonar(byte Datos [][], int Sonar [][], int Counter)
{
            US=(int((Datos[counter][2] & 31))<< 7) + (int((Datos[counter][3] & 127)));
            US=(int((datos[Counter][1] & 127))<< 2) + (int((datos[Counter][2] & 96))>>5);
            //println((US));
            US=int(US*61.035156/58);
            US=int(map(float(US),0,80,0,radio));
            Sonar[Counter][0]=US;
            Sonar[Counter][1]=datos[Counter][0];
            stroke(#FF0000);
            for(int i=0; i<=Counter;i++){
            if(Sonar[i][0]!=0) circle(ancho/2+Sonar[i][0]*cos( Sonar[i][1]*PI/48+angulo_ini),alto/2+Sonar[i][0]*sin(Sonar[i][1]*PI/48+angulo_ini), 10);
            };
   
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
