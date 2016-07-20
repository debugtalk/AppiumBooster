# filename: lib/pages/actions.rb

module Pages
  module Actions

    def click
      wait { @found_cell.click }
    end

    def type(text)
      wait { @found_cell.type text }
    end

  end # module Actions
end # module Pages
