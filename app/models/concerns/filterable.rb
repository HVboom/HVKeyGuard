# Idea taken from: https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
#
# Call scopes directly from your URL params:
#
#     @products = Product.filter_by(params.slice(:status, :location, :starts_with))
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods

    # Call the class methods with the same name as the keys in <tt>filtering_params</tt>
    # with their associated values. Most useful for calling named scopes from
    # URL params. Make sure you don't pass stuff directly from the web without
    # whitelisting only the params you care about first!
    def filter_by(filtering_params)
      results = self.where(nil) # create an anonymous scope
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
