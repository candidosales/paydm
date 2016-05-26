class Order < ActiveRecord::Base
	 include ActionView::Helpers::NumberHelper

	 monetize :price
	 validates :tipo, :operation, :price, :name, :cpf, :cid, presence: true

	 def description
	 	if(self.tipo.eql? "demolay")
	 		"#{self.operation.capitalize}"
	 	else
	 		unit = self.price / self.qtd_membro
	 		"#{self.operation.capitalize}: #{number_to_currency unit} x #{self.qtd_membro} = #{number_to_currency self.price} | Protocolo: #{self.protocolo}"
	 	end
	 end
end