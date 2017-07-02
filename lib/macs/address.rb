module Macs
  class Address
    def initialize(raw)
      @raw = raw
    end

    def to_s
      integer.to_s(16).to_s.rjust(6, '0')
    end

    def to_hex
      "0x#{to_s}"
    end

    def ignore?
      cidr?
    end

    def integer
      normalized.to_i(16)
    end

    private

    attr_reader :raw

    def normalized
      return sanitized unless cidr?
      positions = sanitized.split

    end

    def cidr?
      sanitized.include? '/'
    end

    def normalized
      sanitized[0..6]
    end

    def sanitized
      @sanitized ||= raw.to_s.downcase.delete '^[0-9a-f]/'
    end
  end
end
