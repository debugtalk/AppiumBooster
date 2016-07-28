# filename: ios/pages/helpers/actions.rb

module Actions

  def click
    wait { @found_cell.click }
  end

  def type(text)
    wait { @found_cell.type text }
  end

end
