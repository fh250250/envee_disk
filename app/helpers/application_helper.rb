module ApplicationHelper

  def flash_type(type)
    case type
    when "notice"  then "primary"
    when "success" then "success"
    when "error"   then "danger"
    else                "secondary"
    end
  end

end
