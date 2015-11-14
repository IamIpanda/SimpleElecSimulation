require 'complex.rb'

class ElectricUnits
  def ElectricUnits.frequency=(value)
    @@frequency = value
  end
  @@frequency = 1000.0
  def value
    return 0
  end

  def G
    v = self.value
    return v.is_a?(Complex) ? Complex(1, 0) / v : 1.0 / v
  end

  def fs
    return 0
  end
end

class ElectricResistance < ElectricUnits
  attr_accessor :resistance
  def value
    return @resistance
  end
  def initialize(*args)
    @resistance = args[0].to_f
  end
end

class ElectricCapacity < ElectricUnits
  attr_accessor :capacity
  def value
    return - Complex::I / (@@frequency * @capacity)
  end
  def initialize(*args)
    @capacity = args[0].to_f
  end
end

class ElectricInductor < ElectricUnits
  attr_accessor :lenz
  def value
    return Complex::I * @lenz * @@frequency
  end
  def initialize(*args)
    @lenz = args[0].to_f
  end
end

class ElectricSource < ElectricUnits
end
class ElectricVoltageSource < ElectricSource
end
class ElectricCurrentSource < ElectricSource
end

class ElectricDirectCurrentVoltageSource < ElectricVoltageSource
  attr_accessor :voltage
  def value
    return @voltage
  end
  def initialize(*args)
    @voltage = args[0].to_f
  end
  def G
    return -1
  end
  def fs
    return value
  end
  def frequency
    return 0
  end
end

class ElectricDirectCurrentCurrentSource < ElectricCurrentSource
  attr_accessor :current
  def value
    return @current
  end
  def initialize(*args)
    @current = args[0].to_f
  end
  def G
    return 0
  end
  def fs
    return value
  end
  def frequency
    return 0
  end
end

class ElectricAlternateringCurrentVoltageSource < ElectricVoltageSource
  @@rms_filter = Math.sqrt(2)
  attr_accessor :voltage
  attr_accessor :rms
  attr_accessor :frequency
  def value
    return voltage * Complex::I
  end
  def initialize(*args)
    @voltage = args[0].to_f
    @rms = @voltage / @@rms_filter
    @frequency = args[1].to_f
  end
  def G
    return -1
  end
  def fs
    return value
  end
  end

class ElectricAlternateringCurrentCurrentSource < ElectricCurrentSource
  @@rms_filter = Math.sqrt(2)
  attr_accessor :current
  attr_accessor :rms
  attr_accessor :frequency
  def value
    return current * Complex::I
  end
  def initialize(*args)
    @current = args[0].to_f
    @rms = @current / @@rms_filter
    @frequency = args[1].to_f
  end
  def G
    return -1
  end
  def fs
    return value
  end
end

class ElectricCCVS < ElectricUnits

end

class ElectricVCVS < ElectricUnits

end

class ElectricCCCS < ElectricUnits

end

class ElectricVCCS < ElectricUnits

end

ElectricOpen = ElectricDirectCurrentCurrentSource.new(0)
ElectricShort = ElectricDirectCurrentVoltageSource.new(0)

