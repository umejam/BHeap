# -*- encoding: euc-jp -*-
require 'rubygems'
require 'rushcheck'
require 'ext/bheap'

def for_all(*cs, &f)
  RushCheck::Claim.new(*cs, &f).check.should == true
end

class MRArray < RandomArray;end

def for_all_ary(cs, &f)
  MRArray.set_pattern(cs){|a,i| cs}
  RushCheck::Assertion.new(MRArray) do | ary |
    RushCheck::guard {ary.length > 0}
    yield ary
  end.check.should == true
end

describe BHeap, "��new������" do
  before do
    @empty_heap = BHeap.new
  end

  it "�ϡ�empty?��true���֤��٤�" do
    @empty_heap.empty?.should be_true
  end

  it "�ϡ�pop��nil���֤��٤�" do
    @empty_heap.pop.should be_nil
  end

  it "�ϡ�top��nil���֤��٤�" do
    @empty_heap.top.should be_nil
  end
end

describe BHeap, "��push������" do
  it "�ϡ�BHeap���Ȥ��֤��٤�" do
    for_all(Integer) do |i|
      heap = BHeap.new
      heap.push(i).should == heap
    end
  end

  it "�ϡ�empty?��false���֤��٤�" do
    for_all(Integer) do |i|
      heap = BHeap.new
      heap.push i
      heap.empty?.should be_false
    end
  end

  it "�ϡ�top�Ͼ�˺Ǥ��礭����Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new
      max = ary.sort.first
      ary.each do |i|
        max = i if i > max
        heap.push i
        heap.top.should == max
      end
      heap.top.should == max
    end

    for_all_ary(String) do |ary|
      heap = BHeap.new
      max = ary.sort.first
      ary.each do |i|
        max = i if i > max
        heap.push i
        heap.top.should == max
      end
      heap.top.should == max
    end
  end
end

describe BHeap, "�򡢾���ǥ����Ȥ���褦��new���Ƥ���push�������" do
  it "�ϡ�top�Ͼ�˺Ǥ⾮������Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new(lambda {|x, y| y <=> x})
      min = ary.sort.last
      ary.each do |n|
        min = n if n < min
        heap.push n
        heap.top.should == min
      end
      heap.top.should == min
    end

    for_all_ary(String) do |ary|
      heap = BHeap.new(lambda {|x, y| y <=> x})
      min = ary.sort.last
      ary.each do |n|
        min = n if n < min
        heap.push n
        heap.top.should == min
      end
      heap.top.should == min
    end
  end
end

describe BHeap, "����pop������" do
  it "�ϡ���˺Ǥ��礭����Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new
      ary.each do |n|
        heap.push n
      end
      ary.sort!
      until ary.empty? do
        heap.pop.should == ary.pop
      end
      heap.empty?.should be_true
    end

    for_all_ary(String) do |ary|
      heap = BHeap.new
      ary.each do |n|
        heap.push n
      end
      ary.sort!
      until ary.empty? do
        heap.pop.should == ary.pop
      end
      heap.empty?.should be_true
    end
  end
end

describe BHeap, "�򡢾���ǥ����Ȥ���褦��new���Ƥ���pop�������" do
  it "�ϡ���˺Ǥ⾮������Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new(lambda {|x, y| y <=> x})
      ary.each do |n|
        heap.push n
      end
      ary.sort!
      until ary.empty? do
        heap.pop.should == ary.shift
      end
      heap.empty?.should be_true
    end

    for_all_ary(String) do |ary|
      heap = BHeap.new(lambda {|x, y| y <=> x})
      ary.each do |n|
        heap.push n
      end
      ary.sort!
      until ary.empty? do
        heap.pop.should == ary.shift
      end
      heap.empty?.should be_true
    end
  end
end

describe BHeap, "����pop������" do
  it "�ϡ�top�Ͼ��2���ܤ��礭����Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new
      ary.each do |n|
        heap.push n
      end
      ary.sort! {|x, y| y <=> x}
      (ary.length - 1).times do |i|
        heap.pop
        heap.top.should == ary[i + 1]
      end
      heap.top.should == ary.last
    end
  end
end

describe BHeap, "�򡢾���ǥ����Ȥ���褦��new���Ƥ���pop������" do
  it "�ϡ�top�Ͼ��2���ܤ˾�������Τ��֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new(lambda {|x, y| y <=> x})
      ary.each do |n|
        heap.push n
      end
      ary.sort!
      (ary.length - 1).times do |i|
        heap.pop
        heap.top.should == ary[i + 1]
      end
      heap.top.should == ary.last
    end
  end
end

describe BHeap, "�������Ƥ����Ǥ�pop������" do
  it "�ϡ�empty?��true���֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new
      ary.each do |n|
        heap.push n
      end
      ary.length.times do
        heap.pop
      end
      heap.empty?.should be_true
    end
  end

  it "�ϡ�pop��nil���֤��٤�" do
    for_all_ary(Integer) do |ary|
      heap = BHeap.new
      ary.each do |n|
        heap.push n
      end
      ary.length.times do
        heap.pop
      end
      heap.pop.should be_nil
    end
  end
end
