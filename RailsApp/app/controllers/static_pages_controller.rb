class StaticPagesController < ApplicationController

  http_basic_authenticate_with :name => "admin", :password => ENV['ADMIN_PASSWORD'], only: :admin

  after_action :allow_iframe, only: :landing

  def index
  end

  def admin
  end

  def landing
  end

  def stats
  end

  def webapp
  end

  def webapp_college
  end

  def webapp_tag
  end

private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
