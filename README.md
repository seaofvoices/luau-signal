# Luau Signal

A typed Luau signal library.

Signals are a lightweight communication mechanism used to facilitate the exchange of information between different components or modules of a software system. Signals allow parts of a program to notify others without having a dependency on them. This decoupled approach promotes modularity, making it easier to manage and maintain complex systems by broadcasting data in messages without requiring direct knowledge of their recipients.

# Installation

Add `luau-signal` in your dependencies:

```bash
yarn add luau-signal
```

Or if you are using `npm`:

```bash
npm install luau-signal
```

# Example

```lua
local Signal = require('@pkg/luau-signal')

-- re-declare the type for easy access
type Signal<T...> = Signal.Signal<T...>

-- create the signal and optionally declare its type
local mySignal: Signal<string> = Signal.new()

local connection = mySignal:connect(function(param: string)
    print("Signal received:", param)
end)

-- fire the signal
mySignal:fire("Hello, World!")

-- disconnect the callback
connection:disconnect()
```

# API

## Signal

### `Signal.new<T...>(): Signal<T...>`

Creates a new signal instance.

### `Signal:fire<T...>(...: T...)`

Fires the signal, triggering all connected callback functions with the provided arguments.

### `Signal:connect<T...>(callback: (T...) -> ()): Connection`

Connects a callback function to the signal and returns a connection object. This object can be used to disconnect the callback later.

## Connection

### `Connection:disconnect() -> ()`

Disconnects the connection, preventing the associated callback function from being called when the signal fires.

### `Connection:disconnectFn() -> () -> ()`

Returns a function that, when called, disconnects the connection or **throw an error** if it has already been disconnected.

### `Connection:disconnectOnceFn() -> () -> ()`

Returns a function that, when called, checks if the connection is still active before disconnecting it. The returned function will not throw.

## Releases

Versions of the library are also pre-built and linked to [GitHub releases](https://github.com/seaofvoices/luau-disk/releases):

- `signal.rbxm` is a Roblox model file
- `signal-roblox-bundled.lua` is a single-file version of the library (with Luau type annotations removed)

## Other Lua Environments Support

If you would like to use this library on a Lua environment, where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
