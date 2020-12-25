class CreateTableResult < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.integer :student_id
      t.integer :subject_id
      t.decimal :mark,precision: 5, scale: 2
    end
  end
end
