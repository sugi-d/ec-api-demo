module V1
  class ItemsController < ApplicationController
    before_action :authenticate_v1_user!, only: %i[create update destroy]
    before_action :set_item, only: %i[show]

    # GET /items
    def index
      @items = Item.all

      render json: @items
    end

    # GET /items/1
    def show
      render json: render_item(@item)
    end

    # POST /items
    def create
      @item = current_v1_user.items.build(item_params)

      if @item.save
        render json: render_item(@item), status: :created, location: v1_item_url(@item)
      else
        render json: { errors: @item.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /items/1
    def update
      Item.transaction do
        set_item
        if @item.user == current_v1_user
          if @item.order.blank? && @item.update(item_params)
            render json: render_item(@item)
          else
            render json: { errors: @item.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: ['unauthorized'] }, status: :unauthorized
        end
      end
    end

    # DELETE /items/1
    def destroy
      Item.transaction do
        set_item
        if @item.user == current_v1_user
          if @item.order.blank?
            @item.destroy
          else
            render json: { errors: { item: 'already sold out' } }, status: :unprocessable_entity
          end
        else
          render json: { errors: ['unauthorized'] }, status: :unauthorized
        end
      end
    end

    private

    def render_item(item)
      item.
        attributes.
        select { |k, _| [:id, :name, :description, :price].include?(k.to_sym) }.
        tap { |r| r['user'] = item.user.attributes.select { |k, _| [:id, :email].include?(k.to_sym) } }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.includes(:user, :order).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :price)
    end
  end
end
