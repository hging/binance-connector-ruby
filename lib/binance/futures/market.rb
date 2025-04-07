# frozen_string_literal: true

module Binance
    class Futures
      # This module includes all spot public endpoints, including:
      # - server time
      # - kline
      # - ticker
      # - trades
      # - orderbook
      # - etc
      # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/public-api-endpoints#market-data-endpoints
      module Market
        # Test Connectivity
        #
        # GET /fapi/v1/ping
        #
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/general-endpoints#test-connectivity
        def ping
          @session.public_request(path: '/fapi/v1/ping')
        end
  
        # Check Server Time
        #
        # GET /fapi/v1/time
        #
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/general-endpoints#check-server-time
        def time
          @session.public_request(path: '/fapi/v1/time')
        end
  
        # Exchange Information
        #
        # GET /fapi/v1/exchangeInfo
        #
        # @option kwargs [string] :symbol
        # @option kwargs [string] :symbols
        # @option kwargs [string] :permissions
        # @option kwargs [Boolean] :feature Controls whether the content of the permissionSets field is populated or not. Defaults to true
        # @option kwargs [string] :symbolStatus Filters symbols that have this tradingStatus. Valid values: TRADING, HALT, BREAK. Cannot be used in combination with symbols or symbol.
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/general-endpoints#exchange-information
        def exchange_info(symbol: nil, symbols: nil, permissions: nil)
          if symbols.is_a?(Array)
            symbols = symbols.map { |v| "%22#{v}%22" }.join(',')
            symbols = "%5B#{symbols}%5D"
          end
          if permissions.is_a?(Array)
            permissions = permissions.map { |v| "%22#{v}%22" }.join(',')
            permissions = "%5B#{permissions}%5D"
          end
          @session.public_request(
            path: '/fapi/v1/exchangeInfo',
            params: { symbol: symbol, symbols: symbols, permissions: permissions }
          )
        end
  
        # Order Book
        #
        # GET /fapi/v1/depth
        #
        # @param symbol [String] the symbol
        # @param kwargs [Hash]
        # @option kwargs [Integer] :limit Default 100; max 1000. Valid limits:[5, 10, 20, 50, 100, 500, 1000, 5000]
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#order-book
        def depth(symbol:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
  
          @session.public_request(
            path: '/fapi/v1/depth',
            params: kwargs.merge(symbol: symbol)
          )
        end
  
        # Recent Trades List
        #
        # GET /fapi/v1/trades
        #
        # @param symbol [String] the symbol
        # @param kwargs [Hash]
        # @option kwargs [Integer] :limit  Default 500; max 1000.
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#recent-trades-list
        def trades(symbol:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
  
          @session.public_request(
            path: '/fapi/v1/trades',
            params: kwargs.merge(symbol: symbol)
          )
        end
  
        # Old Trade Lookup
        #
        # X-MBX-APIKEY required
        #
        # GET /fapi/v1/historicalTrades
        #
        # @param symbol [String] the symbol
        # @param kwargs [Hash]
        # @option kwargs [Integer] :limit Default 500; max 1000.
        # @option kwargs [Integer] :fromId Trade id to fetch from. Default gets most recent trades.
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#old-trade-lookup
        def historical_trades(symbol:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
  
          @session.public_request(
            path: '/fapi/v1/historicalTrades',
            params: kwargs.merge(symbol: symbol)
          )
        end
  
        # Compressed/Aggregate Trades List
        #
        # Get compressed, aggregate trades. Trades that fill at the time, from the same order, with the same price will have the quantity aggregated.
        #
        # GET /fapi/v1/aggTrades
        #
        # @param symbol [String] the symbol
        # @param kwargs [Hash]
        # @option kwargs [Integer] :startTime Timestamp in ms to get aggregate trades from INCLUSIVE.
        # @option kwargs [Integer] :endTime Timestamp in ms to get aggregate trades until INCLUSIVE.
        # @option kwargs [Integer] :fromId Trade id to fetch from. Default gets most recent trades.
        # @option kwargs [Integer] :limit Default 500; max 1000.
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#compressedaggregate-trades-list
        def agg_trades(symbol:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
  
          @session.public_request(
            path: '/fapi/v1/aggTrades',
            params: kwargs.merge(symbol: symbol)
          )
        end
  
        # Kline/Candlestick Data
        #
        # Kline/candlestick bars for a symbol.
        # Klines are uniquely identified by their open time.
        #
        # GET /fapi/v1/klines
        #
        # @param symbol [String] the symbol
        # @param interval [String] interval
        # @param kwargs [Hash]
        # @option kwargs [Integer] :startTime Timestamp in ms to get aggregate trades from INCLUSIVE.
        # @option kwargs [Integer] :endTime Timestamp in ms to get aggregate trades until INCLUSIVE.
        # @option kwargs [String] :timeZone Default: 0 (UTC)
        # @option kwargs [Integer] :limit Default 500; max 1000.
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#klinecandlestick-data
        def klines(symbol:, interval:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
          Binance::Utils::Validation.require_param('interval', interval)
  
          @session.public_request(
            path: '/fapi/v1/klines',
            params: kwargs.merge(
              symbol: symbol,
              interval: interval
            )
          )
        end
  
        def continuous_klines(symbol:, interval:, contract_type:, **kwargs)
          Binance::Utils::Validation.require_param('symbol', symbol)
          Binance::Utils::Validation.require_param('interval', interval)
          Binance::Utils::Validation.require_param('contract_type', contract_type)
          @session.public_request(
            path: '/fapi/v1/continuousKlines',
            params: kwargs.merge(
                pair: symbol,
                interval: interval,
                contractType: contract_type
            )
          )

        end
  
        # Current Average Price
        #
        # Current average price for a symbol.
        #
        # GET /fapi/v1/avgPrice
        #
        # @param symbol [String] the symbol
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#current-average-price
        def avg_price(symbol:)
          Binance::Utils::Validation.require_param('symbol', symbol)
  
          @session.public_request(
            path: '/fapi/v1/avgPrice',
            params: { symbol: symbol }
          )
        end
  
        # 24hr Ticker Price Change Statistics
        #
        # 24 hour rolling window price change statistics. Careful when accessing this with no symbol.
        #
        # GET /fapi/v1/ticker/24hr
        #
        # @param symbol [String] the symbol
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#24hr-ticker-price-change-statistics
        def ticker_24hr(symbol: nil)
          @session.public_request(
            path: '/fapi/v1/ticker/24hr',
            params: { symbol: symbol }
          )
        end
  
        # Trading Day Ticker
        #
        # Price change statistics for a trading day.
        #
        # GET /fapi/v1/ticker/tradingDay
        #
        # @param kwargs [Hash]
        # @option kwargs [string] :symbol Either symbol or symbols must be provided
        # @option kwargs [string] :symbols
        # @option kwargs [String] :timeZone Default: 0 (UTC)
        # @option kwargs [String] :type Supported values: FULL or MINI. Default: FULL
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#trading-day-ticker
        def ticker_trading_day(symbol: nil, symbols: nil, **kwargs)
          raise Binance::DuplicatedParametersError.new('symbol', 'symbols') unless symbols.nil? || symbol.nil?
  
          if symbols
            symbols = symbols.map { |s| "\"#{s}\"" }.join(',')
            symbols = { symbols: "\[#{symbols}\]".upcase }
          end
  
          @session.public_request(
            path: '/fapi/v1/ticker/tradingDay',
            params: kwargs.merge(
              symbol: symbol,
              symbols: symbols
            )
          )
        end
  
        # Symbol Price Ticker
        #
        # Latest price for a symbol or symbols.
        #
        # GET /fapi/v1/ticker/price
        #
        # @param symbol [String] the symbol
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#symbol-price-ticker
        def ticker_price(symbol: nil)
          @session.public_request(
            path: '/fapi/v1/ticker/price',
            params: { symbol: symbol }
          )
        end
  
        # Symbol Order Book Ticker
        #
        # Best price/qty on the order book for a symbol or symbols.
        #
        # GET /fapi/v1/ticker/bookTicker
        #
        # @param symbol [String] the symbol
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#symbol-order-book-ticker
        def book_ticker(symbol: nil)
          @session.public_request(
            path: '/fapi/v1/ticker/bookTicker',
            params: { symbol: symbol }
          )
        end
  
        # Symbol Order Book Ticker
        #
        # Best price/qty on the order book for a symbol or symbols.
        #
        # GET /fapi/v1/ticker
        #
        # @param symbol [String] the symbol
        # @see https://developers.binance.com/docs/binance-spot-api-docs/rest-api/market-data-endpoints#rolling-window-price-change-statistics
        def ticker(symbol: nil, symbols: nil, windowSize: '1d')
          raise Binance::DuplicatedParametersError.new('symbol', 'symbols') unless symbols.nil? || symbol.nil?
  
          params = { symbol: symbol.upcase } if symbol
  
          if symbols
            symbols = symbols.map { |s| "\"#{s}\"" }.join(',')
            params = { symbols: "\[#{symbols}\]".upcase }
          end
  
          params[:windowSize] = windowSize
  
          @session.public_request(
            path: '/fapi/v1/ticker',
            params: params
          )
        end
      end
    end
  end
  