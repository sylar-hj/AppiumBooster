# filename: lib/pages/actions.rb

module Pages
  module Actions

    def type(text)
      scrollToDisplay
      wait { @found_element.type text }
    end

    def click
      scrollToDisplay
      wait { @found_element.click }
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
        puts "scroll #{direction}"
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
      puts "scroll #{direction} at height #{y_rel}"

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
