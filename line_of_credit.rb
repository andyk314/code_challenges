require 'pry'

class Credit
  attr_accessor :apr, :line_of_credit, :balance, :interest, :txns, :ints

  # Initialize inputs
  def initialize(apr, line_of_credit)
    @apr = apr
    @line_of_credit = line_of_credit
    @balance = 0
    @interest = 0
    @txns = {}
    @ints = [] #interests tracker
  end

  # Withdrawl Money and update balance/interest
  def debit(amount, current_period)
    if balance.zero?
      @balance += amount
      save_txn(current_period, 'debit', amount, @balance)
    else
      calculate_interest(current_period, @txns.keys.last)
      @balance += amount
      save_txn(current_period, 'debit', amount, @balance)
      @ints << @interest
      get_balance
    end
  end

  # Pay back money and update balance/interest
  def credit(amount, current_period)
    if balance.zero?
      "You do not have a balance."
    else
      @balance -= amount
      calculate_interest(current_period, @txns.keys.last)
      save_txn(current_period, 'credit', amount, @balance)
      @ints << @interest
      get_balance
    end
  end

  # Calculate Interest based on previous balance
  def calculate_interest(current_period, previous_period=0)
    previous_balance = @txns[previous_period][:balance]
    period_of_interest = current_period - previous_period
    @interest += (previous_balance * daily_interest * period_of_interest).round(2)
  end

  # Convert daily APR to percentage 
  def daily_interest
    @apr / 100.0 / 365
  end

  # Calculate Current Balance, Interest, Current Payoff
  def get_balance
    puts "Current Balance: #{@balance}"
    puts "Current Interest: #{@interest}"
    puts "Current Payoff: #{@balance + @interest}"
    puts
  end

  # Close statement after 30 days and charge interest to balance
  def close_statement(current_period, previous_period=0)
    calculate_interest(current_period, @txns.keys.last)
    @ints << @interest
    @balance += @interest
    @interest = 0
    @ints << @interest
    get_balance
  end

  # Record each credit/debit transaction to hash
  def save_txn(day, type, amount, balance)
    @txns[day] = {
      type: type,
      amount: amount,
      balance: balance,
    }
  end
end

# create instance of credit class with APR, line_of_credit inputs
credit = Credit.new(35, 1000)

# Draw $500 on day 1
credit.debit(500, 0)

# Pay back $200 on day 15
credit.credit(200, 15)

# Draw $100 on day 25
credit.debit(100, 25)

# Close statement and add interest to balance
credit.close_statement(30)

# Print transaction logs
p credit.txns

# Get current balance
credit.get_balance
