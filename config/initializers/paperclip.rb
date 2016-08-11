require 'paperclip/railtie'
Paperclip::Railtie.insert
class Paperclip::Deprecations
  if Paperclip::VERSION < '5'
    def self.warn_aws_sdk_v1
    end
  end
end
