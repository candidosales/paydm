class OrdersController < ApplicationController
  def create
  	@order = Order.new(order_params)
    @order.save
  	p @order.id

  	redirect_to root_path, notice: "Enviamos um e-mail para #{@order.email} confirmando seu pedido." 

    # payment = PagSeguro::PaymentRequest.new
    # payment.reference = order.id
    # payment.notification_url = notifications_url
    # payment.redirect_url = processing_url

    # order.products.each do |product|
    #   payment.items << {
    #     id: product.id,
    #     description: product.title,
    #     amount: product.price,
    #     weight: product.weight
    #   }
    # end

    # response = payment.register

    # # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # # exception_notification poderá notificar sobre o ocorrido.
    # #
    # # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    # if response.errors.any?
    #   raise response.errors.join("\n")
    # else
    #   redirect_to response.url
    # end

  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit!
    end
end