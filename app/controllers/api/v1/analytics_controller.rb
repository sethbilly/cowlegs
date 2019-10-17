class Api::V1::AnalyticsController < ApplicationController
  before_action :authenticate_user!
  
  def activations_search
    @search = ActivationsSearch.new(range_params)
    data = []
    total = 0
    activations = @search.scope
    activations.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def user_activations_search
    @search = UserActivationsSearch.new(range_params)
    data = []
    total = 0
    activations = @search.scope
    activations.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def subscribers_search
    @search = SubscribersSearch.new(range_params)
    data = []
    total = 0
    subscribers = @search.scope
    subscribers.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def user_subscribers_search
    @search = UserSubscribersSearch.new(range_params)
    data = []
    total = 0
    subscribers = @search.scope
    subscribers.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def revenue_search
    @search = RevenueSearch.new(range_params)
    data = []
    total = 0
    revenue = @search.scope
    revenue.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def user_revenue_search
    @search = UserRevenueSearch.new(range_params)
    data = []
    total = 0
    revenue = @search.scope
    revenue.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value * 10
      })
      total += value * 10
    end

    render json: { total: total, data: data }
  end

  def subscriptions_revenue_search
    @search = SubscriptionsRevenueSearch.new(range_params)
    data = []
    total = 0
    revenue = @search.scope
    revenue.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def vaccine_deliveries_revenue_search
    @search = VaccineDeliveriesRevenueSearch.new(range_params)
    data = []
    total = 0
    revenue = @search.scope
    revenue.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: value
      })
      total += value
    end

    render json: { total: total, data: data }
  end

  def commission_on_vaccine_deliveries_revenue_search
    @search = VaccineDeliveriesRevenueSearch.new(range_params)
    data = []
    total = 0
    revenue = @search.scope
    revenue.each do |key, value|
      data.push({
        name: key.strftime("%d %b %Y"),
        value: 0.1 * value
      })
      total += 0.1 * value
    end

    render json: { total: total, data: data }
  end

	def admin_dashboard_stats
		data = {}
		if current_user.role == 'admin'
			total_subscribers = Farmer.count
			total_subscribers_bf_this_week = Farmer.before_this_week.count
			
			total_activations = Subscription.count
			total_activations_bf_this_week = Subscription.before_this_week.count
			
			total_expired_subscribers = Subscription.expired.count
			total_expired_subscribers_bf_this_week = Subscription.expired_before_this_week.count

			total_cards = Card.count
			total_cards_bf_this_week = Card.before_this_week.count

			total_collections = Payment.sum(:payment_fee)
			total_collections_bf_this_week = Payment.before_this_week.sum(:payment_fee)

			total_reactivations = Subscription.with_type(1).count
			total_reactivations_bf_this_week = Subscription.before_this_week.with_type(1).count

			subscriptions_by_region_data = []
			Region.find_each do |region|
				subscriptions_by_region_data.push({
					x: region.name[/(.*)\s/,1], # remove last word 'Region'
					y: Subscription.where({ farmer_id: Farmer.where({ region_id: region.id }).pluck(:id) }).count
				})
			end

			subscriptions_by_agent_data = []
			agents = Subscription.pluck(:user_id).uniq
			agents.each do |user_id|
				user = User.find_by_id(user_id)
				unless user.nil?
					subscriptions_by_agent_data.push({
						x: user.first_name + ' ' + user.last_name,
						y: user.subscriptions.count,
					})
				end
			end
			
			data.tap do |h|
				h[:total_subscribers] = {
					total: total_subscribers,
					percent_change: Percentage.change(total_subscribers_bf_this_week, total_subscribers)
				}
				h[:total_activations] = {
					total: total_activations,
					percent_change: Percentage.change(total_activations_bf_this_week, total_activations)
				}
				h[:total_expired_subscribers] = {
					total: total_expired_subscribers,
					percent_change: Percentage.change(total_expired_subscribers_bf_this_week, total_expired_subscribers)
				}
				h[:total_cards] = {
					total: total_cards,
					percent_change: Percentage.change(total_cards_bf_this_week, total_cards)
				}
				h[:total_collections] = {
					total: total_collections,
					percent_change: Percentage.change(total_collections_bf_this_week, total_collections)
				}
				h[:total_reactivations] = {
					total: total_reactivations,
					percent_change: Percentage.change(total_reactivations_bf_this_week, total_reactivations)
				}
				h[:subscriptions_by_region_data] = subscriptions_by_region_data
				h[:subscriptions_by_agent_data] = subscriptions_by_agent_data
			end
		end
		render json: data
	end

	def user_dashboard_stats
		data = {}
		@user = User.friendly.find(params[:id])
		total_subscribers = @user.farmers.count
		total_subscribers_bf_this_week = Farmer.with_user(@user.id).before_this_week.count

		total_activations = Farmer.with_user(@user.id).with_active_subscription(Date.today.beginning_of_day).count
		total_activations_bf_this_week = Farmer.with_user(@user.id).with_active_subscription_bf_this_week.count

		total_expired_subscribers = Farmer.with_user(@user.id).with_expired_subscription(Date.today.beginning_of_day).count
		total_expired_subscribers_bf_this_week = Farmer.with_user(@user.id).with_expired_subscription_bf_this_week.count

		total_collections = (Commission.with_user(@user.id).sum(:amount) * 10).round(2)
		total_collections_bf_this_week = (Commission.with_user(@user.id).before_this_week.sum(:amount) * 10).round(2)

		total_reactivations = Subscription.with_user(@user.id).with_type(1).count
		total_reactivations_bf_this_week = Subscription.with_user(@user.id).before_this_week.with_type(1).count

		data.tap do |h|
			h[:total_subscribers] = {
				total: total_subscribers,
				percent_change: Percentage.change(total_subscribers_bf_this_week, total_subscribers)
			}
			h[:total_activations] = {
				total: total_activations,
				percent_change: Percentage.change(total_activations_bf_this_week, total_activations)
			}
			h[:total_expired_subscribers] = {
				total: total_expired_subscribers,
				percent_change: Percentage.change(total_expired_subscribers_bf_this_week, total_expired_subscribers)
			}
			h[:total_collections] = {
				total: total_collections,
				percent_change: Percentage.change(total_collections_bf_this_week, total_collections)
			}
			h[:total_reactivations] = {
				total: total_reactivations,
				percent_change: Percentage.change(total_reactivations_bf_this_week, total_reactivations)
			}
		end
		render json: data
	end
	
	def provider_dashboard_stats
		data = {}
		@user = User.friendly.find(params[:id])
		total_revenue = Payment.with_user(@user.id).sum(:payment_fee)
		total_revenue_bf_this_week = Payment.with_user(@user.id).before_this_week.sum(:payment_fee)

		total_schedules = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).count
		total_schedules_bf_this_week = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).before_this_week.count
	
		total_completed_schedules = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.count
		total_completed_schedules_bf_this_week = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.before_this_week.count
	
		total_pending_schedules = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.count
		total_pending_schedules_bf_this_week = VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.before_this_week.count
	
		schedules_data = [
			{ 
				name: "#{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}",
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.this_month.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.this_month.count
			},
			{ 
				name: "#{Date::MONTHNAMES[Date.today.last_month.month]} #{Date.today.last_month.year}",
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.last_month.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.last_month.count
			},
			{ 
				name: "#{Date::MONTHNAMES[Date.today.months_ago(2).month]} #{Date.today.months_ago(2).year}",
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.last_2_months.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.last_2_months.count
			},
			{ 
				name: "#{Date::MONTHNAMES[Date.today.months_ago(3).month]} #{Date.today.months_ago(3).year}",
				cases: Case.with_user(@user.id).last_3_months.count,
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.last_3_months.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.last_3_months.count
			},
			{ 
				name: "#{Date::MONTHNAMES[Date.today.months_ago(4).month]} #{Date.today.months_ago(4).year}",
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.last_4_months.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.last_4_months.count
			},
			{ 
				name: "#{Date::MONTHNAMES[Date.today.months_ago(5).month]} #{Date.today.months_ago(5).year}",
				"total schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_pending.last_5_months.count,
				"completed schedules": VaccinationSchedule.with_campaign_id(@user.campaigns.pluck(:id)).with_completed.last_5_months.count
			}
    ]
    
    monthly_rev = [
      { 
        name: "#{Date::MONTHNAMES[Date.today.month]} #{Date.current.year}", 
        value: Payment.with_user(@user.id).this_month.sum(:payment_fee)
      }
    ]

    $i = 1
    $num = 11

    while $i <= $num  do
      monthly_rev.insert($i, {
        name: "#{Date::MONTHNAMES[(Date.today - $i.month).month]} #{(Date.today - $i.month).year}", 
        value: Payment.with_user(@user.id).where(created_at: (Date.today - $i.month).all_month).sum(:payment_fee),
      })
      $i +=1
    end

		data.tap do |h|
			h[:total_revenue] = {
				total: total_revenue,
				percent_change: Percentage.change(total_revenue_bf_this_week, total_revenue)
			}
			h[:total_schedules] = {
				total: total_schedules,
				percent_change: Percentage.change(total_schedules_bf_this_week, total_schedules)
			}
			h[:total_completed_schedules] = {
				total: total_completed_schedules,
				percent_change: Percentage.change(total_completed_schedules_bf_this_week, total_completed_schedules)
			}
			h[:total_pending_schedules] = {
				total: total_pending_schedules,
				percent_change: Percentage.change(total_pending_schedules_bf_this_week, total_pending_schedules)
      }
      h[:monthly_revenues] = monthly_rev
			h[:schedules_data] = schedules_data
		end
		render json: data
  end
  
  def revenue
    data = {}
    if current_user.role == 'admin'
      $currentQuarter = ((Time.now.month - 1) / 3) + 1
      qt_by_qt_rev = [
        { name: "Q#{$currentQuarter} #{Date.current.year}", value: Payment.this_quarter.sum(:payment_fee) }
      ]
      
      if Date.today.prev_quarter.all_quarter.begin.year == Date.current.year
        qt_by_qt_rev << { name: "Q#{$currentQuarter - 1} #{Date.current.year}", value: Payment.last_quarter.sum(:payment_fee) }
      end
      
      if Date.today.prev_quarter.prev_quarter.all_quarter.begin.year == Date.current.year
        qt_by_qt_rev << { name: "Q#{$currentQuarter - 2} #{Date.current.year}", value: Payment.last_2_quarters.sum(:payment_fee) }
      end

      if Date.today.prev_quarter.prev_quarter.prev_quarter.all_quarter.begin.year == Date.current.year
        qt_by_qt_rev << { name: "Q#{$currentQuarter - 3} #{Date.current.year}", value: Payment.last_3_quarters.sum(:payment_fee) }
      end

      vd_rev_this_qt = Payment.with_item('vaccination').this_quarter.sum(:payment_fee)
      vd_rev_last_qt = Payment.with_item('vaccination').last_quarter.sum(:payment_fee)

      cm_vd_rev_this_qt = 0.1 * Payment.with_item('vaccination').this_quarter.sum(:payment_fee)
      cm_vd_rev_last_qt = 0.1 * Payment.with_item('vaccination').last_quarter.sum(:payment_fee)

      ts_rev_this_qt = Payment.with_item('subscription').this_quarter.sum(:payment_fee)
      ts_rev_last_qt = Payment.with_item('subscription').last_quarter.sum(:payment_fee)

      pmt_rev_this_qt = Payment.this_quarter.sum(:payment_fee)
      pmt_rev_last_qt = Payment.this_quarter.sum(:payment_fee)

      data.tap do |h|
				h[:subscriptions_revenue] = {
					total: ts_rev_this_qt,
					percent_change: Percentage.change(ts_rev_last_qt, ts_rev_this_qt)
				}
				h[:vaccine_deliveries_revenue] = {
					total: vd_rev_this_qt,
					percent_change: Percentage.change(vd_rev_last_qt, vd_rev_this_qt)
				}
				h[:commission_on_vaccine_deliveries_revenue] = {
					total: cm_vd_rev_this_qt,
					percent_change: Percentage.change(cm_vd_rev_last_qt, cm_vd_rev_this_qt)
				}
				h[:total_revenue] = {
          total: pmt_rev_this_qt,
          percent_change: Percentage.change(pmt_rev_last_qt, pmt_rev_this_qt)
        }
        h[:quaterly_revenues] = qt_by_qt_rev
        h[:recent_transactions] = Payment.limit(20).order('created_at desc')
			end
    end
    render json: data
  end
  
	def manager_dashboard_stats
		data = {}
		if current_user.role == 'manager'
			organization = current_user.organizations.first
			total_cases = 0
			data[:total_users] = organization.users.count
			organization.users.find_each do |user|
				user.cases.find_each do |caseItem|
					total_cases += 1
				end
			end
			data[:total_cases] = total_cases
		end
		render json: data
  end
  
  private

  def range_params
		params.require(:data).permit(
      :date_from,
      :date_to,
      :slug
		)
	end
end