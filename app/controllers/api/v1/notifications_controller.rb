class Api::V1::NotificationsController < ApplicationController
  before_action :set_notification

  def index
    @notifications = Notification.all
    render json: @notifications, serializer: Api::V1::NotificationSerializer, adapter: :attributes
  end

  def show
    @notification = Notification.find(params[:id])
    render json: @notification, serializer: Api::V1::NotificationSerializer, adapter: :attributes
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      render json: @notification, serializer: Api::V1::NotificationSerializer, adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @card.errors, status: 422)
    end
  end

  def update
    if @notification.update(notification_params)
      render json: @notification, serializer: Api::V1::NotificationSerializer, adapter: :attributes
    else
      api_error(status: 422, data: params.fetch(:notification), errors: notification.errors)
    end
  end

  def destroy
    if @notification.destroy
      render :nothing, status: :no_content
    else
      head 422
    end
  end

  private

  def notification_params
      params.permit([:message_id, :scheduled, :send_at, :sent]);
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
