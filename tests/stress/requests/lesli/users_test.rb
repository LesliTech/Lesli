require 'ruby-jmeter'
require 'json'

test do
    threads count: 1, loops: 1 do
        user_defined_variables [{name: 'email', value: 'dev@lesli.cloud'}, {name: 'password', value: 'lesli2020'}]

        visit name: 'Lesli', url: 'https://intern.deutsche-leibrenten.de'
        # auth url: '/login', email: 'dev@lesli.cloud', password: 'lesli2020', domain: 'https://intern.deutsche-leibrenten.de'
        
        visit name: 'Login page', url: 'https://intern.deutsche-leibrenten.de/login' do
            extract name: 'csrf-token', xpath: "//meta[@name='csrf-token']/@content", tolerant: true
            extract name: 'csrf-param', xpath: "//meta[@name='csrf-param']/@content", tolerant: true
            # extract name: 'authenticity_token', regex: 'name="authenticity_token" value="(.+?)"'
        end
        
        http_header_manager name: 'X-CSRF-Token', value: '${csrf-token}'
        
        submit name: 'Login', url: 'https://intern.deutsche-leibrenten.de/login',
        fill_in: {
            '${csrf-param}' => '${csrf-token}',
            'user[email]' => '${email}',
            'user[password]' => '${password}',
            # 'authenticity_token' => '${authenticity_token}',
        }

        # visit name: 'Dashboard', url: 'https://intern.deutsche-leibrenten.de/crm'
    end
end.run(
    file: "tests/stress/test_plan/lesli/users_test.jmx",
    log: 'tests/stress/logs/lesli/users_test.log',
    jtl: 'tests/stress/results/lesli/users_test.jtl',
)
