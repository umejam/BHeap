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

describe BHeap, "をnewした時" do
  before do
    @empty_heap = BHeap.new
  end

  it "は、empty?はtrueを返すべき" do
    @empty_heap.empty?.should be_true
  end

  it "は、popはnilを返すべき" do
    @empty_heap.pop.should be_nil
  end

  it "は、topはnilを返すべき" do
    @empty_heap.top.should be_nil
  end
end

describe BHeap, "にpushした時" do
  it "は、BHeap自身を返すべき" do
    for_all(Integer) do |i|
      heap = BHeap.new
      heap.push(i).should == heap
    end
  end

  it "は、empty?はfalseを返すべき" do
    for_all(Integer) do |i|
      heap = BHeap.new
      heap.push i
      heap.empty?.should be_false
    end
  end

  it "は、topは常に最も大きいものを返すべき" do
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

describe BHeap, "を、昇順でソートするようにnewしてからpushした場合" do
  it "は、topは常に最も小さいものを返すべき" do
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

describe BHeap, "からpopした時" do
  it "は、常に最も大きいものを返すべき" do
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

describe BHeap, "を、昇順でソートするようにnewしてからpopした場合" do
  it "は、常に最も小さいものを返すべき" do
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

describe BHeap, "からpopした後" do
  it "は、topは常に2番目に大きいものを返すべき" do
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

describe BHeap, "を、昇順でソートするようにnewしてからpopした後" do
  it "は、topは常に2番目に小さいものを返すべき" do
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

describe BHeap, "から全ての要素をpopした後" do
  it "は、empty?はtrueを返すべき" do
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

  it "は、popはnilを返すべき" do
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
