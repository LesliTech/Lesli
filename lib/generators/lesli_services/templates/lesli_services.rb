=begin
[[license]]
=end

class [[service_name]] < LesliServices

    # @overwrite
    # @return void
    # @description Finds for the resource by the given ID
    # @example
    def find id
        self.resource = self.current_user.account[[engine]][[object_name_plural]].find_by_id(id)
        self
    end

    # @overwrite
    # @return {Hash} Paginated list of the records
    # @param {query} Has of the formated queries/filters that will be applied to filter data
    # @description
    # @example
    def index query
        self.current_user.account[[engine]][[object_name_plural]]
    end

    # @overwrite
    # @return {Hash} Returns a hash containing the {MISSING}
    # @description Retrives the record by the given ID
    # @example
    def show
        self.resource
    end

    # @overwrite
    # @return {void}
    # @param {params} Hash of the permitted attributes
    # @description
    # @example
    def create params
        new_[[object_name_singular]] = self.current_user.account[[engine]][[object_name_plural]].new(params)

        if new_[[object_name_singular]].save
            self.resource = new_[[object_name_singular]]
            # ACTIVITY LOGS GO HERE
        else
            self.error(new_[[object_name_singular]].errors.full_messages.to_sentence)
        end

        self
    end

    # @overwrite
    # @return {void}
    # @param {params} ... 
    # @description ...
    # @example
    def update params
        old_attributes = self.resource.attributes

        unless self.resource.update(params)
            self.error(self.resource.errors.full_messages.to_sentence)
        end 

        if self.successful?
            # ACTIVITY LOGS GO HERE
        end

        self
    end

    # @overwrite
    # @return {void}
    # @description ...
    # @example
    def destroy
        unless self.resource.destroy
            self.error(self.resource.errors.full_messages.to_sentence)
        end

        if self.successful?
            # ACTIVITY LOGS GO HERE
        end

        self
    end
end
