node[:deploy].each do |_app_name, deploy|
  execute 'migrate' do
    group deploy[:group]
    if platform?('ubuntu')
      user 'www-data'
    elsif platform?('amazon')
      user 'apache'
    end

    cwd "#{deploy[:deploy_to]}/current"
    command "#{deploy[:deploy_to]}/current/#{node[:symfony][:console]} doctrine:migrations:migrate --no-interaction --env=prod --allow-no-migration"
    only_if { File.exist?("#{deploy[:deploy_to]}/current/#{node[:symfony][:console]}") }
  end
end
