
class ApplicationLesliValidator

    # Set container attributes to manage the life-cycle of the service
    @resource;
    @failures;

    def initialize(resource)

        # stores the resources from the database as result of the active record queries
        @resource = resource

        # stores any error found during the life-cycle of the service object
        @failures = []

        validate()

    end

    def valid?
        yield(failures.empty?, failures) if block_given?
        failures.empty?
    end

    private

    attr_reader :resource
    attr_writer :resource

    attr_reader :failures
    attr_writer :failures

    attr_reader :result
    attr_writer :result

end
