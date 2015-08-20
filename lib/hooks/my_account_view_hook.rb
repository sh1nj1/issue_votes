class MyAccountViewHook < Redmine::Hook::ViewListener
  render_on :view_users_form, :partial => 'form_voting_organization'
end
