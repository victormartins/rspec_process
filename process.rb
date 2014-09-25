class RspecProcessor
  def initialize
    @memory               = []
    @total_original_lines = 0
    @uniq_lines           = 0

    File.open('data/in.txt', 'r') do |f|
      f.each_line do |line|
        @total_original_lines += 1
        process line
      end
    end

    @memory.each{ |l| puts l}


    puts separator
    footer =  "Total Lines \t= #{@total_original_lines}\n"
    footer += "Uniq Lines \t= #{@uniq_lines}"
    puts footer
    puts separator

    File.open('data/out.txt', 'w') do |f|
      # require 'pry'; binding.pry
      f << "rspec #{@memory.join.gsub('rspec ', '').gsub("\n", ' ')}"
      f << "\n\n#{separator}FILES\n#{separator}\n\n"
      f << @memory.join
      f << "\n\n#{footer}"
    end

    @uniq_lines = @memory.length

  end

  private
  attr_reader :line, :memory

  def process line
    @line = line
    return unless line.match /rspec/
    remove_noise

    @memory << line unless memory.include? line
  end

  def remove_noise
    line.sub!(/rb(.*)/, 'rb')
  end

  def separator
    '_'*50+"\n"
  end
end


RspecProcessor.new
