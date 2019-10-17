class UserSubscribersSearch
  attr_reader :date_from, :date_to, :user_id

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], 1.days.ago.to_date.to_s)
    @date_to = parsed_date(params[:date_to], Date.today.to_s)
    @user_id = User.friendly.find(params[:slug]).try(:id)
  end

  def scope
    Farmer.with_user(@user_id).where('farmers.created_at BETWEEN ? AND ?', @date_from, @date_to).order("DATE(farmers.created_at)").group("DATE(farmers.created_at)").count
  end

  private
  
  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end
  
end