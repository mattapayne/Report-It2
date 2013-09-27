//bootstrap Angular
angular.module('ReportIt.constants', []).
  constant('EMAIL_REGEX', /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/).
  constant('INTEGER_REGEX', /^\-?\d*$/).
  constant('CONTACT_URLS', {create_message_url: '/message'}).
  constant('REGISTER_URLS', {create_registration_url: '/register'}).
  constant('FORGOT_PASSWORD_URLS', {create_forgot_password_request_url: 'forgot_password'}).
  constant('REPORT_TEMPLATE_URLS', {
    get_report_template_url: '/report_template/',
    create_report_template_url: '/report_templates',
    update_report_template_url: '/report_template/',
    get_organizations_url: '/organizations',
    get_snippets_url: '/snippets'
  }).
  constant('REPORT_URLS', {
    get_report_url: '/report/',
    create_report_url: '/report',
    update_report_url: '/report/',
    get_organizations_url: '/organizations',
    get_snippets_url: '/snippets'
  }).
  constant('IMAGE_UPLOAD_URLS', {image_upload_url: '/upload/'}).
  constant('DASHBOARD_URLS', {
    get_organizations_url: '/organizations',
    create_organization_url: '/organizations',
    update_organization_url: '/organizations/',
    delete_organization_url: '/organizations/',
    get_snippets_url: '/snippets',
    create_snippet_url: '/snippets',
    update_snippet_url: '/snippets/',
    delete_snippet_url: '/snippets/',
    get_reports_url: '/reports',
    delete_report_url: '/reports/',
    get_report_templates_url: '/report_templates',
    delete_report_template_url: '/report_templates/',
    edit_report_template_url: '/report_templates/edit/',
    add_report_template_url: '/report_templates/new',
    get_settings_url: '/settings',
    update_setting_url: '/settings/'
  });