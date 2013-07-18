class PackagesController < ApplicationController
  include Packages::Params
  before_filter :ensure_add_ons
  
  def index
    @packages = current_hotel.packages.paginate(pagination_params).decorate
    redirect_to [:new, current_hotel, :package], notice: "Make your first package" if @packages.blank?
  end
  
  def show
    @package = current_hotel.packages.find(params[:id]).decorate
  end
  alias_method :edit, :show
  
  def create
    @package = Packages::Create.new(context: context).run
    respond_with current_hotel, @package
  end
  
  def update
    @package = Packages::Update.new(context: context).run
    respond_with current_hotel, @package
  end
  
  def destroy
    @package = current_hotel.packages.find( params[:id]).decorate
    @package.toggle! :active
    render
  end
  
  private
  def ensure_add_ons
    redirect_to [:new, current_hotel, :add_on], notice: "You must have Add ons before you can make packages" if current_hotel.add_ons.blank?
  end
  
  
end
