require 'rubyXL'
require 'rubyXL/convenience_methods'

require_relative 'models/klass'
require_relative 'models/klass_object'
require_relative 'training_set/training_set'
require_relative 'parser/xlsx_parser'

PATH_TO_FILE = 'data/Занятие_09_Модельные данные.xlsx'
ATTRIBUTES = XlsxParser.parse_sheet(PATH_TO_FILE, 'ATTRIBUTES').first


healthy_sheet = XlsxParser.parse_sheet(PATH_TO_FILE, 'HEALTHY')
sick_sheet = XlsxParser.parse_sheet(PATH_TO_FILE, 'SICK')

klasses_alphabet = {}

klasses_alphabet[:sick] = Klass.create_from_sheet(sheet: sick_sheet,
                                                  offset_in_column: 1,
                                                  offset_in_row: 1,
                                                  object_attributes: ATTRIBUTES)

klasses_alphabet[:healthy] = Klass.create_from_sheet(sheet: healthy_sheet,
                                                     offset_in_column: 1,
                                                     offset_in_row: 1,
                                                     object_attributes: ATTRIBUTES)

training_set = TrainingSet.new(klasses_alphabet, ATTRIBUTES)

puts training_set.valuable_attributes
