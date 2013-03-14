# comment 1
# comment 1.2

# comment 2
class SquareRootExpansion
  def initialize( n )
    @n = n
    int_digits,frac_digits = n.to_s.split('.')
    if int_digits.length % 2 == 1 then
      int_digits = '0' + int_digits
    end
    frac_digits ||= ''
    if frac_digits.length % 2 == 1 then
      frac_digits += '0'
    end
    int_length = int_digits.length / 2
    str_digits = int_digits + frac_digits
    @digit_groups = []
    (0..str_digits.length/2).each do
      |i|
      @digit_groups << str_digits[2*i..(2*i+1)].to_i
    end
    @remainder = 0
    @p = 0
    @done = false
    int_length.times do
      next_digit
    end
    @int_val = @p
  end
  def to_i
    @int_val
  end
  def next_digit
    if @digit_groups.length == 0 then
      if @remainder == 0 then
        return nil
      else
        c = @remainder * 100
      end
    else
      c = @remainder * 100 + @digit_groups.shift
    end
    d = nil
    (1..9).each do
      |d|
      if d * (20*@p + d)  > c then
        d -= 1
        break
      end
    end
    @remainder = c - d*(20*@p + d) 
    @p = 10 * @p + d
    return d
  end
  def each
    if @p > @int_val then
      existing_digits = @p.to_s[@int_val.to_s.length..-1]
      existing_digits.split('').each { |d| yield d.to_i }
    end
    loop do
      d = next_digit
      break if d == nil
      yield d
    end
  end
        
end
