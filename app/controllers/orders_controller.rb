class OrdersController < ApplicationController
  def create
  	@order = Order.new(order_params)
    @order.save
  	puts @order.description
  	#redirect_to root_path, notice: "Enviamos um e-mail para #{@order.email} confirmando seu pedido."

    payment = PagSeguro::PaymentRequest.new
    payment.reference = @order.id
    payment.notification_url = notifications_url
    payment.redirect_url = thanks_url

  
    payment.items << {
      id: @order.id,
      description: @order.description,
      amount: @order.price,
      weight: 1
    }

    payment.sender = {
      name: validate_sender_name(name: @order.name, tipo: @order.tipo),
      email: @order.email,
      cpf: @order.cpf.gsub(/[.-]/,'')
    }
    
    payment.extra_params << { tipo: @order.tipo }
    payment.extra_params << { operacao: @order.operation }
    
    puts payment.inspect
    
    response = payment.register
    
    # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # exception_notification poderá notificar sobre o ocorrido.
    #
    # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    if response.errors.any?
      response = Array(response.errors)
      redirect_to root_path, alert: "#{response.join(' </br> ')}"
      # raise response.errors.join("\n")
    else
      redirect_to response.url
    end

  end

  def validate_sender_name(options={})
    @name = options[:name]
    @tipo = options[:tipo]
    # Localizar todos números do texto usando \d e remove-los.
    # Usaremos o o \n para localizar a quebra de linha, \t para encontrar as tabulações e
    # \r para os retornos de carro, logo em seguida alteraremos por espaço
    # Se no nome do usuário tiver algum espaço duplicado, o PagSeguro irá retornar erro,
    # então vamos procurar por espaços e remove-los, especificamente nesse caso usaremos \s
    # para achar o espaço depois ?= para procurar um conteúdo após esse espaço, o que em nosso
    # caso será outro espaço \s.
    @name = @name.gsub('/\d/', '').gsub('/[\n\t\r]/', ' ').gsub('/\s(?=\s)/', '').split(' ')

    @name << @tipo if @name.count == 1
    @name.join(' ')
  end

  private
    def order_params
      params.require(:order).permit!
    end
end
