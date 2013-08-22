class Order < ActiveRecord::Base
	 validates :tipo, :operation, :name, :cpf, :cid, :address, :email, presence: true
end