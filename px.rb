class Px
  attr_reader :data

  def initialize(file)
    if not File.readable?(file)
      raise "File #{file} is not readable"
    end

    @file = file
    @data = Hash.new

    parse(@file)
  end

  def parse(file)
    ## Read file to data
    File.foreach(@file) do |line|
      line.chomp!
      parse_line(line)
    end
  end

  def parse_line(line)
    # If we've got no current record, then we assume we're on a KEY=VALUE line
    # Otherwise, we're on a multiline record.
    if @record_cur.nil?
      key, value = line.scan(/[^=]+/)
      @record_cur = key
    else
      value = line
    end

    if @data.has_key?(@record_cur)
      @data[@record_cur] << value
    else
      # Value can be nil from the regex parsing above where there's no rhs 
      # e.g. on DATA= line
      if value.nil?
        @data[@record_cur] = ""
      else
        @data[@record_cur] = value
      end
    end

    # If we see a ; at the end of the line, close out the record so we 
    # expect a new record.
    if line[-1..-1] == ";"
      record_end = true
      @record_cur = nil
    end
  end
end
