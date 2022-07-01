def p_header(name)
  identation = 10
  puts "=" * identation + name + "=" * identation 
end

def p_dev( data, is_dev )
  if is_dev < 0
    return
  end

  p_header("Python")
  puts data

  if is_dev != 1
    p_header("App")
  end
end