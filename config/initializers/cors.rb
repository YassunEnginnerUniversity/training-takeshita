Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'

    resource '/api/v1/*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true # 追加
  end
end