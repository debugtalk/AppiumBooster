# filename: lib/pages/actions.rb

module Pages
  module Actions

    def send_keys(text)
      wait { @found_element.send_keys text }
    end

    def _type(text)
      wait { @found_element.type text }
    end

    def type(text)
      begin
        _type(text)
      rescue Selenium::WebDriver::Error::UnknownError => ex
        $LOG.error "Selenium::WebDriver::Error::UnknownError: #{ex}".magenta
        scrollToDisplay
        _type(text)
      end
    end

    def _click
      wait { @found_element.click }
    end

    def click
      begin
        _click
      rescue Selenium::WebDriver::Error::UnknownError => ex
        $LOG.error "Selenium::WebDriver::Error::UnknownError: #{ex}".magenta
        scrollToDisplay
        _click
      end
    end

    def tapByCoordinate
      scrollToDisplay
      x_loc = @found_element.location.x
      y_loc = @found_element.location.y
      Appium::TouchAction.new.tap(x:x_loc, y:y_loc).perform
    end

    def scrollToDisplay
      while true
        if @found_element.displayed?
          return
        end

        x = eval @found_element.location_rel.x
        y = eval @found_element.location_rel.y

        if y < 0
          scrollUp
        elsif y > 1
          scrollDown
        elsif x < 0
          scrollRightAtHeight
        elsif x > 1
          scrollLeftAtHeight
        else
          # 0 < x < 1 && 0 < y < 1
          # the element is in current screen
          break
        end

        next
      end # while
    end

    def scroll(direction)
      begin
        $LOG.info "scroll #{direction}"
        execute_script 'mobile: scroll', direction: direction
      rescue Selenium::WebDriver::Error::JavascriptError
      end
    end

    def scrollUp
      scroll 'up'
    end

    def scrollDown
      scroll 'down'
    end

    def scrollLeft
      scroll 'left'
    end

    def scrollRight
      scroll 'right'
    end

    def scrollHorizontally(direction)
      y_rel = @found_element.location_rel.y
      $LOG.info "scroll #{direction} at height #{y_rel}"

      width = window_size.width
      y_loc = @found_element.location.y
      if direction.downcase == 'left'
        x_start = width
        x_move = -1 * width
      elsif direction.downcase == 'right'
        x_start = 0
        x_move = width
      else
        raise "unexpected direction!"
      end

      Appium::TouchAction.new.
        press(:x => x_start, :y => y_loc).
        move_to(:x => x_move, :y => 0).
        release.
        perform
    end

    def scrollLeftAtHeight
      scrollHorizontally 'left'
    end

    def scrollRightAtHeight
      scrollHorizontally 'right'
    end

  end # module Actions
end # module Pages
