require 'ruby-jmeter'
require 'json'

test do
    threads count: 1, loops: 1 do
        visit name: 'Lesli', url: 'http://127.0.0.1:3000'
        visit name: 'Login Page', url: 'http://127.0.0.1:3000/login' do
            extract name: 'csrf-token', xpath: "//meta[@name='csrf-token']/@content", tolerant: true
            extract name: 'csrf-param', xpath: "//meta[@name='csrf-param']/@content", tolerant: true
        end

        # auth url: '/login', email: 'dev@lesli.cloud', password: 'lesli2020', domain: 'http://127.0.0.1:3000'
        # visit name: 'Dashboard', url: 'http://127.0.0.1:3000/crm'

        # user = { email: 'dev@lesli.cloud', password:'lesli2020' }
        # payload = {
        #     user: {
        #         email: 'dev@lesli.cloud',
        #         password:'lesli2020',
        #     },
        #     'csrf-token' => '${csrf-token}'
        # }

        header [
            # { name: 'Content-Type', value: 'application/json' },
            { name: 'X-CSRF-Token', value: '${csrf-token}' }
        ]
        # http_header_manager name: 'X-CSRF-Token', value: '${csrf-token}'
        submit name: 'Login', url: 'http://127.0.0.1:3000/login', fill_in: {
            '${csrf-param}' => '${csrf-token}',
            'user[email]' => 'dev@lesli.cloud',
            'user[password]' => 'lesli2020',
            # :user => {
            #     :email => 'dev@lesli.cloud',
            #     :password => 'lesli2020'
            # }
            # authorization: {
            #     user: {
            #         email: 'dev@lesli.cloud',
            #         password:'lesli2020',
            #     },
            # }
            # "user" => {
            #     "email"=>"dev@lesli.cloud",
            #     "password"=>"lesli2020"
            # }
        }
        # .to_json do
        #     with_xhr
        # end
        # visit name: 'Dashboard', url: 'http://127.0.0.1:3000/crm'

        # header [{ name: 'Content-Type', value: 'application/json' }]
        # post name: 'Login', url: "http://127.0.0.1:3000/login", raw_body: payload.to_json
        # visit name: 'Dashboard', url: 'http://127.0.0.1:3000/crm'
    end
end.run(
    file: "tests/stress/test_plan/lesli/users_test.jmx",
    log: 'tests/stress/logs/lesli/users_test.log',
    jtl: 'tests/stress/results/lesli/users_test.jtl',
)
