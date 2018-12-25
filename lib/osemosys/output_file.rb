module Osemosys
  class OutputFile < Workfile
    def io
      :output
    end

    def type
      :result
    end
  end
end
