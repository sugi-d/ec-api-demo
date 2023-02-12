module V1
  class OrdersController < ApplicationController
    before_action :authenticate_v1_user!, only: %i[create show]
    before_action :set_order, only: %i[show]

    # GET /orders/1
    def show
      if @order.user == current_v1_user
        render json: render_order(@order)
      else
        render json: { errors: ['unauthorized'] }, status: :unauthorized
      end
    end

    # POST /orders
    def create
      Order.transaction do
        item = Item.find(params[:item_id])

        if item.purchase(current_v1_user)
          render json: render_order(item.order), status: :created, location: v1_order_url(item.order)
        else
          render json: { status: 'error' }, status: :unprocessable_entity
        end
      end
    end

    private

    def render_order(order)
      buyer = { id: order.user.id, email: order.user.email }
      item = order.item.attributes.select { |k, _| %i[id name description price].include?(k.to_sym) }
      item['user'] = { id: order.item.user.id, email: order.item.user.email }

      { id: order.id, buyer:, item: }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:item_id)
    end
  end
end
