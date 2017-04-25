require "mymoney/arithmetics"
require "mymoney/exceptions"
require "mymoney/version"
require "mymoney/money"
require 'bigdecimal'

module Mymoney
  EXCHANGE_TABLE = {}

  def self.exchange_rates(currency, rates)
    if EXCHANGE_TABLE[currency].nil?
      EXCHANGE_TABLE[currency] = rates
    else
      EXCHANGE_TABLE[currency].merge!(rates)
    end
  end
end
