class Order < ActiveRecord::Base
	 include ActionView::Helpers::NumberHelper

	 monetize :price
	 validates :tipo, :operation, :price, :name, :cpf, :cid, presence: true

	 def description
	 	if(self.tipo=="demolay")
	 		"#{self.tipo.capitalize}, #{self.operation.capitalize}: #{number_to_currency self.price} | Devedor: #{self.name}, CPF: #{self.cpf}, CID: #{self.cid}"
	 	else
	 		result = self.qtd_membro*self.price
	 		"#{self.tipo.capitalize}, #{self.operation.capitalize}: #{number_to_currency self.price} x #{self.qtd_membro} = #{number_to_currency result} | Protocolo: #{self.protocolo}"
	 	end
	 end
end