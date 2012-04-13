class Array
  def binary_search_by( target )
    first = 0
    first_v = yield self[first]
    return first if first_v == target
    last = self.length - 1
    last_v = yield self[last]
    return last if last_v == target
    mid_v = nil
    while last - first > 2 do
      mid = first + (last - first)/2
      mid_v = yield self[mid]
      if mid_v == target then
        return mid
      elsif mid_v < target then
        first = mid
      else
        last = mid
      end
    end
    return first + 1 if last - first == 2
    return first
  end
end
