MenuLocation.destroy_all

m1 = MenuLocation.create(name: "Header", description: "Menu items appearing in the header")

m1.menu_items.create(title: "Home", url: "/", sort_order: 1)
m1.menu_items.create(title: "About", url: "/about", sort_order: 2)
m1.menu_items.create(title: "Buyers", url: "/listings", sort_order: 3)
m1.menu_items.create(title: "Renters", url: "/listings?rent=1", sort_order: 4)
m1.menu_items.create(title: "Sell with Us", url: "/sell", sort_order: 5)
m1.menu_items.create(title: "Condo Evaluation", url: "/evaluation", sort_order: 6)
m1.menu_items.create(title: "Location", url: "/location", sort_order: 7)
m1.menu_items.create(title: "Gallery", url: "/gallery", sort_order: 8)
m1.menu_items.create(title: "Fast response", url: "/contact", sort_order: 9)

user = User.new
user.email = 'testuser@example.com'
user.password = 'password'
user.password_confirmation = 'password'
user.save!