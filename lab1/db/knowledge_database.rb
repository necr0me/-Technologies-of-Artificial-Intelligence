require_relative '../console_output_modification/centrify'
require_relative '../console_output_modification/coloring'

class KnowledgeDatabase

  attr_accessor :filename, :matrix, :attributes, :objects

  def initialize(filename, matrix, attributes, objects)
    @filename = filename
    @matrix = matrix
    @attributes = attributes
    @objects = objects
  end

  def self.open(filename)
    filename.downcase!
    num_of_rows = File.foreach("data/#{filename}.txt").inject(0) {|c, line| c+1}
    File.open("data/#{filename}.txt") do |file|
      @current_topic = filename
      attributes, matrix = [], []
      objects = file.readline.split(',').map(&:strip)
      (num_of_rows - 1).times do
        row = file.readline.split('|')
        attributes << row.first
        matrix << row.last.split(' ')
      end
      self.new(filename, matrix, attributes, objects)
    end
  end


  def self.create
    puts 'Enter topic name: '
    topic = gets.chomp.strip
    puts 'Enter objects (separated with comas ,): '
    objects = gets.chomp.split(',').reject{ |c| c.empty? }.map(&:strip)
    puts 'Enter attributes (separated with comas ,): '
    attributes = gets.chomp.split(',').reject{ |c| c.empty? }.map(&:strip)
    puts 'Enter matrix with answers (1 - true, 0 - false).'
    puts "#{objects.map(&:green).join(' | ')}"
    puts 'Separate numbers with spaces: '
    matrix = []
    attributes.count.times do |index|
      puts "Enter row number #{index + 1} (#{attributes[index].green} attribute): "
      row_answers = gets.chomp.split(' ')
      matrix << row_answers[0..objects.count - 1]
    end

    File.open(File.expand_path("data/#{topic.downcase}.txt"), 'w') do |file|
      file.write(objects.join(', ') + "\n")
      matrix.each_with_index do |row, index|
        file.write("#{attributes[index]}|#{matrix[index].join(' ')} \n")
      end
    end

    self.new(topic, matrix, attributes, objects)
  end

  def print
    puts to_table
  end

  def remove_rows(indexes)
    indexes.each do |index|
      @matrix[index] = nil
      @attributes[index] = nil
    end
    @matrix.compact!
    @attributes.compact!
  end

  def remove_columns(indexes)
    @matrix.map do |row|
      indexes.each do |index|
        @objects[index] = nil
        row[index] = nil
        row.compact!
      end
    end
    @objects.compact!
  end

  private

  def to_table
    table = ''
    first_column_size = @attributes.max_by(&:length).length+2
    other_columns_size = @objects.max_by(&:length).length+2
    divider = "+#{'-' * first_column_size}+"
    objects.count.times do
      divider += "#{'-'*other_columns_size}+"
    end
    table += divider + "\n"
    first_row = "|#{' '*first_column_size}|"
    @objects.count.times do |obj_index|
      first_row += @objects[obj_index].centrify(other_columns_size) + '|'
    end
    table += first_row + "\n" + divider + "\n"
    @attributes.count.times do |atr_index|
      row = '|'
      row += @attributes[atr_index].centrify(first_column_size) + '|'
      @objects.count.times do |matr_index|
        row += @matrix[atr_index][matr_index].to_s.centrify(other_columns_size) + '|'
      end
      table += row + "\n" + divider + "\n"
    end
    table
  end
end
