class Card < ApplicationRecord
  belongs_to :farmer

  scope :before_this_week, -> {
    where( 'created_at < ?',
            Date.today.beginning_of_week )}
end
