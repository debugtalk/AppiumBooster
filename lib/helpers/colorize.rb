# filename: lib/helpers/colorize.rb

class String
  # colorization
  def colorize(color_code)
    if (defined? OUTPUT_WITH_COLOR) && (not OUTPUT_WITH_COLOR)
      self
    else
      "\e[#{color_code}m#{self}\e[0m"
    end
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def magenta
    colorize(35)
  end

  def cyan
    colorize(36)
  end

  def white
    colorize(37)
  end
end
