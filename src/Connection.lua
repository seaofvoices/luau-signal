export type Connection = {
    disconnect: (self: Connection) -> (),
    disconnectFn: (self: Connection) -> () -> (),
    disconnectOnceFn: (self: Connection) -> () -> (),
}

type Private = {
    _unsubscribe: (() -> ())?,
}
type ConnectionStatic = Connection & Private & {
    new: (unsubscribe: () -> ()) -> Connection,
    fromRobloxConnection: (connection: RBXScriptConnection) -> Connection,
}

local Connection: ConnectionStatic = {} :: any
local SignalConnectionMetatable = {
    __index = Connection,
}

function Connection.new(unsubscribe: () -> ()): Connection
    return setmetatable({
        _unsubscribe = unsubscribe,
    }, SignalConnectionMetatable) :: any
end

if _G.LUA_ENV == 'roblox' then
    function Connection.fromRobloxConnection(connection: RBXScriptConnection): Connection
        return Connection.new(function()
            connection:Disconnect()
        end)
    end
end

function Connection:disconnect()
    local self = self :: Connection & Private
    if self._unsubscribe == nil then
        error('attempt to disconnect a connection twice')
    else
        local unsubscribe = self._unsubscribe
        self._unsubscribe = nil
        unsubscribe()
    end
end

function Connection:disconnectFn(): () -> ()
    return function()
        self:disconnect()
    end
end

function Connection:disconnectOnceFn(): () -> ()
    local self = self :: Connection & Private
    return function()
        if self._unsubscribe ~= nil then
            self:disconnect()
        end
    end
end

return Connection
