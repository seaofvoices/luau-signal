local Connection = require('./Connection')
local Signal = require('./Signal')

export type Connection = Connection.Connection
export type Signal<T...> = Signal.Signal<T...>

return Signal
