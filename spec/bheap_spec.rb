# -*- encoding: euc-jp -*-
require 'bheap'

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
  before do
    @heap = BHeap.new
  end

  it "�ϡ�BHeap���Ȥ��֤��٤�" do
    @heap.push(10).should == @heap
  end

  it "�ϡ�empty?��false���֤��٤�" do
    @heap.push 5
    @heap.empty?.should be_false
  end

  it "�ϡ�top�Ͼ�˺Ǥ��礭����Τ��֤��٤�" do
    max = 0
    10.times do
      n = rand(20)
      max = n if n > max
      @heap.push n
      @heap.top.should == max
    end
  end
end

describe BHeap, "����pop������" do
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

  it "�ϡ���˺Ǥ��礭����Τ��֤��٤�" do
    @heap.pop.should == @a[0]
    @heap.pop.should == @a[1]
  end
end

describe BHeap, "����pop������" do
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

  it "�ϡ�top�Ͼ��2���ܤ��礭����Τ��֤��٤�" do
    9.times do |i|
      @heap.pop
      @heap.top.should == @a[i + 1]
    end
  end
end

describe BHeap, "�������Ƥ����Ǥ�pop������" do
  before do
    @heap = BHeap.new
    10.times do
      @heap.push 0
    end
  end

  it "�ϡ�empty?��true���֤��٤�" do
    10.times do
      @heap.pop
    end
    @heap.empty?.should be_true
  end

  it "�ϡ�pop��nil���֤��٤�" do
    10.times do
      @heap.pop
    end
    @heap.pop.should be_nil
  end
end
