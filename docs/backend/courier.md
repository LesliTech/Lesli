# Lesli::Courier

The `Lesli::Courier` module is a dynamic service caller designed to streamline interactions with service classes within a Ruby on Rails application. By enabling dynamic resolution of modules, services, and methods, `Lesli::Courier` simplifies complex service calls into a clean and fluent interface.

## Why Use Lesli::Courier?

1. **Dynamic Module and Service Resolution:** Avoid hardcoding module and service names, making the codebase more flexible and easier to maintain.
2. **Fluent Interface:** Create service calls with a readable, chainable syntax.
3. **Error Handling:** Optional support for handling undefined modules, services, or methods gracefully.
4. **Improved Readability:** Reduce boilerplate code and make service interactions more concise.

<br />

## How It Works

The `Lesli::Courier` module dynamically:

1. Resolves the module name (e.g., `:lesli_test` becomes `LesliTest`).
2. Identifies the service class within the module (e.g., `:ticket_service` becomes `TicketService`).
3. Calls the specified method on the service class, optionally passing arguments.

<br />

## Key Methods

### initialize(module_name, on\_error = nil)
- **Purpose:** Sets the module name to resolve and an optional error handler.
- **Parameters:**
  - `module_name` (Symbol/String): The module to resolve.
  - `on_error` (Object, optional): A fallback value to return if an error occurs (normally if the module is not installed or a method is not defined in the required engine).
- **Example:**

```ruby
    Lesli::Courier.new(:lesli_test)
```

### from(service_name)
- **Purpose:** Specifies the service class within the module.
- **Parameters:** 
    - service_name (Symbol/String): The name of the service class.
- **Example:**

```ruby
    Lesli::Courier.new(:lesli_test).from(:ticket_service)
```

### call(method_name, *args)

- **Purpose:** Specifies the method to be called on the service class and triggers the call.
- **Parameters:** 
    - **method_name:** (Symbol/String): The method to call.
    - **args:** List of arguments to be sent to the specific method
- **Example:** 

```ruby
    Lesli::Courier.new(:lesli_test).from(:ticket_service).call(:index, params)
```

### Error Handling

If any part of the process fails (e.g., the module, service class, or method is not found), Lesli::Courier will return the value specified in the on_error parameter (if provided). Otherwise, it will raise an error.


## Usage Examples

### Basic Usage

```ruby
# Call the `index_with_deadline` method on the `TicketService` class within the `LesliTest` module
Lesli::Courier.new(:lesli_test)
              .from(:ticket_service)
              .call(:index_with_deadline)
```

### Passing Arguments

```ruby
# Call the `index` method on the `TicketService` class, passing arguments
Lesli::Courier.new(:lesli_test)
              .from(:ticket_service)
              .call(:index, current_user, query)
```

### Custom Error Handling

```ruby
# Return a custom error object if the service or method is not found
Lesli::Courier.new(:lesli_test, []).from(:ticket_service).call(:non_existent_method)
```

> Note: In the event of an error, Lesli::Courier will always return false instead of raising an exception.
