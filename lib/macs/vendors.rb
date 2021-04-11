module Macs
  module Vendors
    def self.all
      result = {}

      rows do |row|
        vendor = ::Macs::Vendor.new(name: row.last)
        result[vendor.name] ||= vendor
        result[vendor.name].add_prefix row.first
      end

      result.values.select(&:popular?).sort
    end

    # See https://mac2vendor.com/articles/download
    def self.rows
      URI.open('https://mac2vendor.com/download/vendorMacs.prop') do |file|
        CSV.foreach(file, liberal_parsing: true, col_sep: '=') do |row|
          yield row
        end
      end
    end
    private_class_method :rows
  end
end
