class NumericWrapper

  include Comparable

  def self.init_wrapper( value_class, fixers, default_fix_return )
    wrap_methods = value_class.instance_methods
    wrap_methods -= Object.instance_methods()
    wrap_methods -= Comparable.instance_methods()

    wrap_methods.each do |meth|
      fix_return = default_fix_return
      fixers.each do |fix_def|
        if fix_def["methods"].include?( meth )
          fix_return = fix_def["fix"]
          break
        end
      end
      inst_meth = value_class.instance_method(meth)
      if inst_meth.arity == 0
        define_method(meth) { 
          ret = @value.send(meth)
          if ret.is_a?(@value.class)
            return fix_return.bind(self).call(ret)
          else
            return ret
          end
        }
      elsif inst_meth.arity == 1
        define_method(meth) { |other|
          if other.is_a?(self.class)
            ret = @value.send(meth, other.wrapped_value)
          else
             ret = @value.send(meth, self.to_vclass(other))
          end
          if ret.is_a?(@value.class)
            return fix_return.bind(self).call(ret)
          else
            return ret
          end
        }
      end
    end
  end

  def initialize( *args, &block )
    @value = self.to_vclass(*args, &block)
  end

  def is_a?( cls )
    if cls == Numeric or cls == @value.class
      return true
    end
    super
  end

  def wrapped_value
    @value
  end
  
end
