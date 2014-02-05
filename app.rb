require 'bundler'

Bundler.require(:default)

register Hatchet

Hatchet.configure do |config|
  config.level :info
end

IGNORE = ['favicon.ico']

def html_wrapper(content)
  "<html><body>#{content}</body></html>"
end

get '/' do
  [200, {}, html_wrapper("Shortinator")]
end

get '/:id' do
  pass if IGNORE.include?(params[:id])

  begin
    redirect_to_url = Shortinator.click(params[:id], request.ip)
    log.info { "redirect_to_url=#{redirect_to_url}" }
    [302, { "Location" => redirect_to_url }, html_wrapper("<a href=\"#{redirect_to_url}\">#{redirect_to_url}</a>")]
  rescue => e
    logger.error e.message
    [404, {}, html_wrapper("Not found")]
  end
end
