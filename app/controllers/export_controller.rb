class ExportController < ApplicationController
  layout :false
  before_action :require_login, only: :export
  before_action :load_report
  before_action :check_access_rights, only: :export
  
  def export
    format = params[:file_format]
    case format
      when 'pdf'
        options = { }
        if @report.header.present?
          header_url = export_header_url(@report)
          options[:header_html] = header_url
        end
        if @report.footer.present?
          footer_url = export_footer_url(@report)
          options[:footer_html] = footer_url
        end
        kit = PDFKit.new(@report.content, options)
        send_data(kit.to_pdf, :filename => "#{@report.name}.pdf", :type => 'application/pdf')
        return # to avoid double render call
    end
  end
  
  def header
   
  end
  
  def footer

  end
  
  private
  
  def check_access_rights
    unless @report.present?
      redirect_to dashboard_path, error: "Unable to find that report" and return
    end
    unless @report.owned_by_or_shared_with?(current_user)
      redirect_to dashboard_path, error: "You do not have permission to access that report" and return
    end
  end
  
  def load_report
    @report = Report.find(params[:id]) if params[:id]
  end
end
