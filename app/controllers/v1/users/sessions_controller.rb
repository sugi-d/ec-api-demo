module V1
  module Users
    class SessionsController < DeviseTokenAuth::SessionsController
      def render_create_success
        render json: { status: 'success' }
      end

      def render_create_error_bad_credentials
        render json: { status: 'error' }, status: 401
      end
    end
  end
end
