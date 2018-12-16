# frozen_string_literal: true

module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'CFLN'
    if page_title.empty?
      base_title
    else
      base_title + ' | ' + page_title
    end
  end

  def bootstrap_class_for flash_type
    { success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div,
                         message,
                         class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible",
                         role: 'alert') do
               concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
                 concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
                 concat content_tag(:span, 'Close', class: 'sr-only')
               end)
               concat message
             end)
    end
    nil
  end
end
