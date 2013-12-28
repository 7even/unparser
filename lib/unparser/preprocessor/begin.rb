module Unparser
  class Preprocessor
    class Begin < self

      handle :begin

      # Preprocess the node inserting empty lines
      # between adjacent :def nodes
      #
      # @return [Parser::AST::Node] node
      #
      # @api private
      #
      def preprocess
        mapped_children = node.children.each_with_object([]) do |child, new_children|
          if !new_children.empty? && def_nodes?(new_children.last, child)
            new_children << s(:indent_spaces) << preprocess_node(child)
          else
            new_children << preprocess_node(child)
          end
        end

        node.updated(nil, mapped_children)
      end

    private

      # Test if all passed objects are :def nodes
      #
      # @return [true]
      #   if every object is a :def node
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def def_nodes?(*children)
        children.all? { |child| node?(child) && child.type == :def }
      end

    end # Begin
  end # Preprocessor
end # Unparser
