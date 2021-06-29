# frozen_string_literal: true

# Module for storing all of my custom enumerables
module Enumerable
  def my_each
    i = 0
    while i < length
      yield self[i]
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    selection = []
    my_each { |item| selection << item if yield item }
    selection
  end

  def my_all?
    my_each { |item| return false unless yield item }
    true
  end

  def my_any?
    my_each { |item| return true if yield item }
    false
  end

  def my_none?
    my_each { |item| return false if yield item }
    true
  end

  def my_count
    the_count = 0
    if block_given?
      my_each { |item| the_count += 1 if yield item }
    else the_count = length
    end
    the_count
  end

  def my_map(my_proc = nil)
    new_array = []
    if my_proc.nil?
      my_each { |item| new_array << (yield item) }
    else
      my_each { |item| new_array << my_proc.call(item) }
    end
    new_array
  end

  def my_inject(memo = nil)
    if memo.nil?
      memo = self[0]
      skip_first = true
    end
    my_each_with_index do |item, index|
      next if skip_first == true && index.zero?

      memo = yield(memo, item)
    end
    memo
  end
end

def multiply_els(figures)
  figures.my_inject { |product, number| product * number }
end

numbers = [-1, -2, 17, 1, 2, 3, 4, 5]
positive_numbers = [1, 5, 17, 22, 4]
puts 'my_each'
numbers.my_each { |item| puts item }
puts 'each'
numbers.each { |item| puts item }

puts 'my_each_with_index'
numbers.my_each_with_index { |item, index| puts "index: #{index}, value: #{item}" }
puts 'each_with_index'
numbers.each_with_index { |item, index| puts "index: #{index}, value: #{item}" }

puts 'my_select:'
p numbers.my_select(&:positive?)
puts 'select:'
p numbers.select(&:positive?)

puts 'my_all:'
p numbers.my_all?(&:positive?)
p positive_numbers.my_all?(&:positive?)
p(numbers.my_all? { |item| item.instance_of?(Integer) })
puts 'all:'
p numbers.all?(&:positive?)
p positive_numbers.all?(&:positive?)
p(numbers.all? { |item| item.instance_of?(Integer) })

puts 'my_any?:'
p numbers.my_any?(&:negative?)
p positive_numbers.my_any?(&:negative?)
p(numbers.my_any? { |item| item.instance_of?(String) })
puts 'any?:'
p numbers.any?(&:negative?)
p positive_numbers.any?(&:negative?)
p(numbers.any? { |item| item.instance_of?(String) })

puts 'my_none?:'
p numbers.my_none?(&:negative?)
p positive_numbers.my_none?(&:negative?)
p(numbers.my_none? { |item| item.instance_of?(String) })
puts 'none?:'
p numbers.none?(&:negative?)
p positive_numbers.none?(&:negative?)
p(numbers.none? { |item| item.instance_of?(String) })

puts 'my_count'
p numbers.my_count
p numbers.my_count(&:positive?)
p numbers.my_count(&:even?)
puts 'count'
p numbers.count
p numbers.count(&:positive?)
p numbers.count(&:even?)

puts 'my_map'
p(numbers.my_map { |item| item * 2 })
p numbers.my_map(&:to_s)
puts 'map'
p(numbers.map { |item| item * 2 })
p numbers.map(&:to_s)

puts 'my_inject'
p(numbers.my_inject { |sum, n| sum + n })
p(numbers.inject { |sum, n| sum + n })
puts 'inject'
p(numbers.my_inject { |product, n| product * n })
p(numbers.inject { |product, n| product * n })

puts 'multiply_els testing'
p multiply_els([2, 4, 5])
p multiply_els([2, 4, 5, 2])

puts 'Running procs through my_map tests'
invert_signs = proc { |item| item * -1 }
add_ten = proc { |item| item + 10 }

p numbers.my_map(invert_signs)
p numbers.my_map(add_ten)
p(numbers.my_map { |item| item + 99 })
