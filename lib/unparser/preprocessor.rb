module Unparser

  module Preprocessor
    include Constants

    def self.call(node)
      method_name = "on_#{node.type}"

      if respond_to?(method_name)
        public_send(method_name, node)
      else
        mapped_children = node.children.map do |child|
          if child.kind_of?(Parser::AST::Node)
            call(child)
          else
            child
          end
        end
        node.updated(nil, mapped_children)
      end
    end

    def self.s(type, children = [])
      Parser::AST::Node.new(type, children)
    end

    # s(:pair, s(:sym, :foo), s(:str, "bar"))
    #
    #   => s(:pair_colon, s(:sym, :foo), s(:str, "bar"))
    #
    # s(:pair, s(:sym, "foo"), s(:str, "bar"))
    #
    #   => s(:pair_rocked, s(:sym, "foo"), s(:str, "bar"))
    #
    def self.on_pair(node)
      key, value = *node

      if key.type == :sym && !symbol_needs_quotes?(key.children.first)
        node.updated(:pair_colon)
      else
        node.updated(:pair_rocket)
      end
    end

    def self.symbol_needs_quotes?(symbol)
      symbol.inspect[1] == DBL_QUOTE
    end

    def self.on_begin(node)
      children = node.children

      mapped_children = children.each_slice(2).each_with_object([]) do |pair, new_children|
        left, right = pair
        if left.kind_of?(Parser::AST::Node) && right.kind_of?(Parser::AST::Node) && left.type == :def && right.type == :def
          new_children << left << s(:indent_spaces) << right
        else
          new_children.concat(pair)
        end
      end

      node.updated(nil, mapped_children)
    end

  end
end # Unparser
