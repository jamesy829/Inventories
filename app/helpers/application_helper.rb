module ApplicationHelper
  # Globally display 10 items per page
  WillPaginate.per_page = CONFIG[:will_paginate]['per_page']

  BOOTSTRAP_FIELD_ERROR_PROC = Proc.new do |html_tag, instance|
    html_tag
  end

  def form_for(object, *args, &block)
    options = args.extract_options!
    options.merge!(html: { class: 'form-horizontal', role: 'form' })
    options.merge!(builder: Bootstrap::FormBuilder)

    with_bootstrap_form_field_error_proc do
      super(object, *(args << options), &block)
    end 
  end

  # Always use the Twitter Bootstrap pagination renderer
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge renderer: BootstrapPagination::Rails
    end

    options[:class] = 'pager' unless options[:class]

    super *[collection_or_options, options].compact
  end

private

  def with_bootstrap_form_field_error_proc
    default_field_error_proc = ::ActionView::Base.field_error_proc
    begin
      ::ActionView::Base.field_error_proc = BOOTSTRAP_FIELD_ERROR_PROC
      yield
    ensure
      ::ActionView::Base.field_error_proc = default_field_error_proc
    end
  end
end
