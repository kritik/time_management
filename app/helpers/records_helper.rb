module RecordsHelper
  def return_param name = nil
    return "" if name.nil?
    if params[:record].nil?
      return 0;
    else
      return params[:record][name]
    end
  end
end
