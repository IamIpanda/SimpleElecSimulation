require 'matrix.rb'
class Matrix

  def []=(i, j, x)
    @rows[i][j] = x
  end

  def -

  end

  def inspect
    str = "Matrix #{self.row_count} X #{self.column_count}\n"
    for i in 0...self.row_count
      for j in 0...self.column_count
        str += sprintf("%8s", self[i, j])
      end
      str += "\n"
    end
    str
  end

  # 按照给定的顺序堆叠矩阵。
  # @param [Array] array
  def Matrix.mstack(array)
    Matrix.vstack(*(array.collect { |rows| Matrix.hstack(*rows) }))
  end

  # vstack, new code in Ruby 2.2. Copy from code.
  def Matrix.vstack(x, *matrices)
    raise TypeError, "Expected a Matrix, got a #{x.class}" unless x.is_a?(Matrix)
    result = x.send(:rows).map(&:dup)
    matrices.each do |m|
      raise TypeError, "Expected a Matrix, got a #{m.class}" unless m.is_a?(Matrix)
      if m.column_count != x.column_count
        raise ErrDimensionMismatch, "The given matrices must have #{x.column_count} columns, but one has #{m.column_count}"
      end
      result.concat(m.send(:rows))
    end
    new result, x.column_count
  end

  # hstack, new code in Ruby 2.2. Copy from code.
  def Matrix.hstack(x, *matrices)
    raise TypeError, "Expected a Matrix, got a #{x.class}" unless x.is_a?(Matrix)
    result = x.send(:rows).map(&:dup)
    total_column_count = x.column_count
    matrices.each do |m|
      raise TypeError, "Expected a Matrix, got a #{m.class}" unless m.is_a?(Matrix)
      if m.row_count != x.row_count
        raise ErrDimensionMismatch, "The given matrices must have #{x.row_count} rows, but one has #{m.row_count}"
      end
      result.each_with_index do |row, i|
        row.concat m.send(:rows)[i]
      end
      total_column_count += m.column_count
    end
    new result, total_column_count
  end
end