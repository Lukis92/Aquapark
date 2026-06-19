# Migrates existing Paperclip profile images from S3 to ActiveStorage.
#
# Paperclip stored files at:
#   s3://<bucket>/<class>/<attachment>/<id_partition>/<style>/<filename>
# Example:
#   people/profile_images/000/000/001/original/photo.jpg
#
# Usage (run once after deploying the ActiveStorage migration):
#   bundle exec rails paperclip:migrate_to_activestorage
#
# Prerequisites:
#   - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_BUCKET_NAME, AWS_REGION set
#   - ActiveStorage tables exist (db:migrate already ran)
#   - Gems: aws-sdk-s3, image_processing installed
#
# The task is idempotent: it skips persons who already have an ActiveStorage
# profile_image attached.
namespace :paperclip do
  desc 'Migrate Person profile_image attachments from Paperclip S3 to ActiveStorage'
  task migrate_to_activestorage: :environment do
    require 'open-uri'

    s3 = Aws::S3::Resource.new(
      region: ENV.fetch('AWS_REGION', 'us-east-1'),
      credentials: Aws::Credentials.new(
        ENV.fetch('AWS_ACCESS_KEY_ID'),
        ENV.fetch('AWS_SECRET_ACCESS_KEY')
      )
    )
    bucket_name = ENV.fetch('AWS_BUCKET_NAME')

    migrated = 0
    skipped  = 0
    failed   = 0

    Person.find_each do |person|
      if person.profile_image.attached?
        skipped += 1
        next
      end

      # Paperclip columns still present on the table during migration window.
      filename = person.read_attribute(:profile_image_file_name)
      next if filename.blank?

      id_partition = format('%09d', person.id).scan(/\d{3}/).join('/')
      s3_key = "people/profile_images/#{id_partition}/original/#{filename}"

      begin
        obj = s3.bucket(bucket_name).object(s3_key)
        raise "S3 object not found: #{s3_key}" unless obj.exists?

        content_type = person.read_attribute(:profile_image_content_type).presence ||
                       Marcel::MimeType.for(extension: File.extname(filename))

        obj.get.body.tap do |body|
          person.profile_image.attach(
            io: body,
            filename: filename,
            content_type: content_type
          )
        end

        migrated += 1
        print '.'
      rescue => e
        failed += 1
        puts "\n[FAILED] Person #{person.id}: #{e.message}"
      end
    end

    puts "\n\nDone. Migrated: #{migrated}, Skipped (already attached): #{skipped}, Failed: #{failed}"
  end
end
