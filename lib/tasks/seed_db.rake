
desc 'Seed the database with sample material.'
task :seed_db => :environment do

  restaurant = Category.create({
    name: 'restaurant'
  });
  pharmacy = Category.create({
    name: 'pharmacy'
  });
  electronics = Category.create({
    name: 'electronics'
  });


  delicious = Tag.create({
    name: 'delicious'
  });
  affordable = Tag.create({
    name: 'affordable'
  });

  phones = [
   '+71 471 840-3493',
   '+77 971 427-3472',
   '+21 771 340-2891',
   '+31 972 220-4482',
   '+78 941 309-8491',
  ]

  names = [
    'Jake\'s Kitchen',
    'Ibiza',
    'Cruz Paradiso',
    'Valhalla\'s Symphony',
    'The Go-go Room'
  ]
  subdomains = [
    'jakeskitchen',
    'ibiza',
    'cruzparadiso',
    'valhallassymphony',
    'thegogoroom'
  ]

  categories = [
    pharmacy,
    restaurant,
    electronics,
    pharmacy,
    electronics
  ]

  tags = [
    [delicious, affordable],
    [affordable],
    [],
    [delicious],
    [delicious]
  ]

  5.times do |i|
    Store.create({
      phone: phones[i],
      name: names[i],
      subdomain: subdomains[i],
      slogan: 'The best food ever',
      status: 'Jake\'s is currently featuring a two for
               one special on margaritas.',
      location: '26 Institute Way',
      city: 'Abu Dhabi',
      country: 'UAE',
      category: categories[i],
      tags: tags[i],
      hours: [
        { title: 0, value: '8am - 9pm' },
        { title: 1, value: '8am - 9pm' },
        { title: 2, value: '8am - 9pm' },
        { title: 3, value: '8am - 9pm' },
        { title: 4, value: '8am - 9pm' },
        { title: 5, value: '10am - 7pm' },
        { title: 6, value: '11am - 5pm' }
      ]
    });
  end
end
