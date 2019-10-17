class ApplicationMailer < ActionMailer::Base
	default(
	  from: "'Cowtribe' <peter@cowtribe.com>",
	  reply_to: 'peter@cowtribe.com'
	)
end
