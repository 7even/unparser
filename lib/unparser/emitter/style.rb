module Unparser
  class Emitter

    class IndentSpaces < self

      handle :indent_spaces

      def dispatch
        buffer.prefix
      end

    end

  end
end
