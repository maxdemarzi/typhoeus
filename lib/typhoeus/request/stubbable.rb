module Typhoeus
  class Request

    # This module handles stubbing on the request side.
    # It plays well with the block_connection configuration,
    # which raises when you make a request which is not stubbed.
    module Stubbable

      # Override run in order to check for matching expecations.
      # When an expecation is found, super is not called. Instead a
      # canned response is assigned to the request.
      #
      # @example Run the request.
      #   request.run
      #
      # @return [ Response ] The response.
      def run
        if expectation = Expectation.find_by(self)
          @response = expectation.response
          @response.request = self
          execute_callbacks
          @response
        else
          super
        end
      end
    end
  end
end
