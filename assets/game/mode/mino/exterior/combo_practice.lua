---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('oxygen')
    end,
    settings={mino={
        spawnDelay=60,
        clearDelay=120,
        atkSys='modern',
        event={
            playerInit=mechLib.mino.comboPractice.event_playerInit,
            afterDrop=mechLib.mino.comboPractice.event_afterDrop,
            afterLock=mechLib.mino.comboPractice.event_afterLock,
            afterClear={
                mechLib.mino.comboPractice.event_afterClear,
                mechLib.mino.music.combo_practice_afterClear,
                mechLib.mino.progress.combo_practice_afterClear,
            },
            beforeDiscard=mechLib.mino.comboPractice.event_beforeDiscard[200],
            drawOnPlayer=mechLib.mino.comboPractice.event_drawOnPlayer[200],
            gameOver=mechLib.mino.progress.combo_practice_gameOver,
        },
    }},
}
