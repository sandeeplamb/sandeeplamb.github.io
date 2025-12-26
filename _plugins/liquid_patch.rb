# Patch for Liquid 4.0.3 compatibility with Ruby 3.4+
# Ruby 3.4 removed the tainted? method, which Liquid 4.0.3 still uses
# This patch adds a stub tainted? method to String and other objects

# Add tainted? method stub to String class for Ruby 3.4+ compatibility
class String
  def tainted?
    false
  end
end unless String.instance_methods.include?(:tainted?)

# Also add to other common classes that might be used
class Object
  def tainted?
    false
  end
end unless Object.instance_methods.include?(:tainted?)

