module OcbScopes
  extend ActiveSupport::Concern

  class_methods do
    def ocb_scopes(association_name)
      scope :ocb, -> { joins(association_name).where(association_name => { name: 'ocb_eth' }) }
      scope :direct, -> { joins(association_name).where.not(association_name => { name: 'ocb_eth' }) }
    end
  end
end
