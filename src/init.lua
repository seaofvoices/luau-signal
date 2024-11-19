local Connection = require('./Connection')
local Signal = require('./Signal')
local Subject = require('./Subject')

export type Connection = Connection.Connection
export type Signal<T...> = Signal.Signal<T...>
export type ConnectableSignal<T...> = Signal.ConnectableSignal<T...>

return {
    new = Signal.new,
    newSubject = Subject.new,
}
