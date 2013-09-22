require 'spec_helper'

describe Regularity do
  context 'regex methods' do
    it 'responds to regex methods' do
      re = Regularity.new
      re.should respond_to :match
      re.should respond_to :=~
    end
  end

  context '#start_with' do
    it 'matches basic characters' do
      re = Regularity.new.start_with('f')
      re.get.should == /^[f]/
    end

    it 'escapes special characters' do
      re = Regularity.new.start_with('.')
      re.get.should == /^[\.]/
    end

    it 'matches basic characters' do
      re = Regularity.new.start_with(3, 'x')
      re.get.should == /^[x{3}]/
    end

    it 'matches special identifiers' do
      re = Regularity.new.start_with(2, :digits)
      re.get.should == /^[[0-9]{2}]/
    end
  end

  it 'raises an error when called twice' do
    expect do
      Regularity.new.start_with('x').start_with('x')
    end.to raise_error(Regularity::Error)
  end

  context '#append' do
    it 'adds basic characters' do
      re = Regularity.new.append('x').append('y').append('z')
      re.get.should == /xyz/
    end

    it 'also works as #then' do
      re = Regularity.new.start_with('x').then('y').then('z')
      re.get.should == /^[x]yz/
    end

    it 'escapes special characters' do
      re = Regularity.new.between([0,2], :digits).then('.').end_with('$')
      re.get.should == /[0-9]{0,2}\.\$$/
    end
  end

  context '#maybe' do

  end

  context '#one_of' do
    it 'creates an alternation' do
      re = Regularity.new.append('w').one_of(['x', 'y']).append('z')
      re.get.should == /w[x|y]z/
    end
  end

  context '#between' do
    it 'creates a bounded repetition' do
      re = Regularity.new.between([2,4], 'x')
      re.get.should == /x{2,4}/
    end
  end

  context '#end_with' do
    it 'matches basic characters' do
      re = Regularity.new.append('x').end_with('y')
      re.get.should == /xy$/
    end

    it 'escapes special characters' do
      re = Regularity.new.append('x').end_with('$')
      re.get.should == /x\$$/
    end
  end

  context '#regex' do
    it 'returns a well-formed regex' do
      re = Regularity.new.start_with('w').one_of(['x', 'y']).end_with('z')
      re.regex.should == /^[w][x|y]z$/
    end
  end

  context 'special identifiers' do
    it 'recognizes digits' do

    end

    it 'recognizes lowercase characters' do

    end

    it 'recognizes uppercase characters' do

    end

    it 'recognizes alphanumeric characters' do

    end

    it 'recognizes spaces' do

    end

    it 'recognizes tabs' do

    end
  end
end
