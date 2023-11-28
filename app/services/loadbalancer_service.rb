class LoadbalancerService
  class << self
    def call
      servers_list = fetch_servers
      next_server_url(servers_list)
    end

    private

    def fetch_servers
      Rails.cache.fetch('servers_list') do
        Server.pluck(:name, :url).to_h
      end
    end

    def server_names(servers_list)
      Rails.cache.fetch('server_names') { servers_list.keys }
    end

    def server_count(servers_list)
      server_names(servers_list).length
    end

    def next_server_index
      Rails.cache.fetch('next_server_index') { 0 }
    end

    def update_server_index(value)
      Rails.cache.write('next_server_index', value)
    end

    def next_server_url(servers_list)
      n_index = next_server_index
      s_names = server_names(servers_list)
      server_name = s_names[n_index]

      n_index = (n_index + 1) % server_count(servers_list)
      update_server_index(n_index)
      servers_list[server_name]
    end
  end
end