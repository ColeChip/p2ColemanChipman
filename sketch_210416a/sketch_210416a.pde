PImage oil;
PImage tire;
PImage abs;
PImage engine;

void setup()
{
  size(900,600);
  oil = loadImage("oilLeak.png");
  tire = loadImage("tire.png");
  abs = loadImage("abs.png");
  engine = loadImage("engine.png");
}

boolean accelerate = false;
boolean left = false;
boolean right = false;
boolean emergency = false;
boolean cruise = false;
boolean up = false;
boolean down = false;
boolean warning = false;

int oTemp = 65;
int eTemp = 50;
int rpm = 0;
int gear = 0;

float fuel = 100;
float speed = 0.0;
float base = 0;
float cSpeed = 30;

void draw()
{  
  background(0);
  //grid(600,600,20);
  mouseXY();
  text(int(cruise),10,10);
  text(cSpeed,10,30);
  text(int(accelerate),10,50);


  cruiseControl();
  acceleration();
  shifting();
  calTemp();

  speedDisplay();
  fuelgage();
  temps();
  turnSignals();
  cruiseSignal();
  warningSignals();
}


//Visual Functions----------------------------------------------------------------------------------
void mouseXY()  // Debugging Mouse Coordinates
{
  text(mouseX +","+ mouseY, mouseX,mouseY);
}

void arrow(int x, int y, boolean d)  // Turn Signal Arrows
{
  if(d == true) //Right
  {
  fill(255,255,0);
  stroke(255,255,0);
  triangle(x-10,y-20,x+20,y,x-10,y+20);
  rect(x-40,y-5,40,10);
  }
  if(d == false) //left
  {
  fill(255,255,0);
  stroke(255,255,0);
  triangle(x+10,y-20,x-20,y,x+10,y+20);
  rect(x,y-5,40,10);
  }
}

void grid(int x, int y, int s)  // Debugging Grid
{
  int i = 0;
  while (i < x)
  {
    stroke(255);
    line(i*s,0,i*s,y);
    line(0,i*s,x,i*s);
    i++;
  }
}

void speedDisplay()  // Speed Display
{
  if(speed < 10)
  {
    fill(200);
    textSize(100);
    text(0,390,200);
    text(int(speed),450,200);
  }
  if(speed >= 10)
  {
    fill(200);
    textSize(100);
    text(int(speed),390,200);
  }
  textSize(25);
  text("MPH",525,200);
  
  fill(200);
  textSize(50);
  text(rpm,387,250);
  textSize(25);
  text("RPM",525,250);
  
  textSize(50);
  text(gear,432.5,300);
  textSize(25);
  text("Gear",475,300);
}

void fuelgage()  // Fuel Gage Display
{
  fill(200);
  textSize(50);
  text("Fuel",110,125);
  
  textSize(25);  //Fuel Gage 100
  text(100,75,160);
  
  textSize(25);  //Fuel Gage 100
  text(50,90,310);
  
  textSize(25);  //Fuel Gage 100
  text(0,110,450);
  
  textSize(25);  //Fuel Percentage
  text(int(fuel)+"%",135, 475);
  
  fill(255,255,255);
  rect(135,450,50,-300);
  if(fuel > 75)
  {
   fill(0,128,0);
   stroke(0,128,0);
   rect(135,450,50,-fuel*3);
  }
  if(fuel > 50 && fuel <= 75)
  {
    fill(#FFFF00);
    stroke(#FFFF00);
    rect(135,450,50,-fuel*3);
  }
  if(fuel > 25 && fuel <= 50)
  {
    fill(#FF0000);
    stroke(#FFFF00);
    rect(135,450,50,-fuel*3);
  }
  if(fuel <25)
  {
    if(second()%2 != 0)
    {
      fill(#FF0000);
      stroke(#FF0000);
      rect(135,450,50,-fuel*3);
    }
    if(second()%2 == 0)
    {
      fill(#FFFF00);
      stroke(#FFFF00);
      rect(135,450,50,-fuel*3);
    }
  }
}

void temps()  // Temp Display
{
  fill(200);
  textSize(30);
  text("Engine",690,120);
  
  textSize(25); 
  text(275,660,160);
  
  textSize(25);  
  text(125,660,310);
  
  textSize(25);  
  text(50,675,450);
  
  textSize(25);  //Fuel Percentage
  text(int(eTemp+125)+"°",730, 475);
  
  fill(0,128,0);
  rect(715,150,50,300);
  
  fill(255,255,255);
  rect(715,150,50,150-eTemp );
  
  fill(200);
  textSize(25);
  text("Outside Temp",370,525);
  textSize(30);
  text(oTemp+"°",440,550);
  }

void cruiseSignal()
 {
   if(cruise == true)
   {
   textSize(25);
   fill(200);
   text("CC",525,175);
   }
 }
void turnSignals()  // Turn Signal Display
{
  if(right == true)
  {
    if(second()%2 == 0)
      arrow(510,325,true);
  }
  if(left == true)
  {
    if(second()%2 == 0)
      arrow(390,325,false);
  }
}

void warningSignals()
{
  if(warning == true)
  {
    fill(200);
    rect(320,380,200,50);
    
    image(oil,320,380,50,50);
    image(tire,370,380,50,50);
    image(engine,420,380,50,50);
    image(abs, 470,380,50,50);
  }
}

//Logic Functions-------------------------------------------------------------------
void shifting()  // Shifting Function
{
  if ((base <= 40)) //first
  {
    gear = 1;
    rpm = int(base*50)+1000;
  }
  if ((base > 40) && (base <= 100))// Second
  {
    gear = 2;
    rpm = int((base-40)*33.333333)+1000;
  }
  if ((base > 100) && (base <= 200)) // Third
  {
    gear = 3;
    rpm = int((base-100)*20)+1000;
  }  
  if ((base > 200) && (base <= 275)) // Fourth
  {
    gear = 4;
    rpm = int((base-200)*26.66666666)+1000;
  }
  if ((base > 275) && (base <= 325)) // Fifth
  {
    gear = 5;
    rpm = int((base-275)*40)+1000;
  }
  if (base > 325)
  {
    gear = 6;
    rpm = int((base-325)*16)+1000;
  }  
}

void acceleration()  // Acceleration Function
{
  if (accelerate == true)
  {
    fuel = fuel - .05;
    if(base < 450)  // 450 Max Value
    {
    base++;
    }
  }
  
  if (accelerate == false)
  {
    if (base > 0)
    {
      base--;
    }
  }
  
  speed = base/5;
}

void cruiseControl()  // Cruise Control Function
{
  if(cruise == true)
  {    
    if(speed < int(cSpeed)-.25)
    {
      accelerate = true;
    }
    if(speed > int(cSpeed)+.25)
    {
      accelerate = false;
    }
    
    if(up == true)
    {
      cSpeed = cSpeed + .1;
    }
    
    if(down == true)
    {
      cSpeed = cSpeed - .1;
    }
  }
}

void calTemp()
{
  if(accelerate == true)
   {
     if(eTemp < 150)
     {
       eTemp++;
     }
   }
   if(accelerate == false)
   {
     if(eTemp > -50)
     {
       eTemp--;
     }
   }
}

public void keyPressed()
{
  if (key == 'w')
  {
    if(cruise == false) // Normal Driving
    {
      if(fuel > 1)  //Out Of Gas
      {
        accelerate = true;
      }
      if(fuel <= 1)
      {
        accelerate = false;
      }
    }
    if(cruise == true) // Cruise Control Eneabled
    {
      up = true;
    }
  }
  if(key == 'd')
  {
    right = !right;
  }
  if(key == 'a')
  {
  left = !left;
  }
  if(key == 'e')
  {
  emergency = !emergency;
  left = !left;
  right = !right;
  }
  
  if(key == 's')
  {
    if(cruise == true)
    {
    down = true;
    }  
  }
  
  if(key == 'c')
  {
    if(cruise == true)
    {
      accelerate = false;
    }
    if(cruise == false)
    {
      cSpeed = speed;
    }
    cruise = !cruise;
  }
  
  if(key == 'q')
  {
    warning = !warning;
  }
}

public void keyReleased()
{
  if(key == 'w')
  {
    if(cruise == false)
    {
      accelerate = false;
    }  
    if(cruise == true)
    {
      up = false;
    }
  }
  if(key == 's')
  {
    if(cruise == true)
    {
      down = false;
    }
  }
  
}
