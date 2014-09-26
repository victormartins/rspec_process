#!/usr/bin/env ruby

class RspecProcessor
  def initialize(stdin_data='')
    @memory               = []
    @total_original_lines = 0
    @uniq_lines           = 0
    @data                 = get_data stdin_data

    process_file
    output_results
  end

  private
  attr_reader :data, :line, :memory

  def get_data stdin_data
    puts 'here'
    if stdin_data.empty?
      puts 'going by the file'
      File.readlines 'data/in.txt'
    else
      stdin_data
    end
  end

  def process_file
    data.each_line do |f|
      f.each_line do |line|
        @total_original_lines += 1
        process line
      end
    end
    @uniq_lines = memory.length
  end

  def output_results
    memory.each{ |l| puts l}

    puts separator
    footer =  "Total Lines \t= #{@total_original_lines}\n"
    footer += "Uniq Lines \t= #{@uniq_lines}"
    puts footer
    puts separator

    File.open('data/out.txt', 'w') do |f|
      # require 'pry'; binding.pry
      f << "rspec #{memory.join.gsub('rspec ', '').gsub("\n", ' ')}"
      f << "\n\n#{separator}FILES\n#{separator}\n\n"
      f << memory.join
      f << "\n\n#{footer}"
    end
  end

  def process line
    @line = line
    return unless line.match /rspec/
    remove_noise

    memory << line unless memory.include? line
  end

  def remove_noise
    line.sub!(/rb(.*)/, 'rb')
  end

  def separator
    '_'*50+"\n"
  end
end

data = ARGF.read
RspecProcessor.new data
