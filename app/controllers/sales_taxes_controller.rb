class SalesTaxesController < ApplicationController
  
  def index
    @sales_taxes = current_hotel.sales_taxes.paginate(pagination_params).decorate
    redirect_to action: :new and return if @sales_taxes.blank?
    render
  end
  
  def show
    @sales_tax = current_hotel.sales_taxes.find( params[:id]).decorate
    render
  end
  alias_method :edit, :show

  def create
    @sales_tax = current_hotel.sales_taxes.create sales_tax_params
    respond_with current_hotel, @sales_tax
  end
  
  def update
    @sales_tax = current_hotel.sales_taxes.find params[:id]
    @sales_tax.update_attributes sales_tax_params
    respond_with current_hotel, @sales_tax
  end
  
  # def destroy
  #   @sales_tax = current_hotel.sales_taxes.find( params[:id]).decorate
  #   @sales_tax.toggle! :active
  #   render
  # end
  
  
  private
  def sales_tax_params
    params[:sales_tax].permit :name, :amount, :calculated_by, :calculated_how
  end

end
