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
    File.write('data/out.txt', @memory.join)
    @uniq_lines = @memory.length

    puts '_'*50
    puts "Total Lines \t= #{@total_original_lines}"
    puts "Uniq Lines \t= #{@uniq_lines}"
    puts '_'*50
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
end


RspecProcessor.new
