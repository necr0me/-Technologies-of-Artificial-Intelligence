require_relative '../db/knowledge_database'

class ExpertSystem

  def initialize
    run
  end

  private

  attr_accessor :topic, :db

  def run
    loop do
      actions = Hash.new(-> { puts 'Seems no such action. Try again.' })
      actions['1'] = -> { choose_topic }
      actions['2'] = -> { determine }
      actions['3'] = -> { create_db }
      actions['4'] = -> { print_db }
      actions['5'] = -> { remove_db }
      actions['6'] = Proc.new { return }
      puts   "#{'Current topic: ' + @db.filename.green + ".\n" unless @db.nil? }" +
             "\n1. Choose topic.\n"          +
             "2. Determine.\n"               +
             "3. Create new.\n"              +
             "4. Show knowledge database.\n" +
             "5. Delete existing topic.\n"   +
             "6. Exit.\n\n"                  +
             'Enter number of action, that you want to do: '
      action = gets.chomp
      actions[action].call
    end
  end

  def determine
    if @db.nil?
      puts "You need to choose topic first. \n"
      return
    end
    local_db = Marshal.load(Marshal.dump(@db))
    loop do
      if local_db.objects.count <= 1 || local_db.attributes.count == 0 || local_db.matrix.uniq.count == 1
        puts "#{local_db.objects.count < 1 ? 'There is no object with such attributes'.red : 'Answer is ' + local_db.objects.map(&:green).join(' or ') }"
        return
      end
      sums = local_db.matrix.map.with_index.sort_by{|row_with_index| row_with_index.first.map(&:to_i).inject(:+) }
      least_sum = sums.first
      puts question = "Does your object have #{local_db.attributes[least_sum.last]}? (y/n)"
      answer = gets.chomp.downcase[0]
      until %w[y n].include?(answer)
        puts "Wrong answer. Try again.\n#{question}"
        answer = gets.chomp.downcase[0]
      end
      answers = {
        'y' => -> { find_number_indexes(least_sum.first, 0) },
        'n' => -> { find_number_indexes(least_sum.first, 1) }
      }
      local_db.remove_rows([least_sum.last])
      local_db.remove_columns(answers[answer].call)
      # local_db.print
    end
  end

  def find_number_indexes(row, number)
    row.map.with_index.find_all { |e| e.first.to_i == number }.map { |e| e.last }
  end

  def create_db
    @db = KnowledgeDatabase.create
  end

  def print_db
    puts @db.nil? ? "You haven't choose a topic, so there is no any db to print." : @db.print
  end

  def remove_db
    topics = get_topics
    loop do
      puts topics
      puts "\nEnter name of topic that you want to delete (write 'b' to back): "
      topic = gets.chomp.downcase
      return if topic == 'b'

      if topics.include?(topic)
        File.delete("/data/#{topic}.txt")
        @db = nil if topic == @db.filename
        return
      else
        puts "\nNo such topic in the list. Try again.\n"
      end
    end
  end

  def choose_topic
    topics = get_topics
    puts "\nList of topics: "
    loop do
      puts topics.map(&:green)
      puts "\nEnter name of topic that you want to choose (write 'b' to back): "
      topic = gets.chomp.downcase
      return if topic == 'b'

      if topics.include?(topic)
        @db = KnowledgeDatabase.open(topic)
        return
      else
        puts "\nNo such topic in the list. Try again.\n"
      end
    end
  end

  def get_topics
    Dir['data/*.txt'].map{|topic| topic.split('.txt').first.delete_prefix('data/')}
  end

end
