
context = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)


# cookbook root dir
directory cookbook_dir

template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
cookbook_file "#{cookbook_dir}/chefignore" do
  action :create_if_missing
end
cookbook_file "#{cookbook_dir}/Berksfile" do
  action :create_if_missing
end
template "#{cookbook_dir}/Policyfile.rb" do
  source "Policyfile.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
end
template "#{cookbook_dir}/.kitchen.yml" do
  source 'kitchen.yml.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
directory "#{cookbook_dir}/test/integration/default/serverspec" do
  recursive true
end
directory "#{cookbook_dir}/test/integration/helpers/serverspec" do
  recursive true
end
cookbook_file "#{cookbook_dir}/test/integration/helpers/serverspec/spec_helper.rb" do
  source 'serverspec_spec_helper.rb'
  action :create_if_missing
end
template "#{cookbook_dir}/test/integration/default/serverspec/default_spec.rb" do
  source 'serverspec_default_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
directory "#{cookbook_dir}/recipes" do
  recursive true
end
directory "#{cookbook_dir}/templates/default" do
  recursive true
end
template "#{cookbook_dir}/recipes/default.rb" do
  source "recipe.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
if context.have_git
  if !context.skip_git_init
    execute("initialize-git") do
      command("git init .")
      cwd cookbook_dir
    end
  end
  cookbook_file "#{cookbook_dir}/.gitignore" do
    source "gitignore"
  end
end
