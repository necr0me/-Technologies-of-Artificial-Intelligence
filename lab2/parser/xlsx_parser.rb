class XlsxParser

  class << self
    def parse_sheet(path_to_file, sheet_name)
      cells = []
      workbook = RubyXL::Parser.parse(path_to_file)
      workbook[sheet_name].each do |line|
        line_of_cells = []
        line.cells.each do |cell|
          line_of_cells << cell.value
        end
        cells << line_of_cells
      end
      cells
    end
  end
end
