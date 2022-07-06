def p_header(name)
  identation = 10
  puts "=" * identation + name + "=" * identation
end

def p_dev( data_files, is_dev )
  if is_dev < 0
    return
  end

  python_length = p_header("Python")
  data_files.each do |name, data|
    top_down = -> () {"+#{"-" * (name.length)}+"}

    puts top_down.()
    puts "|#{name}|"
    puts top_down.()
    puts data
  end

  if is_dev != 1
    p_header("App")
  end
end
