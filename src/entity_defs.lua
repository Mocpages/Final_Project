--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {4, 5, 6},
                interval = 0.15,
                texture = 'soldiers'
            },
            ['walk-right'] = {
                frames = {7, 8, 9},
                interval = 0.15,
                texture = 'soldiers'
            },
            ['walk-down'] = {
                frames = {1, 2, 3},
                interval = 0.15,
                texture = 'soldiers'
            },
            ['walk-up'] = {
                frames = {10, 11, 12},
                interval = 0.15,
                texture = 'soldiers'
            },
            ['idle-left'] = {
                frames = {5},
                texture = 'soldiers'
            },
            ['idle-right'] = {
                frames = {8},
                texture = 'soldiers'
            },
            ['idle-down'] = {
                frames = {2},
                texture = 'soldiers'
            },
            ['idle-up'] = {
                frames = {11},
                texture = 'soldiers'
            }
        }
    }
}