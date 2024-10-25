ActiveRecord::Schema.define do
  create_table :businesses do |t|
    t.string :name
  end

  create_table :users do |t|
    t.string :name
    t.integer :team_name
    t.references :business
  end

  create_table :posts do |t|
    t.string :title
    t.string :description
    t.references :user
  end
end
