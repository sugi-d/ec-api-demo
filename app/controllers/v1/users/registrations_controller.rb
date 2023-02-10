module V1
  module Users
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      def render_create_success
        render json: { status: 'success' }
      end

      def render_create_error
        render json: { status: 'error' }, status: 422
      end
    end
  end
end
