```ruby
require 'bigdecimal'

class Lattice
  attr_reader :vectors, :inverse, :det

  def initialize(vectors, inverse, det)
    @vectors = vectors
    @inverse = inverse
    @det = det
  end

  def decompose(k)
    n = @inverse.length
    c = Array.new(n)

    # Calculate closest vector in lattice to <k,0,0,...> with Babai's rounding.
    (0...n).each do |i|
      c[i] = k * @inverse[i]
      round(c[i], @det)
    end

    # Transform vectors according to c and subtract <k,0,0,...>.
    out = Array.new(n)
    temp = BigDecimal(0)

    (0...n).each do |i|
      out[i] = BigDecimal(0)

      (0...n).each do |j|
        temp = c[j] * @vectors[j][i]
        out[i] += temp
      end

      out[i] = -out[i] + 2 * @vectors[0][i] + k
    end

    out[0] += k

    out
  end

  def precompute(&add)
    n = @vectors.length
    total = 1 << n

    (0...n).each do |i|
      (0...total).each do |j|
        add.call(i, j) if (j >> i) & 1 == 1
      end
    end
  end

  def multi(scalar)
    decomp = decompose(scalar)

    max_len = 0
    decomp.each do |x|
      max_len = x.to_s(2).length if x.to_s(2).length > max_len
    end

    out = Array.new(max_len, 0)
    decomp.each_with_index do |x, j|
      x.to_s(2).chars.each_with_index do |bit, i|
        out[i] += bit.to_i * (1 << j)
      end
    end

    out
  end

  private

  def round(num, denom)
    r = BigDecimal(num.to_s) % BigDecimal(denom.to_s)
    num += 1 if r > 0.5
  end
end

curve_lattice_vectors = [
  [BigDecimal('147946756881789319000765030803803410728'), BigDecimal('147946756881789319010696353538189108491')],
  [BigDecimal('147946756881789319020627676272574806254'), BigDecimal('-147946756881789318990833708069417712965')]
]
curve_inverse = [
  BigDecimal('147946756881789318990833708069417712965'),
  BigDecimal('147946756881789319010696353538189108491')
]
curve_det = BigDecimal('43776485743678550444492811490514550177096728800832068687396408373151616991234')

curve_lattice = Lattice.new(curve_lattice_vectors, curve_inverse, curve_det)

target_lattice_vectors = [
  [BigDecimal('9931322734385697761'), BigDecimal('9931322734385697761'), BigDecimal('9931322734385697763'), BigDecimal('9931322734385697764')],
  [BigDecimal('4965661367192848881'), BigDecimal('4965661367192848881'), BigDecimal('4965661367192848882'), BigDecimal('-9931322734385697762')],
  [BigDecimal('-9931322734385697762'), BigDecimal('-4965661367192848881'), BigDecimal('4965661367192848881'), BigDecimal('-4965661367192848882')],
  [BigDecimal('9931322734385697763'), BigDecimal('-4965661367192848881'), BigDecimal('-4965661367192848881'), BigDecimal('-4965661367192848881')]
]
target_inverse = [
  BigDecimal('734653495049373973658254490726798021314063399421879442165'),
  BigDecimal('147946756881789319000765030803803410728'),
  BigDecimal('-147946756881789319005730692170996259609'),
  BigDecimal('1469306990098747947464455738335385361643788813749140841702')
]
target_det = curve_det

target_lattice = Lattice.new(target_lattice_vectors, target_inverse, target_det)
```
This Ruby code defines classes and methods to work with lattices, decompose scalars, and perform lattice multiplications.A