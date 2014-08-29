class StaticPagesController < ApplicationController

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


end
