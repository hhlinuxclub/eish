module Diff
  def diff(x, y)
    a, b = [], []
    x.lines.each { |l| a << l.chomp }
    y.lines.each { |l| b << l.chomp }
    i = a.length
    j = b.length
    c = LCS(a, b, i, j)
    @diff = []
    make_diff(c, a, b, i, j)
    @diff.each { |l| l << "\n"}
    return @diff
  end
  
  private
  
    def LCS(x, y, m, n)
      c = []
      (0..m).each { c << [0] * (n+1) }
      (1..m).each do |i|
        (1..n).each do |j|
          if x[i-1] == y[j-1]
            c[i][j] = c[i-1][j-1] + 1
          else
            c[i][j] = [c[i][j-1], c[i-1][j]].max
          end
        end
      end

      return c
    end

    def make_diff(c, x, y, i, j)
      if i > 0 && j > 0 && x[i-1] == y[j-1]
        make_diff(c, x, y, i-1, j-1)
        @diff << "  " + x[i-1]
      else
        if j > 0 and (i == 0 || c[i][j-1] >= c[i-1][j])
          make_diff(c, x, y, i, j-1)
          @diff << "+ " + y[j-1]
        elsif i > 0 and (j == 0 || c[i][j-1] < c[i-1][j])
          make_diff(c, x, y, i-1, j)
          @diff << "- " + x[i-1]
        end
      end
    end
end