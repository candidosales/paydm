class AddGrauCavaleiroToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :grau_cavaleiro, :string
  end
end
