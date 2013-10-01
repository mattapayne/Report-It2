//bootstrap Angular
angular.module('ReportIt.constants', []).
  constant('EMAIL_REGEX', /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/).
  constant('INTEGER_REGEX', /^\-?\d*$/).
  constant('CONTACT_URLS', {create_message_url: '/message'}).
  constant('REGISTER_URLS', {create_registration_url: '/register'}).
  constant('FORGOT_PASSWORD_URLS', {create_forgot_password_request_url: 'forgot_password'}).
  constant('REPORT_TEMPLATE_URLS', {
    new_report_template_url: '/report_templates/new',
    update_report_template_url: '/report_templates/update/',
    get_snippets_url: '/snippets',
    get_report_template_json_url: '/report_templates/edit_json/',
    get_new_report_template_json_url: '/report_templates/new_json',
    create_report_template_url: '/report_templates/create'
  }).
  constant('REPORT_URLS', {
    new_report_url: '/reports/new',
    update_report_url: '/reports/update/',
    get_snippets_url: '/snippets',
    get_report_json_url: '/reports/edit_json/',
    get_new_report_json_url: '/reports/new_json',
    create_report_url: '/reports/create'
  }).
  constant('IMAGE_UPLOAD_URLS', {image_upload_url: '/upload/'}).
  constant('DASHBOARD_URLS', {
    get_snippets_url: '/snippets',
    create_snippet_url: '/snippets',
    update_snippet_url: '/snippets/',
    delete_snippet_url: '/snippets/',
    get_reports_url: '/reports',
    delete_report_url: '/reports/delete/',
    get_report_templates_url: '/report_templates',
    delete_report_template_url: '/report_templates/delete/',
    edit_report_template_url: '/report_templates/edit/',
    new_report_template_url: '/report_templates/new',
    new_report_url: '/reports/new',
    edit_report_url: '/reports/edit/',
    get_settings_url: '/settings',
    update_setting_url: '/settings/',
    get_user_tags_url: '/user_tags',
    get_shares_for_report_template_url: 'report_templates/shares/',
    update_report_template_share: '/report_templates/update_share',
    get_shares_for_report_url: 'reports/shares/',
    update_report_share: '/reports/update_share'
  });