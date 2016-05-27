require_relative "spec_helper"

describe SysInfo do
  context '#collect' do
    it 'calls ProcessList' do
       expect(ProcessList).to receive(:collect)
       SysInfo.collect
    end

    it 'contains required keys' do
      expect(SysInfo.collect.keys).to eq(%i(disk_usage cpu_usage mem_usage processes))
    end
  end
end
