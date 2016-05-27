require_relative "spec_helper"

describe ProcessList do
  context '#collect' do
    subject { ProcessList.collect.first }

    before do
      allow(ProcTable).to receive(:ps).and_return([
        OpenStruct.new({
          :cmdline => "/sbin/init", :cwd => nil, :environ => {}, :exe => nil,
          :fd => {}, :root => nil, :pid => 1, :comm => "init", :state => "S",
          :ppid => 0, :pgrp => 1, :session => 1, :tty_nr => 0, :tpgid => -1,
          :flags => 4219136, :minflt => 83042, :cminflt => 3055328, :majflt => 40,
          :cmajflt => 4936, :utime => 100, :stime => 126, :cutime => 25520,
          :cstime => 14256, :priority => 20, :nice => 0, :itrealvalue => 0,
          :starttime => 3, :vsize => 34865152, :rss => 761, :rlim => 18446744073709551615,
          :startcode => 1, :endcode => 1, :startstack => 0, :kstkesp => 0,
          :kstkeip => 0, :signal => 0, :blocked => 0, :sigignore => 4096,
          :sigcatch => 536962595, :wchan => 0, :nswap => 0, :cnswap => 0,
          :exit_signal => 17, :processor => 6, :rt_priority => 0, :policy => 0,
          :name => "init", :uid => 0, :euid => 0, :gid => 0,
          :egid => 0, :pctcpu => 0.0, :pctmem => 0.04, :nlwp => 1,
        })
      ])
    end

    it 'filters keys' do
      expect(subject.keys).to eq(%i(pid name virtual_memory cpu_usage mem_usage))
    end

    it 'renames keys' do
      expect(subject.keys).not_to include(%i(vsize pctcpu pctmem))
    end
  end
end
