require 'bh/helpers/form/fieldset_helper'

module Bh
  module Form
    module FieldsForHelper
      include BaseHelper
      include FieldsetHelper # for fieldset

      def fields_for(record_name, record_object = nil, fields_options = {}, &block)
        if record_object.is_a?(Hash) && record_object.extractable_options?
          record_object, fields_options = nil, record_object
        end

        fields_options[:layout] ||= @options[:layout]
        fields_options[:errors] ||= @options[:errors]
        title = fields_options.delete(:title) { record_name.to_s.humanize }
        if fields_options[:no_panel]
          super record_name, record_object, fields_options, &block
        else
          fieldset(title) { super record_name, record_object, fields_options, &block }
        end
      end
    end
  end
end