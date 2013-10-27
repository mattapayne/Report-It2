PDFKit.configure do |config|       
  config.default_options = { page_size: 'A4', print_media_type: true }
  config.wkhtmltopdf = File.join(Rails.root, "bin", "wkhtmltopdf.app", "Contents", "MacOS", "wkhtmltopdf")
end 