module Typhoeus
  class Request

    # This module contains the logic for the response callbacks.
    # The on_complete callback is the only one at the moment.
    #
    # You can set multiple callbacks, which are then executed
    # in the same order.
    #
    #   request.on_complete { p 1 }
    #   request.on_complete { p 2 }
    #   request.execute_callbacks
    #   #=> 1
    #   #=> 2
    #
    # You can clear the callbacks:
    #
    #   request.on_complete { p 1 }
    #   request.on_complete { p 2 }
    #   request.on_complete.clear
    #   request.execute_callbacks
    #   #=> []
    module Callbacks

      module Types
        # Set on_complete callback.
        #
        # @example Set on_complete.
        #   request.on_complete { p "yay" }
        #
        # @param [ Block ] block The block to execute.
        def on_complete(&block)
          @on_complete ||= []
          @on_complete << block if block_given?
          @on_complete
        end

        # Set on_success callback.
        #
        # @example Set on_success.
        #   request.on_success { p "yay" }
        #
        # @param [ Block ] block The block to execute.
        def on_success(&block)
          @on_success ||= []
          @on_success << block if block_given?
          @on_success
        end

        # Set on_failure callback.
        #
        # @example Set on_failure.
        #   request.on_failure { p "yay" }
        #
        # @param [ Block ] block The block to execute.
        def on_failure(&block)
          @on_failure ||= []
          @on_failure << block if block_given?
          @on_failure
        end
      end

      # Execute nessecary callback and yields response. This
      # include in every case on_complete, on_success if
      # successful and on_failure if not.
      #
      # @example Execute callbacks.
      #   request.execute_callbacks
      def execute_callbacks
        callbacks = Typhoeus.on_complete + on_complete

        if response && response.success?
          callbacks += Typhoeus.on_success + on_success
        elsif response
          callbacks += Typhoeus.on_failure + on_failure
        end

        callbacks.map{ |callback| callback.call(self.response) }
      end
    end
  end
end
