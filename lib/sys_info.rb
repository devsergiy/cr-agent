module SysInfo
  def self.collect
    {
      disk_usage: disk_usage,
      cpu_usage:  cpu_usage,
      mem_usage:  mem_usage,
      processes:  ProcessList.collect
    }
  end

  protected

  def self.cpu_usage
    %x{TERM=vt100 top -b -n 1}.lines.find{ |line| /Cpu\(s\):/.match(line) }.split[1]
  end

  def self.disk_usage
    %x{df --total}.split[-2].to_f
  end

  def self.mem_usage
    total, used = %x{ free }.lines[1].split[1, 2]
    (used.to_f / total.to_f * 100).round(2)
  end
end
