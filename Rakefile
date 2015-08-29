require 'tempfile'
require 'fileutils'

task :trim do
  `git status --porcelain`.each_line { |item|
    components = item.split(' ')
    next if components[0] != 'M'

    # path = "#{Dir.pwd}/#{item.split(' ')[1]}"
    path = item.split(' ')[1]
    temp_file = Tempfile.new("git.temp")
    begin
      File.open(path, 'r') do |file|
        file.each_line do |line|
          stripped = line.rstrip
          temp_file.puts stripped
        end
      end
      temp_file.close
      FileUtils.mv(temp_file.path, path)
    ensure
      temp_file.close
      temp_file.unlink
    end
  }
end
