class Contact < MailForm::Base
  attribute :first_name,      validate: true
  attribute :last_name,       validate: true
  attribute :subject,         validate: true
  attribute :email,           validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :content,         validate: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: 'Pure Space | Kontakt',
      to: 'kontakt.purespace@gmail.com',
      from: %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end
