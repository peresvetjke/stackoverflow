require_relative "20211208042147_create_authorizations"

class DeleteAuthorizations < ActiveRecord::Migration[6.1]
  def change
    revert CreateAuthorizations
  end
end
