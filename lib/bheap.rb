class BHeap
  def initialize(cmp = lambda {|x, y| x <=> y})
    @a = Array.new
    @cmp = cmp
  end

  def empty?
    @a.empty?
  end

  def push(v)
    @a.push v
    c = @a.length - 1
    while (c > 0) do
      p = (c - 1) / 2
      break if (@cmp.call(@a[p],  v) == 1)
      @a[c] = @a[p]
      c = p
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
    while ((2 * p + 1) < @a.length) do
      c = 2 * p + 1
      c += 1 if ((c + 1) < @a.length) && (@cmp.call(@a[c], @a[c + 1]) == -1)
      break if (@cmp.call(v, @a[c]) == 1)
      @a[p] = @a[c]
      p = c
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
