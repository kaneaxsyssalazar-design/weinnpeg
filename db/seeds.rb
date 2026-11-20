# Provinces / territories with tax rates (GST, PST, HST). Verify rates before final marking.
provinces = [
  ["Alberta", "AB", 0.05, 0, 0], ["British Columbia", "BC", 0.05, 0.07, 0],
  ["Manitoba", "MB", 0.05, 0.07, 0], ["New Brunswick", "NB", 0, 0, 0.15],
  ["Newfoundland and Labrador", "NL", 0, 0, 0.15], ["Northwest Territories", "NT", 0.05, 0, 0],
  ["Nova Scotia", "NS", 0, 0, 0.14], ["Nunavut", "NU", 0.05, 0, 0],
  ["Ontario", "ON", 0, 0, 0.13], ["Prince Edward Island", "PE", 0, 0, 0.15],
  ["Quebec", "QC", 0.05, 0.09975, 0], ["Saskatchewan", "SK", 0.05, 0.06, 0],
  ["Yukon", "YT", 0.05, 0, 0]
]
provinces.each do |name, code, gst, pst, hst|
  Province.find_or_create_by!(code: code) { |p| p.assign_attributes(name: name, gst: gst, pst: pst, hst: hst) }
end

cats = {
  "Vape Kits" => "Starter and open-system kits for adult vapers, from simple pod devices to adjustable mods.",
  "Tanks & Hardware" => "Replacement tanks, batteries and chargers for open-system devices.",
  "Coils" => "Replacement coils and pods in a range of resistances.",
  "E-Liquids" => "Nicotine e-liquids in a variety of flavours and strengths."
}
categories = cats.to_h { |name, desc| [name, Category.find_or_create_by!(name: name) { |c| c.description = desc }] }

products = [
  ["Prairie Pod Starter Kit", "Compact refillable pod system with a 1000 mAh battery and USB-C charging. Easy draw-activated start for people switching from cigarettes.", 34.99, 25, false, "Vape Kits"],
  ["Red River 80W Mod Kit", "Adjustable wattage box mod with a temperature-control mode, 0.96 inch screen and a 4 mL sub-ohm tank included.", 74.99, 12, true, "Vape Kits"],
  ["Assiniboine Slim Pen Kit", "Pen-style open-system kit with a 650 mAh battery, simple one-button operation and a 2 mL tank.", 29.99, 30, false, "Vape Kits"],
  ["Forks 4 mL Sub-Ohm Tank", "Stainless steel sub-ohm tank with a 4 mL capacity, top-fill design and adjustable airflow ring.", 29.99, 18, false, "Tanks & Hardware"],
  ["18650 Rechargeable Battery 3000 mAh", "High-drain rechargeable battery rated for 35 A continuous discharge. Sold with a protective case.", 14.99, 40, false, "Tanks & Hardware"],
  ["Dual-Bay Battery Charger", "Smart USB charger for two 18650 or 21700 batteries with overcharge protection and LED status lights.", 19.99, 22, true, "Tanks & Hardware"],
  ["Mesh Coil 0.4 ohm (5-pack)", "Replacement mesh coils for Forks and Red River tanks. Fast ramp-up and even flavour; rated for 40 to 70 W.", 17.99, 60, false, "Coils"],
  ["Pod Cartridge 0.8 ohm (3-pack)", "Replacement pods for the Prairie Pod Starter Kit with pre-installed ceramic coils.", 12.99, 80, false, "Coils"],
  ["Regular Coil 1.2 ohm (5-pack)", "Cotton-wick replacement coils for slim pen kits, suited to tight, cigarette-like draws.", 9.99, 55, true, "Coils"],
  ["Wheat City Tobacco E-Liquid 30 mL", "Smooth classic tobacco flavour in a 50/50 PG/VG blend. 12 mg/mL nicotine, 30 mL bottle.", 18.99, 50, false, "E-Liquids"],
  ["Winnipeg Winter Mint E-Liquid 30 mL", "Cool spearmint and menthol blend, 70/30 VG/PG for dense vapour. 6 mg/mL nicotine, 30 mL bottle.", 18.99, 45, false, "E-Liquids"],
  ["Peg City Berry Blast E-Liquid 60 mL", "Mixed blueberry and raspberry fruit flavour, 70/30 VG/PG. 3 mg/mL nicotine, 60 mL bottle.", 26.99, 35, true, "E-Liquids"]
]
products.each do |name, desc, price, stock, sale, cat|
  Product.find_or_create_by!(name: name) do |p|
    p.assign_attributes(description: desc, price: price, stock_quantity: stock, on_sale: sale, category: categories[cat])
  end
end
puts "Seeded #{Province.count} provinces, #{Category.count} categories, #{Product.count} products"
AdminUser.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end
SitePage.find_or_create_by!(slug: "about") do |p|
  p.title = "About We inn Peg Vapes"
  p.body = "We inn Peg Vapes is a Winnipeg vape shop for adult customers. " \
           "We stock starter kits, tanks, coils and e-liquids, and we are happy to help " \
           "you find what suits you.\n\nYou must be of legal age to shop here."
end
SitePage.find_or_create_by!(slug: "contact") do |p|
  p.title = "Contact us"
  p.body = "Visit us in downtown Winnipeg, Manitoba.\n\n" \
           "Email: hello@weinnpegvapes.example\nPhone: 204-555-0100\n\n" \
           "Store hours: Monday to Saturday, 10 am to 8 pm."
end