class HealthController < ApplicationController
  def index
    render plain: ActiveRecord::Base.connection.select_all('SELECT now()').rows.first.first.to_s
  end
end
