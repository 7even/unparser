module Unparser
  module Preprocessor

    include Constants

    def self.call(node)
      method_name = "on_#{node.type}"

      if respond_to?(method_name)
        public_send(method_name, node)
      else
        mapped_children = node.children.map do |child|
          if node?(child)
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

      mapped_children = children.each_with_object([]) do |child, new_children|
        if !new_children.empty? && def_nodes?(new_children.last, child)
          new_children << s(:indent_spaces) << child
        else
          new_children << child
        end
      end

      node.updated(nil, mapped_children)
    end

  private

    def self.node?(something)
      something.kind_of?(Parser::AST::Node)
    end

    def self.def_nodes?(*children)
      children.all? { |child| node?(child) && child.type == :def }
    end

  end # Preprocessor
end # Unparser
