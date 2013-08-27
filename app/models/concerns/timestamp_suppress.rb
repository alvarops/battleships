module TimestampSuppress
  extend ActiveSupport::Concern

  included do
    def as_json options
      super(options.merge(exclude: [:created_ad, :updated_at]))
    end
  end

end