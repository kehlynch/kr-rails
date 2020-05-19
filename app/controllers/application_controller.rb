class ApplicationController < ActionController::Base
  around_action :collect_metrics

  def collect_metrics
    # ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
    #   event = ActiveSupport::Notifications::Event.new(*args)
    #   Rails.logger.info "Event received: #{event}"
    # end
    start = Time.now
    yield
    duration = Time.now - start
    Rails.logger.info "#{controller_name}##{action_name}: #{duration}s"
  end
end
