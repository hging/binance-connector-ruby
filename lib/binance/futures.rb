# frozen_string_literal: true

require 'binance/session'
require 'binance/authentication'
require 'binance/utils/validation'
require 'binance/utils/url'
require 'binance/error'
require 'binance/futures/market'
require 'binance/futures/websocket'

module Binance
  # Spot class includes the following modules:
  # - Blvt
  # - C2C
  # - Convert
  # - Fiat
  # - Futures
  # - Loan
  # - Margin
  # - Market
  # - Mining
  # - SimpleEarn
  # - Stream
  # - Subaccount
  # - Trade
  # - Wallet
  # @see https://developers.binance.com/en
  class Futures
    include Binance::Futures::Market

    def initialize(key: '', secret: '', **kwargs)
      @session = Session.new kwargs.merge(key: key, secret: secret)
    end
  end
end
