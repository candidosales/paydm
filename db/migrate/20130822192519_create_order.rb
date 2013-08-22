class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :tipo
      t.string :operation
      t.string :name
      t.string :cpf
      t.string :cid
      t.string :address
      t.string :email

      t.date :data_elevacao
      t.date :data_investidura
      t.date :data_nascimento
      t.date :data_regularizacao

      t.string :capitulo
      t.string :convento
      t.string :nome_organizacao
      t.string :tipo_documento

      t.integer :status

      t.timestamps
    end
  end
end
