import RPi.GPIO as GPIO
import time
import sys

control = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,11,12,13,14]
#tempo de deixar a paleta aberta para despejar mais ração
tempo_abertura = float(sys.argv[1])
servo = 22
GPIO.setmode(GPIO.BOARD)
GPIO.setup(servo,GPIO.OUT)

p=GPIO.PWM(servo,50)# 50hz frequency

p.start(2.5)# starting duty cycle ( it set the servo to 0 degree )

for x in range(6): 
 p.ChangeDutyCycle(control[x])
 time.sleep(0.0003)

time.sleep(tempo_abertura)
           
for x in range(5,0,-1):
 p.ChangeDutyCycle(control[x])
 time.sleep(0.3)

time.sleep(0.5)
p.start(2.5)# starting duty cycle ( it set the servo to 0 degree )

