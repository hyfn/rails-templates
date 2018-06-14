# TODO: document
# TODO: automatically specify params.require(:singular)
# TODO: overridable redirect target (same page vs. index)
module SimpleCrud
  extend ActiveSupport::Concern

  def index
    instance_variable_set "@#{plural}", find_all
  end

  def new
    instance_variable_set "@#{singular}", self.class.resource_class.new
  end

  def show
    instance_variable_set "@#{singular}", find_one
  end

  def edit
    instance_variable_set "@#{singular}", find_one
  end

  def create
    create! do
      redirect_to({ action: :index }, notice: "#{humanized} created successfully")
    end
  end

  def update
    update! do
      redirect_to({ action: :index }, notice: "#{humanized} updated successfully")
    end
  end

  def destroy
    destroy! do
      redirect_to({ action: :index }, notice: "#{humanized} removed successfully")
    end
  end

  def enable
    enable! do
      redirect_to({ action: :index }, notice: "#{humanized} enabled")
    end
  end

  def disable
    disable! do
      redirect_to({ action: :index }, notice: "#{humanized} disabled")
    end
  end

  def destroy!
    resource = find_one
    resource.destroy
    yield resource
  end

  def create!
    resource = self.class.resource_class.new(permitted_params)
    instance_variable_set "@#{singular}", resource
    if resource.save
      yield resource
    else
      render :new
    end
  end

  def update!
    resource = find_one
    instance_variable_set "@#{singular}", resource
    if resource.update_attributes(permitted_params)
      yield resource
    else
      render :edit
    end
  end

  def enable!
    resource = find_one
    resource.update!(enabled: true)
    yield resource
  end

  def disable!
    resource = find_one
    resource.update!(enabled: false)
    yield resource
  end

  protected

  def find_one
    self.class.resource_class.find(params[:id])
  end

  def find_all
    self.class.resource_class.all
  end

  private

  def singular
    self.class.singular_resource_name
  end

  def plural
    self.class.plural_resource_name
  end

  def humanized
    self.class.human_resource_name
  end

  module ClassMethods
    def set_resource_class(klass)
      @resource_class = klass
    end

    def resource_class
      @resource_class ||= Object.const_get(name.gsub(/Controller$/, '').demodulize.classify)
    end

    def set_singular_resource_name(name)
      @singular_resource_name = name
    end

    def singular_resource_name
      return @singular_resource_name if @singular_resource_name
      @singular_resource_name = resource_class.name.underscore
    end

    def set_plural_resource_name(name)
      @plural_resource_name = name
    end

    def plural_resource_name
      @plural_resource_name ||= ActiveSupport::Inflector.pluralize(singular_resource_name)
    end

    def human_resource_name
      singular_resource_name.humanize.titlecase
    end
  end
end
