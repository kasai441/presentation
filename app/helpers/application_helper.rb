# frozen_string_literal: true

module ApplicationHelper
  include ERB::Util
  def hbr(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, '<br />')
  end
end
