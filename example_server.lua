local cs = require 'cs'
local server = cs.server


server.enabled = true
server.start('22122') -- Port of server


-- Server has many clients connecting to it. Each client has a unique `id` to identify it.
--
-- `server.share` represents shared state that the server can write to and all clients can read
-- from. `server.homes[id]` each represents state that the server can read from and client with
-- that `id` can write to (clients can't see each other's homes). Thus the server gets data
-- from each client and combines them for all clients to see.
--
-- Server can also receive individual messages from `client.send(...)` on client.


local share = server.share -- Maps to `client.share` -- can write
local homes = server.homes -- `homes[id]` maps to `client.home` for that `id` -- can read


function server.connect(id) -- Called on connect from client with `id`
end

function server.disconnect(id) -- Called on disconnect from client with `id`
end

function server.receive(id, ...) -- Called on `client.send(...)` from client with `id`
end


-- Server only gets `.load` and `.update` Love events

function server.load()
    share.mice = {}
end

function server.update(dt)
    for id, home in pairs(server.homes) do -- Combine mouse info from clients into share
        local mouse = share.mice[id]
        if mouse then -- Don't create new tables unnecessarily
            mouse.x, mouse.y = home.mouse.x, home.mouse.y
        else
            share.mice[id] = home.mouse
        end
    end
end