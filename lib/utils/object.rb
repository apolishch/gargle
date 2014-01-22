class Object
  ##Shims the Rails try method for convenience
  ##While not all of it is necessary and strictly speaking
  #def try(*a)
  #  send(*a) if respond_to?(a.first)
  #end
  #would have been sufficient, this would break if rails was used in the same gemfile as Gargle. As such, this is a faithful, line by line port of the rails try
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      public_send(*a, &b) if respond_to?(a.first)
    end
  end
  ##Shims the Rails blank? method for convenience
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end
class NilClass
  def try(*args)
    nil
  end
end