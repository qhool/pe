require 'rational'
require 'numericwrap'

class BigFloat < NumericWrapper
  @@precision = 100
  @@max_denominator = 10**@@precision

  def self.set_precision( prec )
    @@precision = prec
    @@max_denominator = 10**@@precision
  end
  
  def self.get_precision; @@precision; end

  def fix_ret( val )
    if val.denominator > @@max_denominator
      val = Rational((val.numerator * @@max_denominator).div(val.denominator),
                     @@max_denominator)
    end
    return self.class.new( val )
  end
  
  def to_vclass(val,denom=nil)
    if denom == nil 
      if val.is_a?(Float)
        v = Rational((val * @@max_denominator).to_i,@@max_denominator)
      elsif val.is_a?(Rational)
        v = val
      else
        v = Rational(val)
      end
    else
      v = Rational(val,denom)
    end
    return v
  end

  def initialize( value, denom = nil )
    @@max_denominator = 10 ** @@precision
    super(value,denom)
  end

  def to_s
    return "0" if @value.numerator == 0
    pwr = @@precision
    digits = (@value.numerator * @@max_denominator).div(@value.denominator).to_s
    if digits.size < @@precision + 1
      digits = ("0"*(@@precision-digits.size+1)) + digits
    end

    digits = digits[0..-(@@precision+1)] + '.' + digits[-@@precision..-1]
    return digits.sub( /\.?0+$/, '' )
  end

  self.init_wrapper( Rational, [], self.instance_method( :fix_ret ) )

end
