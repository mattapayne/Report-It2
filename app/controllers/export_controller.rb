class ExportController < ApplicationController
  before_action :require_login
  before_action :load_report
  
  def export
    format = params[:file_format]
    case format
      when 'pdf'
        kit = PDFKit.new(@report.content)
        send_data(kit.to_pdf, :filename => "#{@report.name}.pdf", :type => 'application/pdf')
        return # to avoid double render call
    end
  end
  
  private
  def load_report
    @report = Report.find(params[:id]) if params[:id]
    unless @report.present?
      redirect_to dashboard_path, error: "Unable to find that report" and return
    end
    unless @report.owned_by_or_shared_with?(current_user)
      redirect_to dashboard_path, error: "You do not have permission to access that report" and return
    end
  end
end
