module ActsAsTaggableOn
  class Tag < ::ActiveRecord::Base
    def self.ordered
      order(:name)
    end

    def self.with_taggings
      where('taggings_count > ?', 0)
    end
  end
end
