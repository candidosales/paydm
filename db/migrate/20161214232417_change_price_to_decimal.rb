class ChangePriceToDecimal < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.change :price, :decimal, :precision => 8, :scale => 2
    end
  end
 
  def down
    change_table :orders do |t|
      t.change :price, :decimal
    end
  end
end
