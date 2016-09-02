# filename: lib/helpers/util.rb

def eval_expression(str)
  """ evaluate ruby expression
  e.g.
    ${Time.now.to_i}@debugtalk.com => 1471318368@debugtalk.com
  """
  if str && str.class == String
    str_copy = str.dup
    str_copy.gsub!(/\$\{(.*?)\}/) do
      eval($1)
    end
    return str_copy
  end
  str
end
