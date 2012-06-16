require "bindable_block/version"

class BindableBlock

  # Your challenge is to make this class work correctly (see readme for details)
  class ArgAligner
    def self.align(args, instance_method)
      new(args, instance_method).call
    end

    attr_accessor :args, :instance_method

    def initialize(args, instance_method)
      self.args, self.instance_method = args, instance_method
    end

    def call
      args
    end
  end


  # =====  You really shouldn't need to understand anything below this line  =====

  def initialize(klass, &block)
    @original_block  = block

    klass.__send__ :define_method, method_name, &block
    @instance_method = klass.instance_method method_name
    klass.__send__ :remove_method, method_name
  end

  attr_reader :instance_method, :original_block

  def bind(target)
    Proc.new do |*args, &block|
      instance_method.bind(target).call(*align(args), &block)
    end
  end

  def call(*args, &block)
    original_block.call(*args, &block)
  end

  def to_proc
    method(:call).to_proc
  end

  private

  def align(args)
    ArgAligner.align args, instance_method
  end

  def method_name
    @method_name ||= "bindable_block_#{Time.now.to_i}_#{$$}_#{rand 1000000}"
  end
end
