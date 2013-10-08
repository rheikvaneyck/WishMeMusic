module ValidStringHelper
	class ::String
		# extends the String class to scan the string and return only substrings
		# valid for specific purposes (:name, :email, :tel)
		def validate_purpose(purpose)
			case purpose
			when :name
				# in a western european context
				regexp = %r{[\p{Word}]+[\p{Word}\p{Blank}\'-\/+]+[\p{Word}]+}
				self.scan(regexp).join(" ")
			when :email
				# look at http://www.regular-expressions.info/email.html
				regexp = %r{[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?}
				self.scan(regexp).join("")
			when :tel
				# scans for valid phone numbers including mobile and international numbers
				# regexp = %r{((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}}
				# My solution:
				# regexp = %r{(?:(?:\+|00)?\d{1,3}(?:-| )?)?\(?\d+\)?(?:(?:-| )?\d+)+}
				regexp = %r{(?:(?:\+|00)?\d{1,3}[\/\p{Blank}-]?)?\(?\d+\)?(?:[\/\p{Blank}-]?\d+)+}
				self.scan(regexp).join("")
			else
				false
			end
		end
	end
end