module HomeHelper
  def beds_options
    [["ANY # OF BEDROOMS", nil], ["NO BEDROOMS", "0"], ["1 BEDROOM", "1"], ["1+ BEDROOMS", "1+"], ["2+ BEDROOMS", "2+"]]
  end

  def baths_options
    [["ANY # OF BATHROOMS", nil], ["1+ BATHROOMS", "1+"], ["2+ BATHROOMS", "2+"]]
  end

  def sort_options
    [["SORT BY", nil], ["NEWEST TO OLDEST", "date_desc"], ["OLDEST TO NEWEST", "date_asc"], ["PRICE: LOW TO HIGH", "price_asc"], ["PRICE: HIGH TO LOW", "price_desc"]]
  end

  def price_options
    [
      ["$0", "0"],
      ["$100,000", "100000"],
      ["$200,000", "200000"],
      ["$300,000", "300000"],
      ["$400,000", "400000"],
      ["$500,000", "500000"],
      ["$600,000", "600000"],
      ["$700,000", "700000"],
      ["$800,000", "800000"],
      ["$900,000", "900000"],
      ["$1 Million", "1000000"],
      ["$1.5 Million", "1500000"],
      ["$2 Million", "2000000"],
      ["$5 Million", "5000000"],
      ["$10 Million", "10000000"],
      ["$25 Million", "25000000"]
    ]
  end
end
