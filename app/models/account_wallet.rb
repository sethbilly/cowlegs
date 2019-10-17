class AccountWallet < ActiveRecord::Base
  self.table_name = 'account_wallet'

  # The account_wallet relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the databasße connection.
  def readyonly?
    true
  end
end