class SearchParams::InvitationSearchParams
  include SearchParams::BaseSearchParams

  attr_accessor :type

  def initialize(opts={})
    setup(opts)
    if opts[:type].present?
      @type = opts[:type].to_s.downcase.singularize.to_sym
    end
  end
end
