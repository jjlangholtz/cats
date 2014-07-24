class CatsController < ApplicationController
  respond_to :json
  before_action :find_cat, only: [:show, :update, :destroy]

  def show
    respond_with @cat
  end

  def index
    if params[:cat_ids]
      @cats = Cat.find(params[:cat_ids])
    elsif params[:since_id]
      @cats = Cat.where(id: (params[:since_id] + 1)..(Cat.last.id))
    else
      @cats = Cat.all
    end
    respond_with @cats
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.save
    respond_with @cat
  end

  def update
    @cat.update(cat_params)
    respond_with @cat
  end

  def destroy
    @cat.destroy
    respond_with @cat
  end

  private
  def find_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit!
  end
end
