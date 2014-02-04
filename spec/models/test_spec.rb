require 'spec_helper'

ROUTES = Rails.application.routes.routes.map do |route|
  # Turn route path spec into string; use "1" for all params
  path = route.path.spec.to_s.gsub(/\(\.:format\)/, "").gsub(/:[a-zA-Z_]+/, ":id")
  verb = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first.downcase.to_sym
  { path: path, verb: verb }
end

urls_with_objects = []

ROUTES.each do |route|
  objects = []

  if route[:verb] == :get
    klass = route[:path].scan(/(\w*)\/:id/)

    if !klass.empty?
      factory_name = klass.last.first
      child_object = FactoryGirl.create(factory_name.to_sym)

      klass[0...-1].each do |name, index|
        objects << child_object.send(name.singularize.to_sym)
      end

      objects << child_object
    end

    urls_with_objects << { url: route[:path], objects: objects }
  end
end

paths = []
urls_with_objects.each do |url|
  paths << url[:url].gsub(':id').each_with_index { |v, i| url[:objects][i].id }
end

describe 'an application' do
  paths.each do |path|
    context 'when navigating to url' do
      before(:each) { visit path }

      subject { page.status_code }

      it { should == 200 }
    end
  end
end