module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sortable(column, title = nil)
    title ||= column.gsub(/_/,' ').titleize
    link_to title, { :sort => column }, id: column + "_header"
  end
  def highlight(column)
    "hilite" if @sort == column
  end
end
