class CreateStudies < ActiveRecord::Migration[5.1]
  def change
   create_table :studies do |t|
     t.datetime :started_at
     t.datetime :ended_at
     t.string :subject
     t.text :content

     t.timestamps
   end
 end
end
