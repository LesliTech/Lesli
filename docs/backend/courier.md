# Courier

`Lesli::Courier` resolves an installed module and service at runtime, constructs the service, and calls one of its public methods. It is useful when the caller can operate without an optional engine.

```ruby
result = Lesli::Courier
  .new(:lesli_support, [])
  .from(:ticket_service, current_user, query)
  .call(:index)
```

This resolves `LesliSupport::TicketService`, initializes it with `current_user` and `query`, and calls `index`. If resolution or execution fails, the example returns the fallback value `[]`.

---

## Call Sequence

### Select a module and fallback

```ruby
courier = Lesli::Courier.new(:lesli_support, nil)
```

The module name is camelized, so `:lesli_support` resolves to `LesliSupport`. The second argument is the value returned when the call fails; it defaults to `nil`.

### Select and initialize a service

```ruby
courier.from(:ticket_service, current_user, query)
```

The service name is camelized and resolved inside the selected module. Additional arguments passed to `from` become constructor arguments.

### Call a public method

```ruby
courier.call(:index, params)
```

Arguments passed to `call` are forwarded to the service method as positional arguments.

Courier does not currently forward Ruby keyword arguments. A target method called through Courier should accept positional arguments or an options hash:

```ruby
def find(options = {})
  # Read options[:id] or options[:uid].
end

courier.call(:find, { id: params[:id] })
```

Call the service directly when its public API requires keyword arguments.

---

## Fallback Behavior

Courier rescues errors raised while resolving the module, resolving or constructing the service, and executing the method. It returns the exact fallback passed to the constructor:

```ruby
Lesli::Courier.new(:missing_engine, false)
  .from(:ticket_service)
  .call(:index)
# => false

Lesli::Courier.new(:missing_engine, [])
  .from(:ticket_service)
  .call(:index)
# => []

Lesli::Courier.new(:missing_engine)
  .from(:ticket_service)
  .call(:index)
# => nil
```

Courier does not re-raise execution errors. This makes a fallback convenient for optional integrations, but it can also hide defects raised inside an installed service. Call the service directly when failures must remain visible, or choose a fallback that the caller can distinguish from a successful result.

---

## Safety

Module, service, and method names are dynamically resolved. Use names selected by application code; do not pass raw request parameters into Courier.

Courier checks that the target object responds to the method before calling it. Authorization and account scoping remain the responsibility of the service being invoked.
