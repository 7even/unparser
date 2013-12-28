module Unparser
  class Preprocessor
    class Pair < self

      BAREWORD = /\A[A-Za-z_][A-Za-z_0-9]*[?!]?\z/.freeze

      handle :pair

      # Preprocess a hash pair which can be
      # a pair_colon or a pair_rocket
      #
      # @return [Parser::AST::Node] node
      #
      # @api private
      #
      def preprocess
        key, value = *node

        if key.type == :sym && !symbol_needs_quotes?(key.children.first)
          node.updated(:pair_colon, preprocessed_children)
        else
          node.updated(:pair_rocket, preprocessed_children)
        end
      end

    private

      # Test if this symbol is safe to use without quoting
      #
      # @return [true]
      #   if the symbol is safe
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def symbol_needs_quotes?(symbol)
        symbol.to_s =~ BAREWORD
      end

    end # Pair
  end # Preprocessor
end # Unparser
