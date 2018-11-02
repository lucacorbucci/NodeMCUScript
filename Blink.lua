-- your first lua script working on LED

lighton=0
pin=4
gpio.mode(pin,gpio.OUTPUT) -- Assign GPIO to Output
tmr.alarm(1,2000,1,function()
    if lighton==0 then
        lighton=1
        gpio.write(pin,gpio.HIGH) -- Assign GPIO On
    else
        lighton=0
         gpio.write(pin,gpio.LOW) -- Assign GPIO off
    end
end)
