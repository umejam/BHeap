require 'bheap'

heap = BHeap.new

10000.times do
  n = rand(2000)
  heap.push n
end

10000.times do
  heap.pop
end
