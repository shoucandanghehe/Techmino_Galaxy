return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_simp',
        shakeness=0,
        readyDelay=0,
        dropDelay=1e99,
        lockDelay=1e99,
        holdSlot=0,
        nextSlot=0,
    }},
}
