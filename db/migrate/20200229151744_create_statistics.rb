class CreateStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :statistics do |t|
      t.jsonb    :statistic_data
      t.timestamps
    end
  end
end
