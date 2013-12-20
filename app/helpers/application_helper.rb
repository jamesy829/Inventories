module ApplicationHelper
  BOOTSTRAP_FIELD_ERROR_PROC = Proc.new do |html_tag, instance|
    html_tag
  end

  def form_for(name, *args, &block)
    options = args.extract_options!
    options.merge!(html: { class: 'form-horizontal', role: 'form' })
    options.merge!(builder: BootstrapFormBuilder)

    with_bootstrap_form_field_error_proc do
      super(name, *(args << options), &block)
    end
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
