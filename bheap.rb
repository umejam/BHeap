class BHeap
  def initialize
    @a = Array.new
  end

  def empty?
    @a.empty?
  end

  def push(v)
    @a.push v
    c = @a.length - 1
    p = (c - 1) / 2
    while (c > 0) do
      break if (@a[p] >= v)
      @a[c] = @a[p]
      c = p
      p = (c - 1) / 2
    end
    @a[c] = v

    self
  end

  def pop
    return nil if @a.empty?

    v = @a.pop
    return v if @a.empty?

    r = @a[0]
    @a[0] = v
    p = 0
    c = 2 * p + 1
    while (c < @a.length) do
      c = c + 1 if ((c + 1) < @a.length) && (@a[c] < @a[c + 1])
      break if (v >= @a[c])
      @a[p] = @a[c]
      p = c
      c = 2 * p + 1
    end
    @a[p] = v
    r
  end

  def top
    if @a.empty?
      nil
    else
      @a[0] 
    end
  end
end
