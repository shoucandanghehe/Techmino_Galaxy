local gc=love.graphics
local lineTarget=20
local bgmTransBegin,bgmTransFinish=5,20
local maxHeight=4
local randomCount=4

local function generateField(P)
    local F=P.field
    local w=P.settings.fieldW
    local r0,r1=0
    TABLE.cut(F._matrix)
    for y=1,maxHeight do
        F._matrix[y]=TABLE.new(false,w)
        repeat
            r1=P.seqRND:random(1,w)
        until math.abs(r1-r0)>=2;
        F._matrix[y][r1]={color=0,conn={}}
        r0=r1
    end
    for _=1,randomCount do
        local x,y
        repeat
            x=P.seqRND:random(1,w)
            y=math.floor(P.seqRND:random()^2.6*(maxHeight-1))+1
        until not F._matrix[y][x]
        F._matrix[y][x]={color=0,conn={}}
    end
    for y=1,maxHeight do
        if TABLE.count(F._matrix[y],false)==w then
            F._matrix[y][P.seqRND:random(1,w)]=false
        end
    end
end

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                P.modeData.line=0
                generateField(P)
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                generateField(P)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}