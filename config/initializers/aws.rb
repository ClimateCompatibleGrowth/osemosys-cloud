Aws.config.update(
  credentials: Aws::Credentials.new(
    Rails.application.credentials.dig(:aws, :osemosys_access_key_id),
    Rails.application.credentials.dig(:aws, :osemosys_secret_access_key),
  ),
)
