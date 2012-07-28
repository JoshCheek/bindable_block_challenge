require 'bindable_block'

describe BindableBlock do
  let(:default_name) { "Carmen" }
  let(:klass)        { Struct.new :name }
  let(:instance)     { klass.new default_name }

  it 'can be bound to instances of the target' do
    block = BindableBlock.new(klass) { self }
    block.bind(instance).call.should equal instance
  end

  it 'can be rebound' do
    block = BindableBlock.new(klass) { name }
    block.bind(klass.new 'Josh').call.should == 'Josh'
    block.bind(klass.new 'Mei').call.should == 'Mei'
  end

  it 'can also just be invoked without being bound' do
    def self.a() 1 end
    b = 2
    block = BindableBlock.new(klass) { |c, &d| a + b + c + d.call }
    block.call(3){4}.should == 10
  end

  it 'can be passed to methods and shit' do
    doubler = lambda { |&block| block.call + block.call }
    doubler.call(&BindableBlock.new(klass) { 12 }).should == 24
  end

  describe 'arguments' do
    specify "when given complex arguments, it matches that shit right up" do
      proc  = Proc.new { |a, b, c=1, d=2, *e, f, &g| [a,b,c,d,e,f,(g&&g.call)] }
      block = BindableBlock.new(klass, &proc).bind(instance)
      block.call.should == proc.call
      block.call(:a).should == proc.call(:a)
      block.call(:a,:b).should == proc.call(:a,:b)
      block.call(:a,:b,:c).should == proc.call(:a,:b,:c)
      block.call(:a,:b,:c,:d).should == proc.call(:a,:b,:c,:d)
      block.call(:a,:b,:c,:d,:e).should == proc.call(:a,:b,:c,:d,:e)
      block.call(:a,:b,:c,:d,:e,:f).should == proc.call(:a,:b,:c,:d,:e,:f)
      block.call(:a,:b,:c,:d,:e,:f){:g}.should == proc.call(:a,:b,:c,:d,:e,:f){:g}
      block.call(:a,:b,:c,:d,:e,:f,:g){:h}.should == proc.call(:a,:b,:c,:d,:e,:f,:g){:h}

      proc = Proc.new { |a, b| [a, b] }
      block = BindableBlock.new(klass, &proc).bind(instance)
      block.call(:a).should == proc.call(:a)
      block.call(:a,:b).should == proc.call(:a,:b)
      block.call(:a,:b,:c).should == proc.call(:a,:b,:c)
    end
  end
end
