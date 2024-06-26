---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('distortion')
    end,
    settings={mino={
        event={
            playerInit="mechLib.mino.hypersonic.event_playerInit_auto(P,'titanium')",
            afterSpawn=mechLib.mino.music.hypersonic_ti_afterSpawn,
            afterClear=mechLib.mino.progress.hypersonic_ti_afterClear,
        },
    }},
}
