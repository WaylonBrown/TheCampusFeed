class VersionerController < ApplicationController
  def android
    render json: {minVersion: 1.0}
  end

  def ios
    render json: {minVersion: 1.0}
  end
end
