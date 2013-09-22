class Regularity

  class Error < StandardError; end

  PATTERNS = {
    'digit'        => '[0-9]',
    'lowercase'    => '[a-z]',
    'uppercase'    => '[A-Za-z]',
    'letter'       => '[A-Za-z]',
    'alphanumeric' => '[A-Za-z0-9]',
    'space'        => '\s', # TODO
    'tab'          => '\t'  # TODO
  }

  ESCAPED_CHARS = %w(
    * . ? ^ + $ | ( ) [ ] { }
  )

  def initialize
    @str = ''
  end

  def start_with(*args)
    raise Regularity::Error.new('#start_with? called multiple times') unless @str.empty?
    @str << '^[%s]' % interpret(*args)
    self
  end

  def append(*args)
    @str << interpret(*args)
    self
  end
  alias_method :then, :append

  def end_with(*args)
    @str << '%s$' % interpret(*args)
    self
  end

  def maybe(*args)
    @str << '%s*' % interpret(*args)
    self
  end

  def one_of(ary)
    @str << "[%s]" % ary.map { |c| escape(c) }.join('|')
    self
  end

  def between(range, pattern)
    raise Regularity:Error.new('must provide an array of 2 integers') unless range.length == 2
    @str << '%s{%s,%s}' % [interpret(pattern), range[0], range[1]]
    self
  end

  def regex
    Regexp.new(@str)
  end
  alias_method :get, :regex

  def method_missing(meth, *args, &block)
    regex.send(meth, *args, &block)
  end

  def respond_to?(meth)
    regex.respond_to?(meth) || super
  end

  private

  # Translate/escape characters etc and return regex-ready string
  def interpret(*args)
    case args.length
    when 2 then numbered_constraint(*args)
    when 1 then patterned_constraint(*args)
    else raise ArgumentError
    end
  end

  # Ex: (2, 'x') or (3, :digits)
  def numbered_constraint(count, type)
    pattern = escape translate(type)
    raise Regularity::Error.new('Unrecognized pattern') if pattern.nil? || pattern.empty?
    '%s{%s}' % [pattern, count]
  end

  # Ex: ('aa') or ('$')
  def patterned_constraint(pattern)
    escape translate(pattern)
  end

  # Remove a trailing 's', if there is one
  def singularize(word)
    str = word.to_s
    str.end_with?('s') ? str[0..-2] : str
  end

  # Escape special regex characters in a string
  #
  # Ex:
  #   escape("one.two")
  #   # => "one\.two"
  #
  def escape(pattern)
    pattern.to_s.gsub(/.+/) do |char|
      ESCAPED_CHARS.include?(char) ? "\\#{char}" : char
    end
  end

  # Translate an identifier such as :digits to [0-9], etc
  # Returns the original identifier if no character class found
  def translate(pattern)
    PATTERNS[singularize(pattern)] || pattern
  end

end
