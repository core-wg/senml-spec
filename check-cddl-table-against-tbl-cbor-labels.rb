require 'pp'

MAPPINGS = Hash.new {|h, k| k}

File.read("senml-cbor.cddl").scan(/([-\w]+)\s*=\s*([-\w]+)/) do |n, v|
  begin
    MAPPINGS[n] = Integer(v)
  rescue ArgumentError
  end
end

pp MAPPINGS

texttable =  Hash[File.read("draft-ietf-core-senml.md").lines("").grep(/#tbl-cbor-labels/).first.
                    lines[1..-3].map{|x|
                    x.chomp.scan(/\|\s*([^|\s]+)/)[1..-1].map{|y|
                      Integer(y.first) rescue y.first
                    }
                  }]

pp texttable

raise unless texttable == MAPPINGS
