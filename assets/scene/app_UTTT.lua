local gc=love.graphics
local floor=math.floor

local lines={
    {1,2,3},
    {4,5,6},
    {7,8,9},
    {1,4,7},
    {2,5,8},
    {3,6,9},
    {1,5,9},
    {3,5,7},
}

local board={{},{},{},{},{},{},{},{},{}}
local score={}

local lastX,lastx
local curX,curx
local round
local target
local placeTime
local gameover

local function restart()
    lastX,lastx=false,false
    curX,curx=nil
    round=0
    target=false
    placeTime=love.timer.getTime()
    gameover=false
    for X=1,9 do
        score[X]=false
        for x=1,9 do
            board[X][x]=false
        end
    end
end
local function checkBoard(b,p)
    for i=1,8 do
        local continue
        for j=1,3 do
            if b[lines[i][j]]~=p then
                continue=true
                break
            end
        end
        if not continue then return true end
    end
end
local function full(L)
    for i=1,9 do
        if not L[i] then
            return false
        end
    end
    return true
end
local function place(X,x)
    board[X][x]=round
    FMOD.effect.play('touch')
    lastX,lastx=X,x
    curX,curx=nil
    placeTime=love.timer.getTime()
    if checkBoard(board[X],round) then
        score[X]=round
        if checkBoard(score,round) then
            gameover=round
            FMOD.effect.play('win')
            return
        else
            if full(score) then
                gameover=true
                return
            end
        end
        FMOD.effect.play('reach')
    else
        if full(board[X]) then
            FMOD.effect.play('emit')
            score[X]=true
            if full(score) then
                gameover=true
                return
            end
        end
    end
    if score[x] then
        target=false
    else
        target=x
    end
    round=1-round
end

local scene={}

function scene.enter()
    restart()
    BG.set('rainbow')
end

function scene.mouseMove(x,y)
    x,y=floor((x-280)/80),floor(y/80)
    curX,curx=floor(x/3)+floor(y/3)*3+1,x%3+y%3*3+1
    if
        x<0 or x>8 or
        y<0 or y>8 or
        curX<1 or curX>9 or
        curx<1 or curx>9 or
        score[curX] or
        not (target==curX or not target) or
        board[curX][curx] or
        gameover
    then
        curX,curx=nil
    end
end

function scene.mouseDown(x,y)
    scene.mouseMove(x,y)
    if curX then
        place(curX,curx)
    end
end

scene.touchDown=scene.mouseMove
scene.touchMove=scene.mouseMove
scene.touchUp=scene.mouseDown

function scene.draw()
    gc.push('transform')
    -- origin pos:0,140; scale:4
    gc.translate(280,0)
    gc.scale(8)

    -- Draw board
    gc.setColor(COLOR.dX)
    gc.rectangle('fill',0,0,90,90)

    -- Draw target area
    gc.setColor(1,1,1,math.sin((love.timer.getTime()-placeTime)*5)*.1+.15)
    if target then
        gc.rectangle('fill',(target-1)%3*30,floor((target-1)/3)*30,30,30)
    elseif not gameover then
        gc.rectangle('fill',0,0,90,90)
    end

    -- Draw cursor
    if curX then
        gc.setColor(1,1,1,.3)
        gc.rectangle('fill',(curX-1)%3*30+(curx-1)%3*10-.5,floor((curX-1)/3)*30+floor((curx-1)/3)*10-.5,11,11)
    end

    gc.setLineWidth(.8)
    for X=1,9 do
        if score[X] then
            if score[X]==0 then
                gc.setColor(.5,0,0)
            elseif score[X]==1 then
                gc.setColor(0,0,.5)
            else
                gc.setColor(COLOR.D)
            end
            gc.rectangle('fill',(X-1)%3*30,floor((X-1)/3)*30,30,30)
        end
        for x=1,9 do
            local c=board[X][x]
            if c then
                local _x=(X-1)%3*30+(x-1)%3*10
                local _y=floor((X-1)/3)*30+floor((x-1)/3)*10
                if c==0 then
                    gc.setColor(1,.2,.2)
                    gc.rectangle('line',_x+2.25,_y+2.25,5.5,5.5)
                else
                    gc.setColor(.3,.3,1)
                    gc.line(_x+2,_y+2,_x+8,_y+8)
                    gc.line(_x+2,_y+8,_x+8,_y+2)
                end
            end
        end
    end

    -- Draw board line
    gc.setLineWidth(.8)
    for x=0,9 do
        gc.setColor(1,1,1,x%3==0 and 1 or .3)
        gc.line(10*x,0,10*x,90)
        gc.line(0,10*x,90,10*x)
    end

    -- Draw last pos
    if lastX then
        gc.setColor(.5,1,.4,.8)
        local r=.5+.5*math.sin(love.timer.getTime()*6.26)
        gc.rectangle('line',(lastX-1)%3*30+(lastx-1)%3*10-r,floor((lastX-1)/3)*30+floor((lastx-1)/3)*10-r,10+2*r,10+2*r)
    end
    gc.pop()

    if gameover then
        -- Draw result
        FONT.set(60)
        if gameover==0 then
            gc.setColor(1,.6,.6)
            GC.mStr("RED\nWON",1140,200)
        elseif gameover==1 then
            gc.setColor(.6,.6,1)
            GC.mStr("BLUE\nWON",1140,200)
        else
            gc.setColor(.8,.8,.8)
            GC.mStr("TIE",1140,240)
        end
    else
        -- Draw current round mark
        gc.setColor(COLOR.X)
        gc.rectangle('fill',80,80,160,160)
        gc.setColor(COLOR.L)
        gc.setLineWidth(6)
        gc.rectangle('line',80,80,160,160)

        gc.setLineWidth(10)
        if round==0 then
            gc.setColor(1,0,0)
            gc.rectangle('line',160-40,160-40,80,80)
        else
            gc.setColor(0,0,1)
            gc.line(160-45,160-45,160+45,160+45)
            gc.line(160-45,160+45,160+45,160-45)
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',x=1140,y=540,w=170,h=80,fontSize=60,text=CHAR.icon.retry,color='lG',code=restart},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
