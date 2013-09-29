class ReportWithMessagesSerializer < ActiveModel::Serializer
  has_many :messages, serializer: ActiveModel::DefaultSerializer
  has_one :report, serializer: ::FullReportSerializer
end
