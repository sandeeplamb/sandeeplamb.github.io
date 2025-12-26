# Patch for Ruby 3.4+ compatibility with Liquid 4.0.3
# Ruby 3.4 removed the tainted? method, which Liquid 4.0.3 still uses
# This patch adds a stub tainted? method that always returns false

# Add tainted? method stub to String class for Ruby 3.4+ compatibility
class String
  def tainted?
    false
  end
end unless String.instance_methods.include?(:tainted?)

# Also add to Object class for other types
class Object
  def tainted?
    false
  end
end unless Object.instance_methods.include?(:tainted?)

