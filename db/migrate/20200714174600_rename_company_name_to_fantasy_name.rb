class RenameCompanyNameToFantasyName < ActiveRecord::Migration[6.0]
  def change
    rename_column :companies, :name, :fantasy_name
  end
end
