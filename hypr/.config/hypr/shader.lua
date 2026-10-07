-- /home/lucy/.config/hypr/shader.lua

local home = os.getenv("HOME")
local einkShaderPath = home .. "/dotfiles/hypr/shaders/eink.frag"
local einkShaderOn = false

local M = {}

function M.toggle_eink()
    einkShaderOn = not einkShaderOn

    if einkShaderOn then
        hl.config({
            decoration = {
                shadow = { enabled = false },
                blur = { enabled = false },
            },
            animations = { enabled = false },
            debug = { damage_tracking = 0 },
        })
        hl.config({ decoration = { screen_shader = einkShaderPath } })
    else
        hl.config({ decoration = { screen_shader = "" } })
        hl.config({
            decoration = {
                shadow = { enabled = true },
                blur = { enabled = true },
            },
            animations = { enabled = true },
            debug = { damage_tracking = 2 },
        })
    end
end

return M