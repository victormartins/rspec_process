class RspecProcessor
  Line = Struct.new(:path, :repetitions)

  def initialize
    @memory                          = []
    @total_original_lines            = 0
    @uniq_lines                      = 0
    @number_of_line_path_repetitions = 0

    process_file
    output_results
  end

  private
  attr_reader :memory

  def process_file
    File.open('data/in.txt', 'r') do |f|
      f.each_line do |line|
        @total_original_lines += 1
        process line
      end
    end
    @uniq_lines = memory.length
  end

  def output_results


    memory.sort_by!{ |line| line.repetitions}
    memory.reverse!

    longest_path_size = memory.group_by{ |line| line.path.length }.max.first
    longest_path_size = longest_path_size + 3

    lines_to_write_to_file = []
    memory.each do |line|
      path = line.path
      repetitions = ''

      if line.repetitions > 0
        path = path.ljust(longest_path_size, '.')
        repetitions = "(x#{line.repetitions})" if line.repetitions > 0
      end

      formatted_output_line = "#{path}#{repetitions}"
      puts formatted_output_line
      lines_to_write_to_file << formatted_output_line
    end

    puts separator
    footer =  "Total Lines \t= #{@total_original_lines}\n"
    footer += "Uniq Lines \t= #{@uniq_lines}"
    puts footer
    puts separator

    File.open('data/out.txt', 'w') do |f|
      # require 'pry'; binding.pry
      f << "rspec #{memory.map{|line| line.path}.join(' ').gsub('rspec ', '').gsub("\n", ' ')}"
      f << "\n\n#{separator}FILES\n#{separator}\n\n"
      f << lines_to_write_to_file.join("\n")
      f << "\n\n#{footer}"
    end
  end

  def process txt_line
    return unless txt_line.match /rspec/
    line_path = remove_noise_from(txt_line)

    if memory.any? && memory.select{ |line| line.path == line_path}.any?
      @number_of_line_path_repetitions += 1
    else
      if @number_of_line_path_repetitions > 0
         memory.last.repetitions = @number_of_line_path_repetitions
         @number_of_line_path_repetitions = 0
      end

      memory << Line.new(line_path, @number_of_line_path_repetitions)
    end
  end

  def remove_noise_from(txt_line)
    # line.sub!(/\s#.*/, '')
    txt_line.sub(/rb(.*)/, 'rb').gsub("\n",'')
  end

  def separator
    '_'*50+"\n"
  end
end


RspecProcessor.new
