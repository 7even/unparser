module Unparser
  class Preprocessor

    include Constants
    include Concord.new(:node)

    # Registry for node preprocessors
    REGISTRY = {}

    # Preprocess a given AST
    #
    # @param [Parser::AST::Node] ast
    #
    # @return [Parser::AST::Node] processed AST
    #
    # @api private
    #
    def self.preprocess(ast)
      new(ast).preprocess
    end

    # A default implementation of preprocessing:
    # just replace children with their preprocessed versions
    #
    # @return [Parser::AST::Node] node
    #
    # @api private
    def preprocess
      node.updated(nil, preprocessed_children)
    end

  private

    # Return preprocessed children
    #
    # @return [Enumerable<Parser::AST::Node>] children
    #
    # @api private
    #
    def preprocessed_children
      node.children.map do |child|
        if node?(child)
          preprocess_child(child)
        else
          child
        end
      end
    end

    # Preprocess a single child
    #
    # @param [Parser::AST::Node] child_node
    #
    # @return [Parser::AST::Node] node
    #
    # @api private
    #
    def preprocess_child(child_node)
      REGISTRY.fetch(child_node.type, Preprocessor).new(child_node).preprocess
    end

    # Register preprocessor for type
    #
    # @param [Symbol] type
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.handle(*types)
      types.each do |type|
        REGISTRY[type] = self
      end
    end

    # Test if *something* is a Parser::AST::Node
    #
    # @return [true]
    #   if *something* is a node
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def node?(something)
      something.kind_of?(Parser::AST::Node)
    end

    # Helper for building nodes
    # TODO: extract this method into a mixin
    #
    # @param [Symbol]
    #
    # @return [Parser::AST::Node]
    #
    # @api private
    #
    def s(type, children = [])
      Parser::AST::Node.new(type, children)
    end

  end # Preprocessor
end # Unparser
