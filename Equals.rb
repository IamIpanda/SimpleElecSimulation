require File.dirname(__FILE__) + '/MatrixFix.rb'

module Equals
  # 试图使用克拉默法则求解方程 aX = b
  # @param [Matrix] a
  # @param [Vector] b
  # @return [Vector]
  def self.Cramer(a, b)
    b = b.column_vectors[0] if b.is_a?(Matrix)
    return nil if !a.square?
    bases = a.determinant + 0.0
    return nil if bases == 0
    vectors = a.column_vectors
    x = []
    for i in 0...a.row_count
      dragged_out_vector = vectors[i]
      vectors[i] = b
      x.push Matrix.columns(vectors).determinant / bases
      vectors[i] = dragged_out_vector
    end
    x
  end

  # @param [Matrix] a
  # @return [Array]
  def self.LU(a)
    return nil if !a.square?
    n = a.row_count
    l = Matrix.diagonal(*[1] * n)
    u = Matrix.zero(n)
    for k in 1..n
      for j in k..n
        sum = 0
        for i in 1..k - 1
          sum += l[k, i] * u[i, j]
        end
        u[k, j] = a[k, j] - sum
      end
      for i in (k + 1)..n
        sum = 0
        for p in 1..k - 1
          sum += l[i, p] * u[p, k]
        end
        l[i, k] = (a[i, k] - sum) / u[k , k]
      end
    end
    [l, u]
  end
end