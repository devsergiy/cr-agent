require 'pp'
require 'sys/proctable'
include Sys

module ProcessList
  FIELDS = %i(pid name vsize pctcpu pctmem).freeze
  FIELDS_MAP = {
    vsize:   :virtual_memory,
    pctcpu:  :cpu_use_percentage,
    pctmem:  :mem_use_percentage,
  }.freeze

  def self.collect
    ProcTable.ps.map do |process|
      process.to_h.select do |key, value|
        FIELDS.include?(key)
      end.tap do |p|
        FIELDS_MAP.each_pair do |old_name, new_name|
          p[new_name] = p.delete(old_name)
        end
      end
    end
  end
end
