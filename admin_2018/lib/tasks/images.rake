namespace :images do
  task upload: :environment do
    if ENV['AWS_S3_BUCKET_NAME'].present?
      puts `aws s3 sync ./app/javascript/images/ s3://#{ENV['AWS_S3_BUCKET_NAME']}/image-assets --exclude="*.DS_Store" --acl=public-read --cache-control 'public, max-age=31536000'`
    else
      raise "AWS_S3_BUCKET_NAME env var not defined"
    end
  end
end
