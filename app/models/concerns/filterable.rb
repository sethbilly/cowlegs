module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      # creates an anonymous scope
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send("with_#{key}", value) if value.present?
      end
      results.order(created_at: :desc)
    end
  end
end