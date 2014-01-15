module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    FORM_HELPERS = %w{text_field password_field hidden_field file_field text_area color_field 
                      search_field telephone_field phone_field date_field time_field
                      datetime_field datetime_local_field month_field week_field url_field
                      email_field number_field range_field select collection_select date_select}

    delegate :content_tag, to: :@template

    def initialize(object_name, object, template, options, proc=nil)
      super
    end

    def alert_message(title = nil, *args)
      options = args.extract_options!
      alert_class = options[:class] || 'alert alert-danger'

      if object.respond_to?(:errors) && object.errors.full_messages.any?
        errors_count = object.errors.count
        title = "The form contains #{errors_count} errors" unless title
        content_tag :div, title, class: alert_class, id: 'errorExplanation'
      end
    end

    def submit(*args)
      options = args.extract_options!
      save_label = options[:button] ? options.delete(:button) : 'Save'
      submit_class = options[:class] || 'primary'
      back_link = options.delete(:back_link)

      submit = super(save_label, *args << { class: submit_class })

      content_tag(:div, class: 'form-group') do
        content_tag(:div, class: 'col-sm-offset-1 col-sm-11') do
          generate_submit(submit, back_link: back_link)
        end
      end
    end

    def self.create_tagged_field(method_name)
      define_method(method_name) do |field, *args, &help_block|
        normalize_args!(method_name, args)
        options = args.extract_options!

        label = options.delete(:label)
        help = options.delete(:help)
        prepend = options.delete(:prepend)
        append = options.delete(:append)

        wrapper_class = 'form-group'
        wrapper_class << ' has-error' if has_error?(field)

        input = super(field, *args << options.merge({ class: 'form-control' }))

        content_tag(:div, class: wrapper_class) do
          generate_label(field, label: label) +
          generate_field(field, input, help: help, prepend: prepend, append: append)
        end
      end
    end

    FORM_HELPERS.each do |method_name|
      create_tagged_field(method_name)
    end

    private

    def normalize_args!(method_name, args)
      if method_name == "select"
        args << {} while args.length < 3
      elsif method_name == "collection_select"
        args << {} while args.length < 5
      elsif method_name =~ /_select/
        args << {} while args.length < 2
      end
    end

    def has_error?(field)
      !(object.errors[field].empty? || object.nil?)
    end

    def generate_label(field, options)
      custom_label = options[:label] || field.to_s.humanize

      content_tag('label',
                  custom_label,
                  for: "#{object_name}_#{field}",
                  class: 'col-sm-1 control-label')
    end

    def generate_field(field, input, options)
      content_tag(:div, class: 'col-sm-11') do
        prepend_and_append_input(input, options[:prepend], options[:append]) +
        generate_help_or_error(field, options[:help])
      end
    end

    def generate_submit(submit, options)
      submit << content_tag(:a, 'Back', href: options[:back_link], class: 'default') if options[:back_link]
      submit
    end

    def prepend_and_append_input(input, prepend, append)
      input = content_tag(:span, prepend, class: 'input-group-addon') + input if prepend
      input << content_tag(:span, append, class: 'input-group-addon') if append
      input = content_tag(:div, input, class: 'input-group') if prepend || append
      input
    end

    def generate_help_or_error(field, help_or_error_text)
      help_or_error_text = object.errors[field].join(', ') if has_error?(field)
      content_tag(:span, help_or_error_text, class: 'help-block') if help_or_error_text
    end

  end
end
