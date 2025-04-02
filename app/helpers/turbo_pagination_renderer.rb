class TurboPaginationRenderer < WillPaginate::ActionView::LinkRenderer
  def container_attributes
    super.except(:class).merge(class: "pagination pagination-sm")
  end

  protected

  def link(text, target, attributes = {})
    attributes["data-turbo-frame"] = "_self"
    super
  end
end
