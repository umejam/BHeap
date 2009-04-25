# -*- encoding: euc-jp -*-
require 'bheap'

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
  before do
    @heap = BHeap.new
  end

  it "は、BHeap自身を返すべき" do
    @heap.push(10).should == @heap
  end

  it "は、empty?はfalseを返すべき" do
    @heap.push 5
    @heap.empty?.should be_false
  end

  it "は、topは常に最も大きいものを返すべき" do
    max = 0
    10.times do
      n = rand(20)
      max = n if n > max
      @heap.push n
      @heap.top.should == max
    end
  end
end

describe BHeap, "からpopした時" do
  before do
    @heap = BHeap.new
    @a = Array.new
    10.times do
      n = rand(20)
      @a.push n
      @heap.push n
    end
    @a.sort! {|x, y| y <=> x}
  end

  it "は、常に最も大きいものを返すべき" do
    @heap.pop.should == @a[0]
    @heap.pop.should == @a[1]
  end
end

describe BHeap, "からpopした後" do
  before do
    @heap = BHeap.new
    @a = Array.new
    10.times do
      n = rand(100)
      @a.push n
      @heap.push n
    end
    @a.sort! {|x, y| y <=> x}
  end

  it "は、topは常に2番目に大きいものを返すべき" do
    9.times do |i|
      @heap.pop
      @heap.top.should == @a[i + 1]
    end
  end
end

describe BHeap, "から全ての要素をpopした後" do
  before do
    @heap = BHeap.new
    10.times do
      @heap.push 0
    end
  end

  it "は、empty?はtrueを返すべき" do
    10.times do
      @heap.pop
    end
    @heap.empty?.should be_true
  end

  it "は、popはnilを返すべき" do
    10.times do
      @heap.pop
    end
    @heap.pop.should be_nil
  end
end
