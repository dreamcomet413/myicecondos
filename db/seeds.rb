MenuLocation.destroy_all

m1 = MenuLocation.create(name: "Header Left", description: "Menu items appearing on the left side of the header")
m2 = MenuLocation.create(name: "Header Right", description: "Menu items appearing on the right side of the header")
m3 = MenuLocation.create(name: "Footer", description: "Menu items appearing in the footer")
m4 = MenuLocation.create(name: "More to Explore", description: "Menu items appearing on pages About Us, Buyers, Sellers etc")

m1.menu_items.create(title: "ABOUT", url: "/about", sort_order: 1)
m1.menu_items.create(title: "SELLERS", url: "/sellers", sort_order: 2)
m1.menu_items.create(title: "BUYERS", url: "/buyers", sort_order: 3)

m2.menu_items.create(title: "BLOG", url: "/blog", sort_order: 1)
m2.menu_items.create(title: "CONTACT", url: "/contact", sort_order: 2)

m3.menu_items.create(title: "ABOUT", url: "/about", sort_order: 1)
m3.menu_items.create(title: "SELLERS", url: "/sellers", sort_order: 2)
m3.menu_items.create(title: "BUYERS", url: "/buyers", sort_order: 3)
m3.menu_items.create(title: "TERMS & CONDITIONS", url: "/terms", sort_order: 4)
m3.menu_items.create(title: "BLOG", url: "/blog", sort_order: 5)
m3.menu_items.create(title: "CONTACT", url: "/contact", sort_order: 6)

m4.menu_items.create(title: "ABOUT", url: "/about", sort_order: 1)
m4.menu_items.create(title: "SELLERS", url: "/sellers", sort_order: 2)
m4.menu_items.create(title: "BUYERS", url: "/buyers", sort_order: 3)
m4.menu_items.create(title: "BLOG", url: "/blog", sort_order: 4)
m4.menu_items.create(title: "CONTACT", url: "/contact", sort_order: 5)
