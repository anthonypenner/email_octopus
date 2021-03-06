# frozen_string_literal: true

module EmailOctopus
  # Runs a query on model data.
  class Query
    def initialize(model)
      @model = model
      @api = API.new(EmailOctopus.config.api_key)
    end

    def limit(num)
      @limit = num
      self
    end

    def page(num)
      @page = num
      self
    end

    def each
      results.each { |result| yield result }
    end

    private

    def results
      @api.get(path).body['data'].map { |params| @model.new(params) }
    end

    def path
      "/#{@model.resource_name}?#{params}"
    end

    def params
      URI.encode_www_form(attributes)
    end

    def attributes
      {
        limit: @limit,
        page: @page
      }.each_with_object({}) do |memo, (key, val)|
        memo[key] = val unless val.nil?
      end
    end
  end
end
