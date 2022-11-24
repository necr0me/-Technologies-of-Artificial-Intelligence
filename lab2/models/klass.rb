# Klass - collection of klass_object objects with specific attributes values
class Klass
  attr_accessor :objects

  def initialize
    @objects = []
  end

  class << self
    # Method, that converting parsed sheet into Klass instance.
    # sheet - parsed sheet
    # offset_in_column - offset that tells from which row we need to take data
    # offset_in_row - offset that tells from which column we need to take data
    # object_attributes - attributes, that you want to set in your KlassObject instances.
    def create_from_sheet(sheet: ,
                          offset_in_column: 0,
                          offset_in_row: 0,
                          object_attributes: )

      sheet_height = sheet.length

      new_klass = Klass.new
      new_klass.objects = sheet[offset_in_column..sheet_height - 1].map do |row|
        attributes = Hash.new
        object_attributes.each_with_index do |attribute, index|
          attributes[attribute] = row[index + offset_in_row]
        end
        KlassObject.new(*attributes)
      end
      new_klass
    end
  end

end
