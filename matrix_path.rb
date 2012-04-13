class PathCell
  def initialize( value )
    @value = value
    @min_path = nil
    @paths_from = []
    @dbg = false
    @notified = false
    @name = ""
  end
  attr_reader :name, :min_path, :value, :notified

  def name!( name )
    @name = name
  end
  def dbg!( toggle )
    @dbg = toggle
  end
  def path_from!( cell )
    @paths_from << cell
  end

  def paths_to!( cells )
    @paths_to = cells
    @paths_to.each { |neighbor| 
      neighbor.path_from!( self )
    }
  end
  def min_path!( val )
    @min_path = val
    @notified = false
    if @dbg then
      print @name + ": Min: ", @min_path, "\n"
    end
    @paths_from.each { |neighbor|
      neighbor.notify!
    }
  end
  def notify! ; @notified = true ; end

  def calc_min_path!
    return if not @notified
    if @dbg then
      print @name + ": calc_min\n"
    end
    m = ((@paths_to.select { |x| x.min_path != nil }
         ).collect { |x| x.min_path } ).min
    @notified = false
    if m != nil then
      m += @value
      if @min_path == nil or m < @min_path then
        self.min_path!( m )
      end
    end
  end
end


class PathMatrix
  def initialize( filename, travel_spec )
    @cells = []
    IO.foreach(filename) {
      |line|
      @cells << line.chomp().split(',').map { |s| PathCell.new( s.to_i() ) }
    }
    i_range = (0..(@cells.length - 1))
    i_range.each { |i|
      j_range = (0..(@cells[i].length - 1))
      j_range.each { |j|
        to_cells = self.cell_slice( travel_spec.collect { |c|
                                      [i + c[0],j + c[1]] } )
        @cells[i][j].paths_to!( to_cells )
        @cells[i][j].name!( i.to_s + "," + j.to_s )
        # @cells[i][j].dbg!(true)
      }
    }
    @cells[0][0].dbg!(true)
    #self.cell_slice( destinations ).each { |c|
    #  c.min_path!( c.value )
    #}
  end
  def set_destination( destinations )
    self.cell_slice( destinations ).each { |c|
      c.min_path!( c.value )
    }
  end
  def cell_slice( coordinate_list )
    ( coordinate_list.select{ |c|
        0 <= c[0] and c[0] < @cells.length and
        0 <= c[1] and c[1] < @cells[c[0]].length }
      ).collect { |c| @cells[c[0]][c[1]] }
  end
  def find_min_path( starting_points )
    while true do
      to_calc = @cells.flatten.select { |c| c.notified }
      break if to_calc.length == 0 
      #print "Calc: ", (to_calc.map { |c| c.name }).join("  "), "\n"
      to_calc.each { |c| c.calc_min_path! }
    end
    (self.cell_slice( starting_points ).map { |c| c.min_path }).min
  end
end
