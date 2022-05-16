-- Cool liquid background
local gc=love.graphics
local back={}
local shader=SHADER.aura
shader:send('phase',.626)
local t

function back.init()
    t=math.random()*2600
end
function back.update(dt)
    t=t+dt
end
function back.draw()
    gc.clear(.08,.08,.084)
    shader:send('phase',t)
    gc.setShader(shader)
    gc.rectangle('fill',0,0,SCR.w,SCR.h)
    gc.setShader()
end
return back
