local task = require('@pkg/luau-task')

local Connection = require('./Connection')
local Signal = require('./Signal')

type Connection = Connection.Connection

export type Subject<T...> = Signal.Signal<T...>

type Private<T...> = {
    _last: { any },
    _lastLength: number,
}
type PrivateSubject<T...> = Subject<T...> & Private<T...>

type SubjectStatic = {
    new: <T...>(T...) -> Subject<T...>,

    fire: <T...>(self: Subject<T...>, T...) -> (),
    connect: <T...>(self: Subject<T...>, callback: (T...) -> ()) -> Connection,
}

local Subject: SubjectStatic = setmetatable({}, { __index = Signal }) :: any
local SubjectMetatable = {
    __index = Subject,
}

function Subject.new<T...>(...): Subject<T...>
    local self: Private<T...> = Signal.new() :: any

    self._last = { ... }
    self._lastLength = select('#', ...)

    return setmetatable(self, SubjectMetatable) :: any
end

function Subject:fire<T...>(...)
    local self: PrivateSubject<T...> = self :: any

    self._last = { ... }
    self._lastLength = select('#', ...)

    Signal.fire(self :: any, ...)
end

function Subject:connect<T...>(callback: (T...) -> ()): Connection
    local self: PrivateSubject<T...> = self :: any

    task.spawn(callback, unpack(self._last, 1, self._lastLength))

    return Signal.connect(self :: any, callback)
end

return Subject
