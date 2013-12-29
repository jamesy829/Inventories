class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def submit(*args)
    options = args.extract_options!
    save_label = options[:button] ? options[:button] : 'Save'

    @template.content_tag(:div, class: 'form-group') do
      @template.content_tag(:div, class: 'col-sm-offset-1 col-sm-11') do
        super(save_label, *args << options.merge({ class: 'primary' })) +
        @template.content_tag(:a,
                              'Back',
                              href: options[:back_link],
                              class: 'default')
      end
    end
  end

  def get_error_text(object, field, options)
    if object.nil? || options[:hide_errors]
      ''
    else
      errors = object.errors[field]
      errors.empty? ? '' : errors.first
    end
  end

  def self.create_tagged_field(method_name)
    define_method(method_name) do |field, *args, &help_block|
      options = args.extract_options!
      object = @template.instance_variable_get("@#{@object_name}")

      errorText = get_error_text(object, field, options)
      customLabel = options[:label] || field.to_s.humanize

      wrapperClass = 'form-group' + (errorText.empty? ? '' : ' has-error')
      errorSpan = errorText.empty? ? '' : "<span class='help-block'>#{errorText}</span>"

      @template.content_tag(:div, class: wrapperClass) do
        @template.content_tag('label',
                              customLabel,
                              for: "#{@object_name}_#{field}",
                              class: 'col-sm-1 control-label') +
        @template.content_tag(:div, class: 'col-sm-11') do
                              super(field, *args << options.merge({ class: 'form-control' })) +
                              errorSpan.html_safe
        end
      end
    end
  end

  field_helpers.each do |name|
    create_tagged_field(name)
  end

end
