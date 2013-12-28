module Unparser
  class Preprocessor
    class Str < self

      handle :str

      # Assigns the node a `single_quoted_string` type
      # if it doesn't need double quotes
      #
      # @return [Parser::AST::Node] node
      #
      # @api private
      #
      def preprocess
        if needs_double_quotes?
          super
        else
          node.updated(:single_quoted_string)
        end
      end

      # Test if the string needs double quotes
      # TODO: check for special characters like [\r\n\t]
      #
      # @return [true]
      #   if string needs double quotes
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def needs_double_quotes?
        false
      end

    end # Str
  end # Preprocessor
end # Unparser
