# Courier

`Lesli::Courier` resolves an installed module and service at runtime, constructs the service, and calls one of its public methods. It is useful when the caller can operate without an optional engine.

```ruby
result = Lesli::Courier
  .new(:lesli_support, [])
  .from(:ticket_service, current_user, query)
  .call(:index)
```

This resolves `LesliSupport::TicketService`, initializes it with `current_user` and `query`, and calls `index`. If the optional `LesliSupport` module is unavailable, the example returns the fallback value `[]`.

---

## Call Sequence

### Select a module, fallback, and error behavior

```ruby
courier = Lesli::Courier.new(:lesli_support, nil)
```

The module name is camelized, so `:lesli_support` resolves to `LesliSupport`. The second argument is the fallback returned when that module is unavailable; it defaults to `nil`.

Errors from an installed engine propagate by default. Set `fallback_on_error: true` when an integration is optional and the calling feature should continue working if it fails:

```ruby
courier = Lesli::Courier.new(
  :lesli_support,
  [],
  fallback_on_error: true
)
```

### Select and initialize a service

```ruby
courier.from(:ticket_service, current_user, query)
```

The service name is camelized and resolved inside the selected module. Positional and keyword arguments passed to `from` become constructor arguments.

### Call a public method

```ruby
courier.call(:index, params)
```

Positional and keyword arguments passed to `call` are forwarded to the service method:

```ruby
result = Lesli::Courier
  .new(:lesli_support)
  .from(:ticket_service, current_user, query, include_archived: false)
  .call(:find, id: params[:id])
```

Courier invokes instance methods. This works for service objects and models that are constructed before use. It does not invoke class methods or model scopes directly:

```ruby
class TicketService
  def find(id:)
    Ticket.find(id)
  end
end
```

Expose the required operation as a public instance method when integrating through Courier.

---

## Error Behavior

Courier returns the exact fallback passed to the constructor only when the optional module is unavailable:

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

Once the module is installed, its classes and public methods are part of the integration contract. A missing service or method, as well as errors raised while constructing or executing the service, propagate normally so implementation defects remain visible.

### Continue when an optional integration fails

Use `fallback_on_error: true` when the integration contributes optional information and should not prevent the primary feature from working:

```ruby
support_events = Lesli::Courier
  .new(:lesli_support, [], fallback_on_error: true)
  .from(:ticket_service, current_user, query)
  .call(:index_with_deadline)
```

With this option enabled, Courier catches `StandardError` exceptions raised while resolving the service, constructing it, or invoking its method. The error is reported through `Rails.error` as handled, including the module, service, and method names, and Courier returns the configured fallback.

This allows Calendar, for example, to keep displaying its own events when Support cannot provide ticket deadlines. Leave the option disabled for integrations where failure should stop the request.

---

## Safety

Module, service, and method names are dynamically resolved. Use names selected by application code; never pass request parameters into Courier to select a constant or method.

Courier invokes the selected method with `public_send`. Authorization and account scoping remain the responsibility of the service being invoked.
