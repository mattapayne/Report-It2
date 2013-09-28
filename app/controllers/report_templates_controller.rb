class ReportTemplatesController < ApplicationController
  before_action :require_login
  before_action :load_report_template, only: [:update, :destroy, :edit, :view]
  before_action :construct_tag_filter, only: [:index]
  before_action :extract_tags, only: [:create, :update]
  
  def index
    case @tag_filter
      when nil
        templates = [] #should switch to the #none syntax
      when ['all'] #ugly - need to change this
        templates = current_user.my_templates
      else
        templates = current_user.my_templates.all_in(tags: @tag_filter)
    end   
    render json: templates.to_a
  end
  
  def new
    @report_template = nil
    @report_template_id = nil
    render :single
  end
  
  def create
    @report_template = current_user.my_templates.build(params_for_report_template)
    if @report_template.save
      update_user_tags(@tags)
      render json: {
        messages: ['Successfully created the report template.'], report_template: @report_template },
      serializer: FullReportTemplateWithMessagesSerializer
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def edit
    @report_template_id = @report_template.id.to_s
    render :single
  end
  
  def update
    if @report_template.update_attributes(params_for_report_template)
      update_user_tags(@tags)
      render json: {
        messages: ['Successfully updated the report template.'], report_template: @report_template },
      serializer: FullReportTemplateWithMessagesSerializer
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def destroy
    if @report_template.delete
      render json: { messages: ["Successfully deleted report template: '#{@report_template.name}'."]}
    else
      render json: { messages: @report_template.errors.full_messages }, status: 406
    end
  end
  
  def view
    #view handles getting either a new or a pre-existing one report_template, so we need to create a new one if
    #one was not found in the before_action of 'load_report_template'
    @report_template = current_user.my_templates.build if @report_template.nil?
    render json: @report_template, serializer: FullReportTemplateSerializer
  end
  
  protected
  
  def get_title(action)
    "#{super} :: Report Templates"
  end
  
  private
  
  def extract_tags
    @tags = params_for_report_template[:tags] if params_for_report_template[:tags].present?
  end
  
  def construct_tag_filter(args)
    @tag_filter = params_for_report_template_filters.split(',') unless params_for_report_template_filters.nil?
  end
  
  def update_user_tags(tags)
    unless tags.nil?
      current_user.template_tags << tags
      current_user.save
    end
  end
  
  def params_for_report_template_filters
    return params.require(:tags) if params[:tags].present?
  end
  
  def params_for_report_template
    params.require(:report_template).permit(:name, :description, :content, tags: [])
  end
  
  def load_report_template
    @report_template = current_user.my_templates.find(params[:id]) unless params[:id].nil?
  end
end
