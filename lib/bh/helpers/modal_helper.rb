require 'bh/helpers/base_helper'

module Bh
  # Provides methods to include modals.
  # @see http://getbootstrap.com/javascript/#modals
  module ModalHelper
    include BaseHelper

    # Returns an HTML block tag that follows the Bootstrap documentation
    # on how to display *modals*.
    #
    # The content of the modal can either be passed as the first parameter (in
    # which case, the options are the second parameter), or as a block (in
    # which case, the options are the first paramter).
    # @example An modal with plain-text content passed as the first parameter.
    #   modal 'Your profile was updated!', context: :info, title: 'Profile'
    # @example A panel with HTML content passed as a block.
    #   modal context: :info, title: 'Profile' do
    #     content_tag :div, "Your profile was updated!", class: 'modal-footer'
    #   end
    #
    # @return [String] an HTML block tag for a panel.
    # @param [String] content_or_options_with_block the content to display in
    #   the panel.
    # @param [Hash] options the display options for the panel.
    # @option options [#to_s] :title ('Modal') the title to display inside the modal.
    # @option options [#to_s] :body if present, the panel will include the
    #   provided text wrapped in a 'modal-body' block, for proper padding
    # @option options [#to_s] :size the size of the modal.
    # @option options [Hash] :button the options for the "toggle" button.
    #   * :caption (#to_s) ('Modal') the caption for the "toggle" button.
    #   * :context (#to_s) (:default) the context for the "toggle" button,
    #     which determines the button color
    #   * :size (#to_s) the size of the "toggle" button.
    # @see http://getbootstrap.com/javascript/#modals
    def modal(content_or_options_with_block = nil, options = nil, &block)
      if block_given?
        modal_string content_or_options_with_block, &block
      elsif content_or_options_with_block.is_a?(Hash) && options.nil?
        modal_string content_or_options_with_block, &Proc.new { nil }
      else
        modal_string options, &Proc.new { content_or_options_with_block }
      end
    end

  private

    def modal_string(options = nil, &block)
      options ||= {}
      options[:id] ||= "modal-#{rand 10**10}"
      options[:title] ||= 'Modal'
      options[:body] = modal_body options[:body]
      options[:dialog_class] ||= dialog_class options[:size]
      options[:button] ||= {}
      options[:button][:caption] ||= options[:title]
      options[:button][:class] ||= button_class options[:button]
      render layout: 'bh/modal', locals: options, &block
    end

    def button_class(options = {})
      [
        class_for_context('btn', options[:context]),
        class_for_size('btn',    options[:size])
      ].compact.join ' '
    end

    def dialog_class(size = nil)
      ['modal-dialog', class_for_size('modal', size)].compact.join ' '
    end

    def modal_body(body = nil)
      content_tag :div, body, class: 'modal-body' if body
    end
  end
end