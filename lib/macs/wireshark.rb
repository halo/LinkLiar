module Macs
  class Wireshark
    def popular_vendors
      vendors.values.select(&:popular?).sort_by(&:count).reverse
    end

    def vendors
      vendors = {}
      entries.each do |entry|
        vendors[entry.name.to_s] ||= Vendor.new(entry.name)
        vendors[entry.name.to_s].add entry.address
      end
      vendors
    end

    def entries
      result = []
      entries! do |entry|
        result << entry
      end
      result
    end

    def rows(&block)
      URI.open(url) do |file|
        file.readlines.each(&block)
      end
    end

    def url
      'https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=manuf;hb=HEAD'
      # Development only
      # '~/Desktop/manuf.txt'
    end

    private

    def entries!
      rows do |row|
        entry = Entry.new(row)
        yield entry unless entry.ignore?
      end
    end
  end
end
