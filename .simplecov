SimpleCov.start do
  add_filter "test/"
  at_exit do
    SimpleCov.result.format!
  end
end
