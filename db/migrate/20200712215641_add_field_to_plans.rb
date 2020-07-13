class AddFieldToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :blocked_on_limit, :boolean, default: false
  end
end
