module Unparser
  class Emitter
    class Literal

      # Base class for primitive emitters
      class Primitive < self

        children :value

      private

        # Emitter for primitives based on Object#inspect
        class Inspect < self

          handle :float, :sym, :int

        private

          # Dispatch value
          #
          # @return [undefined]
          #
          # @api private
          #
          def dispatch
            buffer.append(value.inspect)
          end

        end # Inspect

        # Literal emitter with macro regeneration base class
        class MacroSafe < self

        private

          # Perform dispatch
          #
          # @return [undefined]
          #
          # @api private
          #
          def dispatch
            if source == macro
              write(macro)
              return
            end
            write(value.inspect)
          end

          # Return source, if present
          #
          # @return [String]
          #   if present
          #
          # @return [nil]
          #   otherwise
          #
          # @api private
          #
          def source
            location = node.location || return
            expression = location.expression || return
            expression.source
          end

          # Return marco
          #
          # @return [String]
          #
          # @api private
          #
          def macro
            self.class::MACRO
          end

          # String macro safe emitter
          class String < self
            MACRO = '__FILE__'.freeze
            handle :str
          end # String

          # Integer macro safe emitter
          class Integer < self
            MACRO = '__LINE__'.freeze
            handle :int
          end # Integer

        end # MacroSave
      end # Primitive
    end # Literal
  end # Emitter
end # Unparser
