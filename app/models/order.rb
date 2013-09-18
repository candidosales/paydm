class Order < ActiveRecord::Base
	 include ActionView::Helpers::NumberHelper

	 validates :tipo, :operation, :price, :name, :cpf, :cid, :address, :email, presence: true

	 def description
	 	"#{self.tipo.capitalize}, #{self.operation.capitalize}: #{number_to_currency self.price} | #{self.name}, CPF: #{self.cpf}, CID: #{self.cid}"
	 end
end