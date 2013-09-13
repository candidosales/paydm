class HomeController < ApplicationController
  def index
  	@order = Order.new
  	@title = "Sistema de Pagamentos DeMolay"
  end

  def thank_you
  end
end