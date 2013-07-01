class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :new_note

  # Load libraries required by the Evernote OAuth
  require 'oauth'
  require 'oauth/consumer'

  # Load Thrift & Evernote Ruby libraries
  require "evernote_oauth"

  def new_note
    @note = Note.new
  end
end
