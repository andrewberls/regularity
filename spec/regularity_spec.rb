require 'spec_helper'

describe Regularity do

  let(:re) { Regularity.new }

  context 'regex methods' do
    it 'responds to regex methods' do
      re.should respond_to :match
      re.should respond_to :=~
    end
  end

  context '#start_with' do
    it 'matches basic characters' do
      re.start_with('f')
      re.get.should == /^f/
    end

    it 'escapes special characters' do
      re.start_with('.')
      re.get.should == /^\./
    end

    it 'matches basic characters' do
      re.start_with(3, 'x')
      re.get.should == /^x{3}/
    end

    it 'matches special identifiers' do
      re.start_with(2, :digits)
      re.get.should == /^[0-9]{2}/
    end
  end

  it 'raises an error when called twice' do
    expect do
      re.start_with('x').start_with('x')
    end.to raise_error(Regularity::Error)
  end

  context '#append' do
    it 'adds basic characters' do
      re.append('x').append('y').append('z')
      re.get.should == /xyz/
    end

    it 'also works as #then' do
      re.start_with('x').maybe('y').then('z')
      re.get.should == /^xy?z/
    end

    it 'escapes special characters' do
      re.between([0,2], :digits).then('.').end_with('$')
      re.get.should == /[0-9]{0,2}\.\$$/
    end
  end

  context '#maybe' do
    it 'recognizes basic characters' do
      re.append('x').maybe('y').append('z')
      re.regex.should == /xy?z/
      (re =~ "xyz").should == 0
      (re =~ "xz").should == 0
    end
  end

  context '#one_of' do
    it 'creates an alternation' do
      re.append('w').one_of(['x', 'y']).append('z')
      re.get.should == /w[x|y]z/
    end
  end

  context '#between' do
    it 'creates a bounded repetition' do
      re.between([2,4], 'x')
      re.get.should == /x{2,4}/
    end
  end

  context 'zero_or_more' do
    it 'recognizes basic characters' do
      re.zero_or_more('a').then('b')
      re.get.should == /a*b/
    end

    it 'recognizes special identifiers' do
      re.zero_or_more(:digits)
      re.get.should == /[0-9]*/
    end
  end

  context 'one_or_more' do
    it 'recognizes basic characters' do
      re.one_or_more('a').then('b')
      re.get.should == /a+b/
    end

    it 'recognizes special identifiers' do
      re.one_or_more(:letters)
      re.get.should == /[A-Za-z]+/
    end
  end

  context '#end_with' do
    it 'matches basic characters' do
      re.append('x').end_with('y')
      re.get.should == /xy$/
    end

    it 'escapes special characters' do
      re.append('x').end_with('$')
      re.get.should == /x\$$/
    end
  end

  context '#regex' do
    it 'returns a well-formed regex' do
      re.start_with('w').one_of(['x', 'y']).end_with('z')
      re.regex.should == /^w[x|y]z$/
    end
  end

  context 'special identifiers' do
    it 'recognizes digits' do
      re.append(2, :digits)
      re.regex.should == /[0-9]{2}/
    end

    it 'recognizes lowercase characters' do
      re.append(3, :lowercase)
      re.regex.should == /[a-z]{3}/
    end

    it 'recognizes uppercase characters' do
      re.append(3, :uppercase)
      re.regex.should == /[A-Z]{3}/

    end

    it 'recognizes alphanumeric characters' do
      re.append(3, :alphanumeric)
      re.regex.should == /[A-Za-z0-9]{3}/
    end

    it 'recognizes spaces' do
      re.append(4, :spaces)
      re.regex.should == / {4}/
    end

    it 'recognizes whitespace' do
      re.append(2, :whitespaces)
      re.regex.should == /\s{2}/
    end

    it 'recognizes tabs' do
      re.append(1, :tab)
      re.regex.should == /\t{1}/
    end
  end

  context 'examples' do
    specify do
         re.start_with(3, :digits)
            .then('-')
            .then(2, :letters)
            .maybe('#')
            .one_of(['a','b'])
            .between([2,4], 'c')
            .end_with('$')

      re.regex.should == /^[0-9]{3}-[A-Za-z]{2}#?[a|b]c{2,4}\$$/

      (re =~ "123-xy#accc$").should == 0
      (re =~ "999-dfbcc$").should == 0
      (re =~ "000-df#baccccccccc$").should be_nil
      (re =~ "444-dd3ac$").should be_nil
    end
  end
end
