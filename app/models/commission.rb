class Commission < ApplicationRecord
  belongs_to :user
  belongs_to :payment

  scope :with_user, -> (user_id) { where(user_id: user_id) }
  scope :before_this_week, -> {
    where('created_at < ?',
            Date.today.beginning_of_week )}
  scope :this_month, -> {
    where('created_at >= ?',
            Date.today.beginning_of_month )}
  scope :last_month, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.last_month.beginning_of_month, 
            Date.today.beginning_of_month )}
  scope :last_2_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(2).beginning_of_month, 
            Date.today.last_month.beginning_of_month )}
  scope :last_3_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(3).beginning_of_month, 
            Date.today.months_ago(2).beginning_of_month )}
  scope :last_4_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(4).beginning_of_month, 
            Date.today.months_ago(3).beginning_of_month )}
  scope :last_5_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(5).beginning_of_month, 
            Date.today.months_ago(4).beginning_of_month )}
end
