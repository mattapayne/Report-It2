class ReportTemplateWithMessagesSerializer < ActiveModel::Serializer
  has_many :messages, serializer: ActiveModel::DefaultSerializer
  has_one :report_template, serializer: ::FullReportTemplateSerializer
end
