local task = require('@pkg/luau-task')

local Connection = require('./Connection')
export type Connection = Connection.Connection

export type ConnectableSignal<T...> = {
    connect: (self: ConnectableSignal<T...>, callback: (T...) -> ()) -> Connection,
}

export type Signal<T...> = {
    fire: (self: Signal<T...>, T...) -> (),
    connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
}

type SignalPrivate<T...> = { _callbacks: { (T...) -> () } }
type SignalStatic = {
    new: <T...>() -> Signal<T...>,
    fire: <T...>(self: Signal<T...>, T...) -> (),
    connect: <T...>(self: Signal<T...>, callback: (T...) -> ()) -> Connection,
}

local Signal: SignalStatic = {} :: any
local SignalMetatable = {
    __index = Signal,
}

function Signal.new<T...>(): Signal<T...>
    return setmetatable({
        _callbacks = {},
    }, SignalMetatable) :: any
end

function Signal:fire<T...>(...: T...)
    local self: Signal<T...> & SignalPrivate<T...> = self :: any

    for _, callback in self._callbacks do
        task.spawn(callback, ...)
    end
end

function Signal:connect<T...>(callback: (T...) -> ()): Connection
    local self: Signal<T...> & SignalPrivate<T...> = self :: any

    table.insert(self._callbacks, callback)
    local function unsubscribe()
        local index = table.find(self._callbacks, callback)
        if index then
            table.remove(self._callbacks, index)
        else
            if _G.__DEV__ then
                error('unable to find registered callback')
            end
        end
    end
    return Connection.new(unsubscribe)
end

return Signal
