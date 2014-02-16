
desc 'Seed the database with sample material.'
task :seed_db => :environment do

  restaurant = Category.create({
    name: 'restaurant',
    arabic_name: 'مطعم'
  });
  pharmacy = Category.create({
    name: 'pharmacy',
    arabic_name: 'صيدلية'
  });
  electronics = Category.create({
    name: 'electronics',
    arabic_name: 'إلكترونيات'
  });
  optometrist = Category.create({
    name: 'optometrist',
    arabic_name: 'متجر نظارات'
  });
  laundry = Category.create({
    name: 'laundry',
    arabic_name: 'مصبغة'
  });

  phones = [
   '+71 471 840-3493',
   '+77 971 427-3472',
   '+21 771 340-2891',
   '+31 972 220-4482',
   '+78 941 309-8491',
  ]

  names = [
    'الجميل للنظارات',
    'أبو بدر الالكترونيات',
    'ازكًدِنيا',
    'ظافر الصيدلة',
    'الرافدين للغسيل'
  ]
  subdomains = [
    'الجميلللنظارات',
    'أبوبدرالالكترونيات',
    'ازكًدِنيا',
    'ظافرالصيدلة',
    'الرافدينللغسيل'
  ]

  categories = [
    optometrist,
    electronics,
    restaurant,
    pharmacy,
    laundry
  ]

  5.times do |i|
    Store.create({
      phone: phones[i],
      name: names[i],
      subdomain: subdomains[i],
      slogan: 'من السهل العثور، فإنك لن تندم',
      status: 'نحن حالياً خارج المكتب لمتابعة الهاكثون',
      location: 'شارع زايد الأول',
      city: 'أبوظبي',
      country: 'الأمارات العربية المتحدة',
      category: categories[i],
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
