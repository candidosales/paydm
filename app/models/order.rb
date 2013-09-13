class Order < ActiveRecord::Base
	 include ActionView::Helpers::NumberHelper

	 validates :tipo, :operation, :price, :name, :cpf, :cid, :address, :email, presence: true

	 def description
	 	"#{self.tipo.capitalize}, #{self.operation.capitalize}: #{number_to_currency self.price} | #{self.name}, #{self.cpf}, #{self.cid}"
	 end
end