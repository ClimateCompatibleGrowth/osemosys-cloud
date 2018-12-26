module Osemosys
  class DataFile < Workfile
    def io
      :input
    end

    def type
      :data
    end
  end
end
