class Diff
  TAGS = {
    :insertion => { :open => "<ins>", :close => "</ins>" },
    :deletion => { :open => "<del>", :close => "</del>" }
  }
    
  def initialize(original, modified)
    @original = html_escape(original).split(/(\n)|( )/)
    @original.delete("")
    @modified = html_escape(modified).split(/(\n)|( )/)
    @modified.delete("")
    @lcs = lcs
  end
  
  def to_html
    @output = ""
    render(@lcs, @original, @modified, @original.length, @modified.length)
    @output << close_tag
    return @output.gsub("\n", "<br />")
  end
  
  private
    def lcs
      x = @original
      y = @modified
      m, n = x.size, y.size
      c = Array.new(m + 1) { Array.new(n + 1, 0) }
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
    
    def render(c, x, y, i, j)
      if i > 0 && j > 0 && x[i-1] == y[j-1]
        render(c, x, y, i-1, j-1)
        @output << close_tag + x[i-1]
      else
        if j > 0 and (i == 0 || c[i][j-1] >= c[i-1][j])
          render(c, x, y, i, j-1)
          @output << open_tag(:insertion)
          @output << y[j-1]
        elsif i > 0 and (j == 0 || c[i][j-1] < c[i-1][j])
          render(c, x, y, i-1, j)
          @output << open_tag(:deletion)
          @output << x[i-1]
        end
      end
    end
    
    def open_tag(tag)
      if @current_tag == tag
        return ""
      else
        if @current_tag.nil?
          @current_tag = tag
          return TAGS[tag][:open]
        else
          full_tag = close_tag
          @current_tag = tag
          full_tag += TAGS[tag][:open]
          return full_tag
        end
      end
    end
    
    def close_tag
      if @current_tag
        @output.chomp!
        tag = TAGS[@current_tag][:close]
        @current_tag = nil
        return tag
      else
        return ""
      end
    end
end