class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound do
    render json: { status: 'not found' }, status: 404
  end

  # workaround for devise & rails 7
  # cf. https://github.com/heartcombo/devise/issues/5443
  class FakeSession < Hash
    def enabled?
      false
    end

    def destroy
    end
  end

  before_action do
    request.env['rack.session'] ||= FakeSession.new
  end
end
