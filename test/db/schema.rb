ActiveRecord::Schema.define do
  create_table "Beans", :force => true do |t|
    t.column "number",  :integer
    t.column "text", :text
    t.column "category", :text
  end
end