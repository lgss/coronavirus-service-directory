Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV.fetch("AUTH0_CLIENT_ID"),
    ENV.fetch("AUTH0_CLIENT_SECRET"),
    ENV.fetch("AUTH0_CLIENT_URI"),
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      scope: 'openid email profile'
    }
  )
end