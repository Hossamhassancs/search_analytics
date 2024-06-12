class AddIndexToSearch < ActiveRecord::Migration[7.1]
  def change
    add_index :searches, [:query, :ip_address]
  end
end
