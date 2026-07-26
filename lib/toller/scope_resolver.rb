# frozen_string_literal: true

module Toller
  ##
  # Shared lookup used by the `type: :scope` filter/sort handlers to confirm a resolved
  # `scope_name`/`field` is actually declared on the model (a real `scope`, or a plain
  # `def self.foo`), rather than a method inherited from ActiveRecord itself. Without this,
  # a typo'd `scope_name:` that happens to collide with a built-in ActiveRecord class method
  # (`delete_all`, `where`, `sum`, etc.) would silently `public_send` it with the raw request
  # value instead of being treated as an unresolvable scope.
  module ScopeResolver
    module_function

    ##
    # @param klass [Class] the ActiveRecord model class to check
    # @param name [Symbol,String] the method name to look for
    # @return [Boolean] whether +name+ is defined by +klass+ or one of its own ancestors,
    #                   rather than inherited from ActiveRecord::Base itself
    def own_class_method?(klass, name)
      klass.singleton_class.ancestors
           .take_while { |mod| mod != ActiveRecord::Base.singleton_class }
           .any? { |mod| mod.public_method_defined?(name.to_sym, false) }
    end
  end
end
