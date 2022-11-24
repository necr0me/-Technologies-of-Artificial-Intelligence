class String
  def centrify(length)
    amount = (length - self.length) / 2
    result = ' ' * amount + self + ' ' * amount
    result.length == length ? result : "#{result} "
  end
end
