import RPi.GPIO as GPIO
import time
import sys

#control = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,11,12,13,14]
control = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10]

#tempo de deixar a paleta aberta para despejar mais ração
tempo_abertura = float(sys.argv[1])

servo = 23
print ("servo: %s" % servo)
GPIO.setmode(GPIO.BOARD)

GPIO.setup(servo,GPIO.OUT)
# in servo motor,
# 1ms pulse for 0 degree (LEFT)
# 1.5ms pulse for 90 degree (MIDDLE)
# 2ms pulse for 180 degree (RIGHT)

# so for 50hz, one frequency is 20ms
# duty cycle for 0 degree = (1/20)*100 = 5%
# duty cycle for 90 degree = (1.5/20)*100 = 7.5%
# duty cycle for 180 degree = (2/20)*100 = 10%

p=GPIO.PWM(servo,50)# 50hz frequency

p.start(2.5)# starting duty cycle ( it set the servo to 0 degree )

for x in range(10): 
 p.ChangeDutyCycle(control[x])
 time.sleep(0.03)

time.sleep(tempo_abertura)
           
for x in range(9,0,-1):
 p.ChangeDutyCycle(control[x])
 time.sleep(0.03)

