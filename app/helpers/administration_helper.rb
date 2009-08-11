module AdministrationHelper
  def bulk_options(path)
    options = []
    form_tag(path, :action => "bulk_action") do
      if current_user.role.can_publish?
        options << '<option value="publish" class="publish">Publish</option>'
        options << '<option value="unpublish" class="unpublish">Unpublish</option>'
      end
      if current_user.role.can_delete?
        options << '<option value="delete" class="delete">Delete</option>'
      end
      
      unless options.empty?
        actions = '<label for="actions">Bulk actions:</label> <select name="actions">' + options.to_s + '</select>'
        concat(actions + " " + submit_tag("Do action"))
      end
      
      actions_available = !options.empty?
      
      yield(actions_available)
    end
  end
end
