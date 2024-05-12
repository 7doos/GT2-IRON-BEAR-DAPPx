```ruby
require 'bigdecimal'

# gfP represents an element of GF(p).
class GfP
  attr_accessor :x

  def initialize(x)
    @x = x
  end

  def to_s
    @x.to_s
  end

  def ==(other)
    @x == other.x
  end

  def zero?
    @x.zero?
  end

  def one?
    @x == 1
  end

  def square
    self.class.new(@x * @x)
  end

  def neg
    self.class.new(-@x)
  end

  def add(other)
    self.class.new(@x + other.x)
  end

  def sub(other)
    self.class.new(@x - other.x)
  end

  def mul(other)
    self.class.new(@x * other.x)
  end

  def inv
    self.class.new(@x.inv)
  end
end

# gfP2 represents an element of GF(p²).
class GfP2
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def zero?
    @x.zero? && @y.zero?
  end

  def one?
    @x.one? && @y.zero?
  end

  def square
    self.class.new(@x.square, @y.square)
  end

  def neg
    self.class.new(@x.neg, @y.neg)
  end

  def add(other)
    self.class.new(@x.add(other.x), @y.add(other.y))
  end

  def sub(other)
    self.class.new(@x.sub(other.x), @y.sub(other.y))
  end

  def mul(other)
    a = @x
    b = @y
    c = other.x
    d = other.y
    ac = a.mul(c)
    bd = b.mul(d)
    ad_plus_bc = (a.add(b)).mul(c.add(d)).sub(ac).sub(bd)
    xy = ac.add(bd.mul(GfP.new(3)))
    self.class.new(ad_plus_bc, xy)
  end

  def inv
    a = @x
    b = @y
    inv_denom = (a.square).sub(b.square.mul(GfP.new(3))).inv
    self.class.new(a.mul(inv_denom), b.neg.mul(inv_denom))
  end
end

# twistPoint implements the elliptic curve y²=x³+3/ξ over GF(p²).
class TwistPoint
  attr_accessor :x, :y, :z, :t

  def initialize(x, y, z, t)
    @x = x
    @y = y
    @z = z
    @t = t
  end

  def to_s
    make_affine
    "(#{@x}, #{@y})"
  end

  def set(a)
    @x = a.x
    @y = a.y
    @z = a.z
    @t = a.t
  end

  def infinity?
    @z.zero?
  end

  def set_infinity
    @x = GfP2.new(GfP.new(0), GfP.new(1))
    @y = GfP2.new(GfP.new(1), GfP.new(0))
    @z = GfP2.new(GfP.new(0), GfP.new(0))
    @t = GfP2.new(GfP.new(0), GfP.new(0))
  end

  def make_affine
    return if @z.one? || @z.zero?

    z_inv = @z.inv
    t = @y.mul(z_inv)
    @y = t.mul(z_inv.square)
    t = @x.mul(z_inv.square)
    @x = t
    @z = GfP2.new(GfP.new(1), GfP.new(0))
    @t = GfP2.new(GfP.new(1), GfP.new(0))
  end

  def add(a, b)
    if a.infinity?
      set(b)
      return
    elsif b.infinity?
      set(a)
      return
    end

    z1 = a.z.square
    z2 = b.z.square
    u1 = a.x.mul(z2)
    u2 = b.x.mul(z1)
    s1 = a.y.mul(b.z.mul(z2))
    s2 = b.y.mul(a.z.mul(z1))
    h = u2.sub(u1)
    x_equal = h.zero?
    t = h.add(h)
    i = t.square
    j = h.mul(i)
    t = s2.sub(s1)
    y_equal = t.zero?

    if x_equal && y_equal
      double(a)
      return
    end

    r = t.add(t)
    v = u1.mul(i)
    t = h.add(h)
    t2 = t.square
    t = t2.add(t2)
    t = t.add(t)
    t = t.add(t)
    x3 = j.sub(r)
    t2 = v.sub(x3)
    t = t.mul(t)
    t = t.sub(t2)
    c.x = x3
    t2 = v.sub(c.x)
    t2 = t2.mul(r)
    y3 = s1.mul(j)
    t2 = t2.sub(y3)
    t = t.mul(h)
    y3 = t2.sub(t)
    c.y = y3
    t = a.z.add(b.z)
    t2 = t.square
    t = t2.sub(z1)
    t2 = t.sub(z2)
    c.z = t.mul(h)
  end

  def double(a)
    a2 = a.x.square
    b2 = a.y.square
    c2 = b2.square
    b2_plus_b2 = b2.add(b2)
    d = a.x.add(b2_plus_b2)
    d2 = d.square
    d2 = d2.sub(a2)
    d2 = d2.sub(c2)
    t = a2.add(a2)
    t = t.add(t)
    e = a.x.add(a)
    f = e.square
    f = f.sub(a2)
    f = f.sub(a2)
    f = f.sub(a2)
    f = f.sub(c2)
    x3 = f.sub(d2)
    t2 = b2_plus_b2.add(a)
    t2 = t2.square
    t2 = t2.sub(b2)
    t2 = t2.sub(b2)
    t2 = t2.sub(b2)
    t2 = t2.sub(b2)
    t2 = t2.sub(b2)
    y3 = e.mul(d2.sub(x3))
    t = a.y.add(a.z)
    t = t.square
    t = t.sub