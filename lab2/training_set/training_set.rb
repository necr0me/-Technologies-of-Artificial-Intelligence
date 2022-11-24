require_relative '../models/klass_object'
# TrainingSet - class, that implements all necessary methods for finding valuable (informative) attributes.
# Process of determining valuable attributes implemented using Kolmogorov-Smirnov test.
class TrainingSet

  SIGNIFICANCE_LEVELS = {
    0.01 => 1.224,
    0.05 => 1.358,
    0.1 => 1.628
  }

  attr_accessor :klasses, :attributes

  def initialize(klasses, attributes)
    @klasses = klasses
    @attributes = attributes

    KlassObject.set_attr_reader!(*attributes)
  end

  def objects
    @klasses.inject([]) { |arr, (k, v)| arr + v.objects }
  end

  def valuable_attributes(alpha: 0.01)
    valuable = []
    attributes.each do |attribute|
      set_frequencies = []
      klasses.each do |key, value|
        values_counts = Hash.new(0)
        value.objects.each { |obj| values_counts[obj.public_send(attribute)] += 1 }
        set_frequencies << values_counts
      end
      set_frequencies.each_cons(2) do
        valuable << attribute unless ks_test(set_1: _1, set_2: _2, alpha: alpha)
      end
    end
    valuable
  end

  private

  def ks_test(set_1:, set_2:, alpha:)
    n_1, n_2 = 0, 0
    set_1_count = set_1.inject(0) { |sum, (key, value)| sum + value}
    set_2_count = set_2.inject(0) { |sum, (key, value)| sum + value}
    max_value = (set_1.keys + set_2.keys).uniq.sort.map do |key|
      n_1 += set_1[key]
      n_2 += set_2[key]
      (n_1.to_f / set_1_count - n_2.to_f / set_2_count).abs
    end
                                         .max
    max_value * Math.sqrt((n_1 * n_2) / (n_1 + n_2)) < SIGNIFICANCE_LEVELS[alpha] ? true : false
  end

end
