import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

class PrefectureRegionPage extends StatefulWidget {
  const PrefectureRegionPage({super.key});

  @override
  State<PrefectureRegionPage> createState() => _PrefectureRegionPageState();
}

class _PrefectureRegionPageState extends State<PrefectureRegionPage> {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);
  
  int _activeRegionIndex = 0;
  bool _isBannerFlipped = false;
  bool _triggerTeaser = false; 
  final CarouselSliderController _carouselController = CarouselSliderController();

 final List<Map<String, dynamic>> _regionData = [
    {
      "region": "Hokkaido",
      "jp": "北海道",
      "description": "Hokkaido, Japan's northernmost island, is a year-round paradise renowned for its vast landscapes, soothing hot springs, and world-class seafood. While summer brings sprawling flower fields, winter transforms the region into a global epicenter for skiing and snowboarding, famous for its unrivaled \"Japow\" powder snow and majestic mountain resorts.",
      "bgImg": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "prefectures": [
        {
          "name": "Hokkaido",
          "jp": "札幌",
          "details": "Japan's northern frontier known for powdery winter snow, world-class skiing, and exceptionally fresh dairy and seafood shaped by its cool climate and vast natural landscapes.\n\nLocal specialties: \n• Dairy products (milk, cheese, butter)\n• Seafood (crab, scallops, uni)\n• Yubari melon\n\nMust-visit attractions: \n• Panoramic Flower Gardens Shikisai-no-oka \n• Niseko ski resorts\n• Otaru Canal\n\nMust-try food / local cuisine: \n• Soup curry \n• Miso ramen\n• Seafood donburi\n• Soft-serve ice cream\n\nMust-buy souvenirs / local crafts: \n• Shiroi Koibito cookies\n• ROYCE' Nama Chocolate \n• Lavender products\n\nFun fact / cultural quirk: Hokkaido is famous for its snow festivals and large-scale outdoor winter events, attracting visitors worldwide.",
          "img": "https://en.obihiro-glamping.com/wp-content/uploads/2022/08/0043.jpg",
        },
      ]
    },
    {
      "region": "Tohoku",
      "jp": "東北",
      "description": "Tohoku is the scenic northeastern region of Honshu, known for its rugged mountains, hot springs, and vibrant traditional festivals. Less crowded than central Japan, it is rich in cultural heritage and seasonal beauty.",
      "bgImg": "https://images.pexels.com/photos/402028/pexels-photo-402028.jpeg",
      "prefectures": [
        {
          "name": "Aomori",
          "jp": "青森",
          "details": "Japan's apple capital, famous for crisp, juicy apples and the vibrant Nebuta Festival that lights up summer nights.\n\nLocal Specialties: \n• Apples \n• Seafood (scallops, sea urchin, oma tuna)\n• Aomori senbei soup\n\nMust-Visit Attractions:\n• Hirosaki Castle\n• Nebuta Museum\n• Lake Towada\n\nMust-Try Food / Local Cuisine: \n• Kaiyaki Miso\n• Nokke-don \n• Senbei-jiru \n• Ichigo-ni \n\nMust-Buy Souvenirs / Local Crafts: \n• Hirosaki apples\n• Nebuta-themed goods\n• Tsugaru lacquerware\n\nFun Fact / Cultural Quirk: Home of the Nebuta Festival, a spectacular summer parade with giant illuminated floats.",
          "img": "https://images.pexels.com/photos/1654748/pexels-photo-1654748.jpeg",
        },
        {
          "name": "Iwate",
          "jp": "岩手",
          "details": "A rugged land of vast coastlines and ancient ironware traditions.\n\nLocal Specialties: \n• Wanko soba\n• Maesawa wagyu beef\n• Kamome no Tamago sweets\n\nMust-Visit Attractions\n• Hiraizumi UNESCO temples \n• Geibikei Gorge scenic boat ride\n• Ryusendo Cave limestone wonderland\n\nMust-Try Food: \n• Wanko soba\n• Local seafood donburi\n• Nambu senbei crackers\n\nMust-Buy Souvenirs:\n• Kamome no Tamago sweets\n• Nambu cast ironware\n• Handcrafted wooden goods\n\n• Fun Fact / Cultural Quirk: Nambu iron kettles are prized because the iron they release is said to make tea taste significantly sweeter and mellower.",
          "img": "https://images.pexels.com/photos/149506/pexels-photo-149506.jpeg",
        },
        {
          "name": "Miyagi",
          "jp": "宮城",
          "details": "A coastal gem centred around Sendai and the breathtaking islands of Matsushima Bay, celebrated for its scenic beauty, seafood, and samurai-era history.\n\nLocal Specialties: \n• Gyutan \n• Zunda mochi \n• Sendai seafood\n\nMust-Visit Attractions: \n• Matsushima Bay (one of Japan's three most scenic views).\n• Sendai Castle ruins\n• Naruko Onsen hot springs\n\nMust-Try Food: \n• Gyutan\n• Zunda mochi \n• Oysters\n\nMust-Buy Souvenirs: \n• Zunda sweets & products\n• Dry junmai sake\n• Traditional lacquerware\n\nFun Fact / Cultural Quirk: While Zunda (edamame paste) is traditional, it has been modernized into trendy parfaits and milkshakes.",
          "img": "https://images.pexels.com/photos/5220090/pexels-photo-5220090.jpeg",
        },
        {
          "name": "Akita",
          "jp": "秋田",
          "details": "A serene, snow-draped northern escape celebrated for its abundant natural hot springs, picturesque winter landscapes, and quietly preserved traditions of rural Japan.\n\nLocal Specialties: \n• Akita sake\n• Inaniwa udon\n• Kiritanpo \n\nMust-Visit Attractions: \n• Kakunodate Samurai District\n• Lake Tazawa\n• Akita Museum of Art\n\nMust-Try Food: \n• Kiritanpo\n• Inaniwa udon \n• Yokote yakisoba\n\nMust-Buy Souvenirs: \n• Silky Inaniwa udon noodles\n• Akita sake\n• Local confections with white bean paste\n\nFun Fact / Cultural Quirk: The cold weather culture here led to the invention of \"smoked\" pickles (iburigakko) because vegetables had to be dried indoors by the hearth.",
          "img": "https://images.pexels.com/photos/6051586/pexels-photo-6051586.jpeg",
        },
        {
          "name": "Yamagata",
          "jp": "山形",
          "details": "The \"Fruit Kingdom\" of Japan, where snow-fed soil produces the nation's most luxurious harvests.\n\nLocal Specialties: \n• Cherries \n• Peaches \n• Soba\n\nMust-Visit Attractions: \n• Yamadera temple\n• Ginzan Onsen historic spa town\n• Zao Onsen\n\nMust-Try Food: \n• Imoni \n• Yonezawa beef \n• Hiyashi-Ramen \n\nMust-Buy Souvenirs: \n• Cherry-flavoured snacks\n• Local snacks\n• Pottery from artisan villages \n\nFun Fact / Cultural Quirk: The seasonal temperature shifts are so intense they actually help concentrate the sugar and flavor in the local fruit.",
          "img": "https://images.pexels.com/photos/5305569/pexels-photo-5305569.jpeg",
        },
        {
          "name": "Fukushima",
          "jp": "福島",
          "details": "The \"Fruit Kingdom\" where you can eat your noodles with a leek and sip award-winning sake.\n\nLocal Specialties: \n• Peaches \n• Kitakata ramen\n• Local sake\n\nMust-Visit Attractions: \n• Tsuruga Castle in Aizu-Wakamatsu\n• Goshikinuma \"Five Colored Lakes\"\n• Ouchi-juku historic post town\n\nMust-Try Food: \n• Negi soba \n• Kitakata ramen \n• Fukushima fruit parfait\n\nMust-Buy Souvenirs: \n• Traditional crafts\n• Peach products\n• Local sake\n\nFun Fact / Cultural Quirk: In some regions, negi soba is eaten using a whole leek as a utensil—you bite the \"chopstick\" as you eat the noodles!",
          "img": "https://images.pexels.com/photos/5769587/pexels-photo-5769587.jpeg",
        },
      ]
    },
    {
      "region": "Kantō",
      "jp": "関東",
      "description": "Kanto is Japan's vibrant eastern region, home to the bustling metropolis of Tokyo as well as historic towns and natural landscapes. It blends modern urban life with traditional culture, offering a mix of skyscrapers, temples, and scenic retreats.",
      "bgImg": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
      "prefectures": [
        {
          "name": "Tokyo",
          "jp": "東京",
          "details": "A global metropolis blending centuries-old temples, neon streets, and cutting-edge culture.\n\nLocal Specialties: \n• Omakase sushi\n• Tsukemen\n• Monjayaki\n\nMust-Visit Attractions: \n• Tsukiji Market\n• Senso-ji Temple \n• Tokyo Tower\n\nMust-Try Food / Local Cuisine: \n• Sushi\n• Fukagawa-meshi\n• Chanko-nabe\n\nMust-Buy Souvenirs / Local Crafts: \n• Japanese knives\n• Traditional Edo crafts\n• Tokyo Banana\n\nFun Fact / Cultural Quirk: \nOmakase actually originated right here in Tokyo's street-side sushi stalls—it started as the ultimate fast food for busy locals!",
          "img": "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
        },
        {
          "name": "Kanagawa",
          "jp": "神奈川",
          "details": "Famed for Hakone's hot springs and the cosmopolitan port city of Yokohama.\n\nLocal Specialties: \n• Shirasu (whitebait) \n• Misaki Maguro (tuna)\n• Yokohama ramen\n\nMust-Visit Attractions: \n• Hakone hot springs\n• Giant Buddha of Kamakura\n• Yokohama Chinatown\n\nMust-Try Food / Local Cuisine: \n• Black Eggs from Owakudani\n• Seafood from Misaki\n• Regional sweets\n\nMust-Buy Souvenirs / Local Crafts: \n• Hakone Yosegi marquetry\n• Local sake\n• Confectioneries\n\nFun Fact / Cultural Quirk: Eating a Black Egg is said to add seven years to your life",
          "img": "https://images.pexels.com/photos/30091614/pexels-photo-30091614.jpeg",
        },
        {
          "name": "Chiba",
          "jp": "千葉",
          "details": "Home to Tokyo Disneyland, Chiba is best known for its signature peanuts and coastal charm just beyond Tokyo.\n\nLocal Specialties: \n• Peanuts \n• Pacific saury\n• Neri kamaboko \n\nMust-Visit Attractions: \n• Tokyo Disneyland\n• Naritasan Shinshoji Temple\n• Kujukuri Beach\n\nMust-Try Food / Local Cuisine: \n• Namerou\n• Futomaki-zushi\n• Katsuura Tantanmen\n• White Gyoza\n\nMust-Buy Souvenirs / Local Crafts: \n• Peanut-based sweets\n• Local seafood products\n• Themed Disney merchandise\n\nFun Fact / Cultural Quirk: Chiba is known for both its agricultural produce and its role as Tokyo's gateway, hosting the country's busiest airport.",
          "img": "https://images.pexels.com/photos/5236398/pexels-photo-5236398.jpeg",
        },
        {
          "name": "Saitama",
          "jp": "埼玉",
          "details": "A cultural extension of Tokyo where historic towns like Kawagoe preserve Edo-era charm alongside modern suburban life and traditional festivals.\n\nLocal specialties: \n• Sayama tea\n• Freshwater eel \n• Jelly Fries\n\nMust-visit attractions: \n• Chichibu Shrine\n• The Railway Museum\n• Mitsumine Shrine\n\nMust-try food / local cuisine: \n• Hiyajiru udon\n• Unagi\n• Okara patties\n\nMust-buy souvenirs / local crafts: \n• Sayama Tea\n• Soka Senbei \n• Ogawa Washi paper\n\nFun fact / cultural quirk: Saitama is home to Japan's only dedicated bonsai village, where enthusiasts can explore centuries-old bonsai artistry.",
          "img": "https://images.pexels.com/photos/24771664/pexels-photo-24771664.jpeg",
        },
        {
          "name": "Gunma",
          "jp": "群馬",
          "details": "A mountainous escape famed for its legendary hot spring towns like Kusatsu, scenic highlands, and outdoor adventures across all four seasons.\n\nLocal specialties: \n• Yaki manju\n• Mizusawa udon\n• Konnyaku\n\nMust-visit attractions: \n• Yubatake\n• Tomioka Silk Mill\n• Konnyaku Park\n\nMust-try food / local cuisine: \n• Okkirikomi noodle stew\n• Mizusawa udon\n• Onsen tamago\n\nMust-buy souvenirs / local crafts: \n• Daruma Dolls\n• Silk Products\n• Konjac \n\nFun fact / cultural quirk: Gunma is famous for its hot springs, many of which are said to have therapeutic properties.",
          "img": "https://images.pexels.com/photos/13443329/pexels-photo-13443329.jpeg",
        },
        {
          "name": "Ibaraki",
          "jp": "茨城",
          "details": "A coastal and agricultural hub known for vast flower parks, scenic gardens, and fertile farmland producing some of Japan's finest melons and crops.\n\nLocal specialties: \n• Melons \n• Natto \n• Monkfish\n\nMust-visit attractions: \n• Hitachi Seaside Park \n• Kairakuen Garden\n• Nakaminato Fish Market\n\nMust-try food / local cuisine: \n• Anko-nabe (monkfish hot pot)\n• Hitachi wagyu beef\n• Hiyajiru udon\n\nMust-buy souvenirs / local crafts: \n• Melons \n• Natto products\n• Dried sweet potatoes\n\nFun fact / cultural quirk: The famous Hitachi Seaside Park is renowned for its vast fields of blue nemophila flowers in spring.",
          "img": "https://images.pexels.com/photos/34885502/pexels-photo-34885502.jpeg",
        },
        {
          "name": "Tochigi",
          "jp": "栃木",
          "details": "Dubbed Japan's \"Strawberry Kingdom\", this region is a top producer of premium strawberries\n\nLocal specialties: \n• Strawberries \n• Yuba  \n• Utsunomiya-style gyoza\n\nMust-visit attractions: \n• Nikko Toshogu Shrine \n• Utsunomiya gyoza street\n• Ashikaga Flower Park\n\nMust-try food / local cuisine: \n• Sano Ramen\n• Utsunomiya gyoza\n\nMust-buy souvenirs / local crafts: \n• Strawberry sweets\n• Yuba snacks\n• Mashiko-yaki Pottery\n\nFun fact / cultural quirk: The city of Utsunomiya has over 200 gyoza restaurants, making it a major local specialty.",
          "img": "https://images.pexels.com/photos/28954739/pexels-photo-28954739.jpeg",
        },
      ]
    },
    {
      "region": "Chubu",
      "jp": "中部",
      "description": "Chubu is the heart of Japan's main island, offering a blend of majestic mountains, historic towns, and vibrant cities. Home to Mount Fuji and the Japanese Alps, it is a region rich in natural beauty, traditional crafts, and regional cuisine.",
      "bgImg": "https://pixabay.com/get/g55769939b06e9740d9d321fcbce210d8c13c777c1961f8895e0a475e3b96e707edb1d5d6a8d294d2dcea1d01418fceb0d92ccf8ba85ec7b7b613c7bf26867dcc_1920.jpg",
      "prefectures": [
        {
          "name": "Niigata",
          "jp": "新潟",
          "details": "A snow-covered coastal prefecture celebrated for premium rice, refined sake culture, ski resorts, and dramatic seasonal landscapes shaped by heavy winters.\n\nLocal specialties: \n• Koshihikari rice\n• Sake\n• Snow crab\n• Yellowtail\n\nMust-visit attractions: \n• Sado Island\n• Yahiko Shrine\n• Yuzawa ski resorts\n\nMust-try food / local cuisine: \n• Hegi soba\n• Tare katsudon\n• Sasa-dango\n\nMust-buy souvenirs / local crafts: \n• Niigata Sake\n• Koshihikari rice\n• Shinko Mochi \n\nFun fact / cultural quirk: Niigata is known as Japan's rice capital and holds the title for having the largest number of shrines in Japan.",
          "img": "https://images.pexels.com/photos/15830265/pexels-photo-15830265.jpeg",
        },
        {
          "name": "Toyama",
          "jp": "富山",
          "details": "A pristine coastal region backed by the Japanese Alps, famed for its \"natural aquarium\" bay, alpine routes, and exceptionally fresh seafood.\n\nLocal specialties: \n• Hotaruika (firefly squid)\n• Himi Kanburi (winter yellowtail)\n• White shrimp\n\nMust-visit attractions: \n• Tateyama Kurobe Alpine Route\n• Toyama Bay\n• Kurobe Dam\n\nMust-try food / local cuisine: \n• Himi beef\n• Toyama black ramen\n• Himi udon\n\nMust-buy souvenirs / local crafts: \n• Glassware\n• Seafood preserves\n• Masu no Sushi\n\nFun fact / cultural quirk: The Tateyama Kurobe Alpine Route offers dramatic mountain scenery, including Japan's tallest dam.",
          "img": "https://images.pexels.com/photos/4151484/pexels-photo-4151484.jpeg",
        },
        {
          "name": "Ishikawa",
          "jp": "石川",
          "details": "Centred around historic Kanazawa, this prefecture blends samurai heritage, gold-leaf artistry, elegant gardens, and refined traditional culture.\n\nLocal specialties: \n• Nodoguro (blackthroat seaperch), \n• Sweet shrimp\n• Seasonal Kano crab\n\nMust-visit attractions: \n• Kenroku-en Garden\n• Kanazawa Castle\n• Higashi Chaya District\n\nMust-try food / local cuisine: \n• Jibuni (Kanazawa-style duck stew)\n• Kabarazushi\n• Kanazawa Oden\n\nMust-buy souvenirs / local crafts: \n• Gold leaf products\n• Pottery\n• Sake\n\nFun fact / cultural quirk: It produces roughly 99% to 100% of Japan's gold leaf (kinpaku), earning it the nickname \"City of Gold\".",
          "img": "https://images.pexels.com/photos/4026905/pexels-photo-4026905.jpeg",
        },
        {
          "name": "Fukui",
          "jp": "福井",
          "details": "A quiet coastal prefecture known for dramatic cliffs, Zen temples, dinosaur discoveries, and centuries-old craftsmanship in knives and paper.\n\nLocal specialties: \n• Echizen crab\n• Koshihikari rice\n• Ume plums\n\nMust-visit attractions: \n• Fukui Prefectural Dinosaur Museum\n• Eiheiji Temple\n• Tojinbo Cliffs\n\nMust-try food / local cuisine: \n• Echizen soba\n• Sauce Katsudon\n• Saba Bozushi\n\nMust-buy souvenirs / local crafts: \n• Sabae Glasses,\n• Echizen knives\n• Handmade washi paper\n\nFun fact / cultural quirk: It's the nation's top producer of optical frames and is considered the central point of the Japanese archipelago.",
          "img": "https://images.pexels.com/photos/3625115/pexels-photo-3625115.jpeg",
        },
        {
          "name": "Yamanashi",
          "jp": "山梨",
          "details": "Nestled around Mount Fuji, this scenic region is famed for vineyards, fruit orchards, and panoramic mountain views reflected in lakes and valleys.\n\nLocal specialties: \n• Grapes\n• Peaches\n• Wine\n\nMust-visit attractions: \n• Chureito Pagoda\n• Lake Kawaguchiko\n• Katsunuma Wineries\n\nMust-try food / local cuisine: \n• Hoto noodles\n• Yoshida udon\n• Kofu Torimotsu-ni\n\nMust-buy souvenirs / local crafts: \n• Wine\n• Shingen-mochi\n• Fruit jams\n\nFun fact / cultural quirk: Yamanashi is considered the gateway to Mount Fuji, offering some of the best views of the iconic peak.",
          "img": "https://images.pexels.com/photos/15924876/pexels-photo-15924876.jpeg",
        },
        {
          "name": "Nagano",
          "jp": "長野",
          "details": "A highland prefecture of alpine peaks, historic temples, ski resorts, and traditional villages shaped by its cool climate and mountainous terrain.\n\nLocal specialties: \n• Apples\n• Soba\n• Mountain vegetables\n\nMust-visit attractions: \n• Zenkoji Temple\n• Daio Wasabi Farm\n• Matsumoto Castle\n\nMust-try food / local cuisine: \n• Oyaki dumplings\n• Shinshu Soba \n• Basashi \n\nMust-buy souvenirs / local crafts: \n• Yawataya Isogoro Shichimi Togarashi\n• Kiso Lacquerware\n• Shinshu Miso \n\nFun fact / cultural quirk: It is famously home to the \"snow monkeys\" at Jigokudani Monkey Park that bathe in hot springs.",
          "img": "https://images.pexels.com/photos/5759903/pexels-photo-5759903.jpeg",
        },
        {
          "name": "Gifu",
          "jp": "岐阜",
          "details": "A cultural heartland of traditional Japan, known for Shirakawa-go's thatched villages, mountain rivers, and centuries-old cormorant fishing traditions.\n\nLocal specialties: \n• Fuyu persimmons\n• Ayu fish\n• Hida beef\n\nMust-visit attractions: \n• Shirakawa-go\n• Gifu Castle\n• Nagara River cormorant fishing\n\nMust-try food / local cuisine: \n• Hida beef dishes\n• Hoba miso\n• Grilled ayu\n\nMust-buy souvenirs / local crafts: \n• Sarubobo dolls \n• Samurai swords\n• Knives from Seki\n\nFun fact / cultural quirk: Cormorant fishing (ukai) on the Nagara River has been used for 1,300 years to catch sweetfish (ayu).",
          "img": "https://images.pexels.com/photos/2187603/pexels-photo-2187603.jpeg",
        },
        {
          "name": "Shizuoka",
          "jp": "静岡",
          "details": "Framed by Mount Fuji and the Pacific coast, this prefecture is famed for green tea fields, scenic coastlines, and abundant seafood.\n\nLocal specialties: \n• Green tea\n• Wasabi\n• Shimizu tuna\n• Sakura shrimp\n\nMust-visit attractions: \n• Mount Fuji\n• Izu Panorama Park\n• Kunozan Toshogu Shrine\n\nMust-try food / local cuisine: \n• Genkotsu Hamburger Steak \n• Tuna sashimi\n• Shizuoka Oden\n\nMust-buy souvenirs / local crafts: \n• Shizuoka green tea\n• Wasabi products\n• Shizuoka Mikan (Mandarin Orange) Products\n\nFun fact / cultural quirk: Shizuoka grows more than 80% of Japan's wasabi and vast majority of Japan's green tea.",
          "img": "https://images.pexels.com/photos/3995905/pexels-photo-3995905.jpeg",
        },
        {
          "name": "Aichi",
          "jp": "愛知",
          "details": "A manufacturing powerhouse anchored by Nagoya, blending samurai heritage, grand castles, and a bold, distinctive culinary culture.\n\nLocal specialties: \n• Hatcho miso\n• Tamari soy sauce\n• Mirin\n• Sake\n\nMust-visit attractions: \n• Nagoya Castle\n• Atsuta Shrine\n• Toyota Commemorative Museum\n\nMust-try food / local cuisine: \n• Miso katsu\n• Hitsumabushi (grilled eel)\n• Tebasaki\n\nMust-buy souvenirs / local crafts: \n• Yukari Shrimp Crackers\n• Maneki Neko (Lucky Cat) Goods\n• Arimatsu & Narumi Shibori\n\nFun fact / cultural quirk: It is the headquarters of Toyota Motor Corporation, making it the center of Japan's automotive industry.",
          "img": "https://images.pexels.com/photos/634009/pexels-photo-634009.jpeg",
        },
      ]
    },
    {
      "region": "Kansai",
      "jp": "関西",
      "description": "Kansai is Japan's cultural heart, known for its rich history, traditional architecture, and vibrant culinary scene. Home to Kyoto, Osaka, and Nara, the region blends historic temples and castles with bustling city life and lively street culture.",
      "bgImg": "https://cdn.pixabay.com/photo/2016/11/07/14/03/japan-1805865_1280.jpg",
      "prefectures": [
        {
          "name": "Osaka",
          "jp": "大阪",
          "details": "Japan's street food capital, famous for neon-lit Dotonbori\n\nLocal specialties: \n• Takoyaki\n• Okonomiyaki\n• Kushikatsu\n\nMust-visit attractions: \n• Dotonbori\n• Osaka Castle\n• Universal Studios Japan\n\nMust-try food / local cuisine: \n• Takoyaki\n• Okonomiyaki\n• Kushikatsu\n\nMust-buy souvenirs / local crafts: \n• Takoyaki-flavoured snacks\n• Osaka-themed keychains or merchandise\n• Matcha or confectionery sweets\n\nFun fact / cultural quirk: Osaka is called \"the nation's kitchen\" defining its vibrant street food scene, with major innovations including the world's first conveyor belt sushi and instant noodles.",
          "img": "https://images.pexels.com/photos/356269/pexels-photo-356269.jpeg",
        },
        {
          "name": "Kyoto",
          "jp": "京都",
          "details": "Ancient capital famed for temples, Zen gardens, and tea houses\n\nLocal specialties:\n• Kaiseki cuisine \n• Uji matcha and sweets\n• Yudofu \n\nMust-visit attractions:\n• Kinkaku-ji (Golden Pavilion)\n• Fushimi Inari Taisha\n• Gion district\n\nMust-try food / local cuisine:\n• Yudofu \n• Kyo Kaiseki\n• Matcha desserts\n\nMust-buy souvenirs / local crafts:\n• Kyo-yuzen textiles\n• Kyoto pottery\n• Matcha sweets\n\nFun fact / cultural quirk: You might see deer wandering near temples.",
          "img": "https://images.pexels.com/photos/35501372/pexels-photo-35501372.jpeg",
        },
        {
          "name": "Hyogo",
          "jp": "兵庫",
          "details": "Home to Himeji Castle and famous samurai history.\n\nLocal specialties:\n• Kobe beef\n• Matsuba crab\n• Sake\n• Olives\n\nMust-visit attractions:\n• Himeji Castle\n• Arima Onsen\n• Kobe Harborland\n\nMust-try food / local cuisine:\n• Kobe beef steak\n• Takoyaki\n• Seafood donburi\n\nMust-buy souvenirs / local crafts:\n• Nada sake\n• Awaji onions\n• Traditional textiles\n\nFun fact / cultural quirk: Himeji Castle, a UNESCO World Heritage site, is nicknamed the \"White Heron Castle\" due to its elegant white appearance.",
          "img": "https://images.pexels.com/photos/31416883/pexels-photo-31416883.jpeg",
        },
        {
          "name": "Nara",
          "jp": "奈良",
          "details": "Home to the Great Buddha and friendly deer.\n\nLocal specialties:\n• Kaki-no-ha Zushi\n• Persimmons\n• Sake\n\nMust-visit attractions:\n• Todai-ji\n• Nara Park\n• Kasuga Taisha\n\nMust-try food / local cuisine:\n• Kakinoha sushi\n• Nara pickles\n• Local sweets\n\nMust-buy souvenirs / local crafts:\n• Nara brushes\n• Calligraphy sets\n• Persimmon leaf crafts\n\nFun fact / cultural quirk: Nara Park's deer are considered sacred messengers of the Shinto gods and freely interact with visitors.",
          "img": "https://images.pexels.com/photos/27041999/pexels-photo-27041999.jpeg",
        },
        {
          "name": "Shiga",
          "jp": "滋賀",
          "details": "Lake Biwa surrounds top-notch Omi beef and trout.\n\nLocal specialties:\n• Omi beef\n• Biwa trout\n• Freshwater fish dishes\n\nMust-visit attractions:\n• Lake Biwa\n• Hikone Castle\n• Shirahige Shrine\n\nMust-try food / local cuisine:\n• Omi beef steak\n• Biwa trout sushi\n• Freshwater fish dishes\n\nMust-buy souvenirs / local crafts:\n• Lake Biwa glassware\n• Sake\n• Pickles\n\nFun fact / cultural quirk: Lake Biwa, Japan's largest freshwater lake, has shaped the culture and cuisine of Shiga for centuries.",
          "img": "https://images.pexels.com/photos/31361162/pexels-photo-31361162.jpeg",
        },
        {
          "name": "Wakayama",
          "jp": "和歌山",
          "details": "Nature and pilgrimages meet Ume plums and soy sauce.\n\nLocal specialties:\n• Soy sauce\n• Umeboshi (pickled plums)\n• Seafood\n\nMust-visit attractions:\n• Kumano Kodo trails\n• Nachi Falls\n• Koyasan\n\nMust-try food / local cuisine:\n• Umeboshi dishes\n• Kishu wagyu\n• Fresh seafood\n\nMust-buy souvenirs / local crafts:\n• Ume products\n• Soy sauce\n• Buddhist crafts\n\nFun fact / cultural quirk: Wakayama is famous for its spiritual Kumano pilgrimage trails, a UNESCO World Heritage site.",
          "img": "https://images.pexels.com/photos/2627089/pexels-photo-2627089.jpeg",
        },
        {
          "name": "Mie",
          "jp": "三重",
          "details": "Local specialties:\n• Ise Ebi (spiny lobster)\n• Akoya pearls\n• Fresh seafood\n\nMust-visit attractions:\n• Ise Grand Shrine\n• Meoto Iwa (Wedded Rocks)\n• Kumano Kodo pilgrimage trails\n\nMust-try food / local cuisine:\n• Ise Ebi dishes\n• Seafood donburi\n• Fresh oysters\n\nMust-buy souvenirs / traditional crafts:\n• Ise lacquerware  (exquisite handcrafted bowls and trays)\n• Wasanbon sugar art \n• Akoya pearls and pearl jewellery\n\nFun fact / cultural quirk: Ama divers are women who free-dive for pearls along the coast.",
          "img": "https://images.pexels.com/photos/31413003/pexels-photo-31413003.png",
        },
      ]
    },
    {
      "region": "Chugoku",
      "jp": "中国",
      "description": "Chugoku is a scenic region in western Honshu, known for its coastal beauty, historic towns, and unique cultural heritage. From the floating torii gate of Itsukushima to the castles and old merchant towns, Chugoku offers a blend of natural wonders and rich history.",
      "bgImg": "https://cdn.pixabay.com/photo/2022/10/24/12/20/mountains-7543273_1280.jpg",
      "prefectures": [
        {
          "name": "Tottori",
          "jp": "鳥取",
          "details": "Sand dunes, coastal views, and pear paradise.\n\nLocal specialties:\n• Nashi pears\n• Matsuba crab\n• Japanese horse mackerel (aji)\n\nMust-visit attractions:\n• Tottori Sand Dunes\n• Uradome Coast\n• Mizuki Shigeru Road\n\nMust-try food / local cuisine:\n• Crab dishes\n• Seafood donburi featuring aji, squid, and seasonal catch\n• Local sweets\n\nMust-buy souvenirs / local crafts:\n• Tottori pottery\n• Crab snacks\n• Nashi pear products\n\nFun fact / cultural quirk: Tottori is famous for Japan's largest sand dunes, offering camel rides and desert-like landscapes.",
          "img": "https://cdn.pixabay.com/photo/2021/03/11/02/57/mountain-6086083_1280.jpg",
        },
        {
          "name": "Shimane",
          "jp": "島根",
          "details": "Sacred shrines, nodoguro fish, and old myths.\n\nLocal specialties:\n• Nodoguro (blackthroat seaperch)\n• Matsuba crab\n• Coastal squid\n\nMust-visit attractions:\n• Izumo Taisha\n• Matsue Castle\n• Adachi Museum of Art\n\nMust-try food / local cuisine:\n• Seafood donburi\n• Izumo soba\n• Matsuba crab\n\nMust-buy souvenirs / local crafts:\n• Izumo Kura sake\n• Iwami silverwork \n• Seafood products\n\nFun fact / cultural quirk: Izumo Taisha is one of Japan's oldest Shinto shrines, famous for matchmaking rituals.",
          "img": "https://cdn.pixabay.com/photo/2015/11/07/05/22/castle-1030461_1280.jpg",
        },
        {
          "name": "Okayama",
          "jp": "岡山",
          "details": "Often called the \"Land of Sunshine\" with Korakuen Garden and Okayama Castle.\n\nLocal specialties:\n• Pears\n• White peaches\n• Muscat grapes\nMust-visit attractions:\n• Korakuen Garden\n• Okayama Castle\n• Kurashiki Bikan Historical Quarter\n\nMust-try food / local cuisine:\n• Fresh seasonal fruits (pears, peaches)\n• Bizen pottery-themed sweets\n• Fruit parfaits with local produce\n\nMust-buy souvenirs / local crafts:\n• Bizen pottery\n• Tea ceremony items\n• Local arts\n\nFun fact / cultural quirk: Pear orchards glow golden in autumn.",
          "img": "https://cdn.pixabay.com/photo/2018/06/09/11/45/okayama-3464213_1280.jpg",
        },
        {
          "name": "Hiroshima",
          "jp": "広島",
          "details": "A vibrant coastal city blending island scenery, garden beauty, and outstanding food culture. It is best known for Miyajima's iconic torii gate, fresh oysters, and Hiroshima-style okonomiyaki.\n\nLocal specialties:\n• Artisanal sake \n• Oysters\n• Hiroshima-style okonomiyaki\n\nMust-visit attractions:\n• Itsukushima Shrine \n• Hiroshima Castle\n• Shukkeien Garden\n\nMust-try food / local cuisine:\n• Hiroshima-style Okonomiyaki\n• Fresh grilled oysters\n• Momiji-manju\n\nMust-buy souvenirs / local crafts:\n• Taketsuru Sake\n• Local oyster products\n• Miyajima crafts\n\nFun fact / cultural quirk: The \"floating\" gate looks like it's floating on water.",
          "img": "https://cdn.pixabay.com/photo/2020/01/06/05/29/japan-4744614_1280.jpg",
        },
        {
          "name": "Yamaguchi",
          "jp": "山口",
          "details": "Historic sites and scenic coastal towns.\n\nLocal specialties:\n• Fugu (pufferfish)\n• Japanese sake (Dassai, Gangi, Sugihime)\n• Ceramics\n\nMust-visit attractions:\n• Ruriko-ji Temple\n• Tsuwano town\n• Akiyoshido Cave\n\nMust-try food / local cuisine:\n• Fugu sashimi or hotpot\n• Local sake tasting\n• Grilled seafood from the coast\n\nMust-buy souvenirs / local crafts:\n• Yamaguchi ceramics\n• Traditional textiles\n• Sake bottles (Dassai, Gangi, Sugihime)\n\nFun fact / cultural quirk: Yamaguchi is famous for fugu cuisine, a delicacy requiring licensed chefs due to its toxic nature.",
          "img": "https://cdn.pixabay.com/photo/2022/12/14/17/44/japan-7655927_1280.jpg",
        },
      ]
    },
    {
      "region": "Shikoku",
      "jp": "四国",
      "description": "Shikoku is Japan's smallest main island, known for its tranquil landscapes, coastal beauty, and deep spiritual heritage. The region is famed for its 88-temple pilgrimage, historic towns, and unique local cuisine that reflects both mountain and sea influences.",
      "bgImg": "https://cdn.pixabay.com/photo/2022/09/07/10/01/landscape-7438429_1280.jpg",
      "prefectures": [
        {
          "name": "Tokushima",
          "jp": "徳島",
          "details": "Home of the Awa Odori Festival and Naruto Strait.\n\nLocal specialties:\n• Tokushima ramen\n• Sudachi citrus\n• Naruto Kintoki sweet potatoes\n\nMust-visit attractions:\n• Awa Odori Festival (During Obon Season, every year August 12–15)\n• Naruto Strait\n• Iya Valley Vine Bridges\n\nMust-try food / local cuisine:\n• Tokushima ramen with pork and raw egg\n• Sweet potato desserts\n• Grilled Naruto Tai\n\nMust-buy souvenirs / local crafts:\n• Sweet potato snacks (candies, pastries)\n• Bottled local sake\n• Traditional crafts\n\nFun fact / cultural quirk: Dancers spin and jump in the Awa Odori.",
          "img": "https://cdn.pixabay.com/photo/2020/10/23/03/20/mountain-5677590_1280.jpg",
        },
        {
          "name": "Kagawa",
          "jp": "香川",
          "details": "Japan's smallest prefecture, famous for Sanuki udon.\n\nLocal specialties:\n• Sanuki udon\n• Olives\n• Olive oil\n\nMust-visit attractions:\n• Ritsurin Garden\n• Kotohira Shrine\n• Shikoku Mura\n\nMust-try food / local cuisine:\n• Sanuki udon \n• Olive-based dishes\n• Tempura\n\nMust-buy souvenirs / local crafts:\n• Olive oil\n• Pottery\n• Udon souvenirs\n\nFun fact / cultural quirk: Kagawa is famous as Japan's \"Udon Prefecture,\" with udon restaurants serving noodles in unique regional styles.",
          "img": "https://cdn.pixabay.com/photo/2020/10/23/03/20/mountain-5677590_1280.jpg",
        },
        {
          "name": "Ehime",
          "jp": "愛媛",
          "details": "Sunny orchards with Mikan oranges and citrus products.\n\nLocal specialties:\n• Mikan oranges\n• Citrus sweets\n• Citrus-flavoured snacks\n\nMust-visit attractions:\n• Matsuyama Castle\n• Dogo Onsen\n• Shimanami Kaido \n\nMust-try food / local cuisine:\n• Citrus desserts (cakes, jellies)\n• Local sweet snacks\n• Citrus-flavoured drinks\n\nMust-buy souvenirs / local crafts:\n• Mikan products\n• Paper crafts\n• Folk art\n\nFun fact / cultural quirk: Ehime locals love their citrus so much that there's even a \"Citrus Museum\" in Saijo, celebrating all things orange!",
          "img": "https://cdn.pixabay.com/photo/2022/10/24/14/04/mountains-7543535_1280.jpg",
        },
        {
          "name": "Kochi",
          "jp": "高知",
          "details": "Rugged coastlines, mountains, and fresh seafood.\n\nLocal specialties:\n• Katsuo (bonito)\n• Yuzu\n• Seafood\n\nMust-visit attractions:\n• Katsurahama Beach\n• Shimanto River\n• Kochi Castle\n\nMust-try food / local cuisine:\n• Bonito tataki (seared bonito)\n• Yuzu-flavoured dishes\n• Fresh grilled seafood\n\nMust-buy souvenirs / local crafts:\n• Yuzu products \n• Handmade knives, pottery\n• Bonito flakes\n\nFun fact / cultural quirk: Kochi is home to Japan's largest yuzu production and is known for its lively Sunday market in Kochi City.",
          "img": "https://cdn.pixabay.com/photo/2021/08/11/11/16/fishing-nets-6538206_1280.jpg",
        },
      ]
    },
    {
      "region": "Kyushu",
      "jp": "九州",
      "description": "Kyushu is Japan's southern gateway, known for its volcanic landscapes, hot springs, rich culinary heritage, and historical connections to international trade. From steaming onsen towns to subtropical islands, Kyushu offers dramatic scenery and deeply rooted traditions shaped by both nature and global influence.",
      "bgImg": "https://cdn.pixabay.com/photo/2015/02/15/03/04/japanese-umbrellas-636870_1280.jpg",
      "prefectures": [
        {
          "name": "Fukuoka",
          "jp": "福岡",
          "details": "Kyushu gateway, famous for Hakata ramen and seafood.\n\nLocal specialties:\n• Hakata ramen\n• Mentaiko \n• Premium sake (Asahigiku)\n\nMust-visit attractions:\n• Ohori Park\n• Fukuoka Tower\n• Dazaifu Tenmangu Shrine\n\nMust-try food / local cuisine:\n• Hakata tonkotsu ramen\n• Yakitori\n• Mentaiko \n\nMust-buy souvenirs / local crafts:\n• Bottled sake (Gokujo Kitaya Daiginjo, Junmai, Nigori)\n• Seafood snacks (dried squid, mentaiko)\n• Local sweets\n\nFun fact / cultural quirk: Fukuoka is famous for its open-air yatai (street food stalls), offering an intimate and lively dining culture unique in Japan.",
          "img": "https://cdn.pixabay.com/photo/2021/10/09/07/06/natural-6693234_1280.jpg",
        },
        {
          "name": "Saga",
          "jp": "佐賀",
          "details": "Famous for Arita and Imari porcelain and seafood.\n\nLocal specialties:\n• Yobuko squid\n• Takezaki crab\n• Saga Beef\n\nMust-visit attractions:\n• Arita Porcelain Park\n• Karatsu Castle\n• Yoshinogari Historical Park\n\nMust-try food / local cuisine:\n• Squid dishes (sashimi or grilled)\n• Crab dishes \n• Saga beef steak\n\nMust-buy souvenirs / local crafts:\n• Porcelain (Arita, Imari)\n• Rice products (mochi, sake)\n• Handcrafted bowls or plates\n\nFun fact / cultural quirk: Holds massive Saga International Balloon Fiesta annually, featuring over 100 hot air balloons, and houses Japan's first dedicated hot air balloon museum",
          "img": "https://cdn.pixabay.com/photo/2021/01/23/00/22/autumn-5941506_1280.jpg",
        },
        {
          "name": "Nagasaki",
          "jp": "長崎",
          "details": "Historic port with Castella cake and fusion cuisine.\n\nLocal specialties:\n• Castella sponge cake\n• Harbour prawns\n• Champon noodles\n\nMust-visit attractions:\n• Glover Garden\n• Dejima\n• Oura Church\n\nMust-try food / local cuisine:\n• Champon noodles\n• Sara udon\n• Grilled seafood (prawns, mackerel, squid)\n\nMust-buy souvenirs / local crafts:\n• Castella sponge cake\n• Local crafts (miniature houses, Dutch-style goods)\n• Seafood snacks (dried squid, mackerel)\n\nFun fact / cultural quirk: Nagasaki was Japan's only international trading port during the Edo period, resulting in strong European and Chinese cultural influences.",
          "img": "https://cdn.pixabay.com/photo/2015/04/16/15/21/island-725792_1280.jpg",
        },
        {
          "name": "Kumamoto",
          "jp": "熊本",
          "details": "Famous for Kumamoto Castle and scenic landscapes.\n\nLocal specialties:\n• Kumamoto ramen\n• Kumamoto-ken pork\n• Local agricultural products\n\nMust-visit attractions:\n• Kumamoto Castle\n• Mount Aso\n• Suizenji Garden\n\nMust-try food / local cuisine:\n• Kumamoto ramen\n• Basashi\n• Ikinari Dango\n\nMust-buy souvenirs / local crafts:\n• Pottery (Mashiko, local styles)\n• Traditional crafts\n• Local sweets\n\nFun fact / cultural quirk: Kumamoto is the hometown of Eiichiro Oda, and statues of his famous One Piece characters are displayed throughout the prefecture.",
          "img": "https://cdn.pixabay.com/photo/2013/12/10/05/38/aso-226338_1280.jpg",
        },
        {
          "name": "Oita",
          "jp": "大分",
          "details": "Hot springs (onsen) and scenic relaxation.\n\nLocal specialties:\n• Bungo beef\n• Fresh seafood (fish, crab)\n• Onsen steamed buns (manju)\n\nMust-visit attractions:\n• Beppu Onsen\n• Yufuin\n• Hells of Beppu \n\nMust-try food / local cuisine:\n• Bungo beef steak or hotpot\n• Seafood dishes (grilled or sashimi)\n• Onsen-steamed manju\n\nMust-buy souvenirs / local crafts:\n• Wooden crafts\n• Local ceramics\n• Onsen bath products\n\nFun fact / cultural quirk: Oita has the highest volume of natural hot spring water in Japan, making it the country's onsen capital.",
          "img": "https://cdn.pixabay.com/photo/2020/08/28/13/15/river-5524569_1280.jpg",
        },
        {
          "name": "Miyazaki",
          "jp": "宮崎",
          "details": "Sun-drenched coastlines with beef, mangoes, and fruits.\n\nLocal specialties:\n• Miyazaki beef\n• Mangoes\n• Chicken nanban\n\nMust-visit attractions:\n• Aoshima Island\n• Takachiho Gorge\n• Udo Shrine\n\nMust-try food / local cuisine:\n• Miyazaki beef dishes (steak, sukiyaki)\n• Chicken nanban\n• Mango juice or parfaits\n\nMust-buy souvenirs / local crafts:\n• Woven crafts\n• Pottery\n• Packaged fruit products (candies, jams)\n\nFun fact / cultural quirk: Miyazaki is famously known as the \"birthplace of Japanese mythology,\" where gods are said to have descended to earth.",
          "img": "https://cdn.pixabay.com/photo/2017/07/04/07/29/miyazaki-2470212_1280.jpg",
        },
        {
          "name": "Kagoshima",
          "jp": "鹿児島",
          "details": "Volcanic landscapes with Kurobuta pork and plum liqueur.\n\nLocal specialties:\n• Kurobuta pork\n• Sweet potatoes\n• Kagoshima Shochu \n\nMust-visit attractions:\n• Sakurajima\n• Sengan-en Garden\n• Ibusuki Sand Baths\n\nMust-try food / local cuisine:\n• Grilled Kurobuta pork\n• Fresh seafood dishes\n• Shochu-based cocktails\n\nMust-buy souvenirs / local crafts:\n• Bottled umeshu\n• Folk crafts\n• Shochu\n\nFun fact / cultural quirk: Sakurajima is one of Japan's most active volcanoes and is a defining symbol of Kagoshima's landscape.",
          "img": "https://cdn.pixabay.com/photo/2017/03/21/19/08/ship-2163005_1280.jpg",
        },
        {
          "name": "Okinawa",
          "jp": "沖縄",
          "details": "Subtropical paradise with unique food and crafts.\n\nLocal specialties:\n• Okinawan soba\n• Tropical fruits (pineapple, mango, papaya)\n• Rafute (braised pork belly)\n\nMust-visit attractions:\n• Shurijo Castle\n• Churaumi Aquarium\n• Kokusai Street (Naha)\n\nMust-try food / local cuisine:\n• Okinawan soba\n• Tropical fruit desserts\n• Rafute \n\nMust-buy souvenirs / local crafts:\n• Ryukyu textiles \n• Shisa \n• Traditional crafts\n\nFun fact / cultural quirk: Okinawa is the birthplace of karate, home to one of the world's highest centenarian populations.",
          "img": "https://cdn.pixabay.com/photo/2015/02/15/03/04/japanese-umbrellas-636870_1280.jpg",
        },
      ]
    },
  ];

@override
void initState() {
  super.initState();
  // We use addPostFrameCallback to ensure the UI is rendered 
  // before we start the animation timer
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _startTeaser();
  });
}

void _startTeaser() async {
  if (!mounted) return;
  
  // Wait a moment for the tab transition to finish
  await Future.delayed(const Duration(milliseconds: 300));
  if (mounted) setState(() => _triggerTeaser = true);
  
  // Keep it flipped for 2 seconds
  await Future.delayed(const Duration(seconds: 1));
  
  // Flip it back
  if (mounted) setState(() => _triggerTeaser = false);
}

  void _showFullDetailModal(String title, String content, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: VxBox(
            child: VStack([
              HStack([
                title.text.color(gold).xl3.bold.make().expand(),
                Icon(Icons.close, color: gold, size: 28).onTap(() => Navigator.pop(context)),
              ]),
              20.heightBox,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: content.text.white.lg.lineHeight(1.5).make(),
                ),
              ),
              20.heightBox,
              Center(child: "The Golden Journey".text.color(gold).italic.make()),
            ]).p24(),
          )
          .color(const Color(0xFF1A1A1A))
          .roundedLg
          .border(color: gold, width: 2)
          .width(context.screenWidth * 0.9)
          .height(context.screenHeight * 0.7)
          .make(),
        ),
      ),
    ).then((_) {
      if (onDismiss != null) onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VStack([
        // --- BANNER SECTION ---
        TweenAnimationBuilder(
          key: ValueKey('banner_$_activeRegionIndex'),
          duration: const Duration(milliseconds: 800),
          // Reacts to both manual flips and the auto-teaser flip
          tween: Tween<double>(begin: 0, end: (_isBannerFlipped || _triggerTeaser) ? 180 : 0),
          builder: (context, double value, child) {
            final region = _regionData[_activeRegionIndex];
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * pi / 180),
              child: value < 90 
                ? _buildBannerFront() 
                : _buildBannerBackMirrored(region),
            );
          },
        ).h(260),

        20.heightBox,

        // --- PREFECTURE GRID ---
        GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.78,
          ),
          itemCount: _regionData[_activeRegionIndex]['prefectures'].length,
          itemBuilder: (context, index) => FlipPrefectureCard(
            key: ValueKey("${_regionData[_activeRegionIndex]['region']}_$index"), 
            data: _regionData[_activeRegionIndex]['prefectures'][index],
            gold: gold, red: red, 
            isTeasing: _triggerTeaser, // Pass the teaser state here
            onEnlarge: (title, detail, callback) => _showFullDetailModal(title, detail, onDismiss: callback),
          ),
        ).expand(),
      ]),
    );
  }

  Widget _buildBannerFront() {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _regionData.length,
          options: CarouselOptions(
            height: 260,
            viewportFraction: 1.0,
            initialPage: _activeRegionIndex,
            onPageChanged: (index, reason) {
              setState(() { 
                _activeRegionIndex = index; 
                _isBannerFlipped = false; 
                // Re-trigger the teaser when the region is changed manually
                // _startTeaser(); 
              });
            },
          ),
          itemBuilder: (context, index, realIndex) => Stack(
            alignment: Alignment.bottomLeft,
            children: [
              VxBox().bgImage(DecorationImage(image: NetworkImage(_regionData[index]['bgImg']), fit: BoxFit.cover)).make(),
              VxBox().withGradient(LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent])).make(),
              VStack([
                _regionData[index]['region'].toString().text.white.xl3.bold.make(),
                _regionData[index]['jp'].toString().text.color(gold).lg.make(),
              ]).p24(),
            ],
          ).onTap(() => setState(() => _isBannerFlipped = true)),
        ),
        
        HStack([
          Icon(Icons.chevron_left, color: Colors.white70, size: 45).onTap(() => _carouselController.previousPage()),
          Icon(Icons.chevron_right, color: Colors.white70, size: 45).onTap(() => _carouselController.nextPage()),
        ], alignment: MainAxisAlignment.spaceBetween).w(context.screenWidth).px12().centered().h(260),
      ],
    );
  }

  Widget _buildBannerBackMirrored(Map<String, dynamic> region) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: VxBox(
        child: VStack([
          HStack([
            "About ${region['region']}".text.color(gold).xl2.bold.make().expand(),
            Icon(Icons.close, color: gold).onTap(() => setState(() => _isBannerFlipped = false)),
          ]),
          20.heightBox,
          region['description'].toString().text.white.lg.maxLines(3).ellipsis.make(),
          const Spacer(),
          Center(
            child: Icon(Icons.open_in_full, color: gold, size: 28)
                .box.color(Colors.black.withOpacity(0.5)).roundedFull.p12.make()
                .onTap(() => _showFullDetailModal(region['region'], region['description'], onDismiss: () {
                  setState(() => _isBannerFlipped = false);
                })),
          ),
          10.heightBox,
          Center(child: "Auto-flipping...".text.gray500.xs.make()),
        ]).p24(),
      ).color(const Color(0xFF121212)).border(color: gold.withOpacity(0.3)).make().onTap(() => setState(() => _isBannerFlipped = false)),
    );
  }
}

class FlipPrefectureCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final Color gold;
  final Color red;
  final bool isTeasing;
  final Function(String, String, VoidCallback) onEnlarge;

  const FlipPrefectureCard({super.key, required this.data, required this.gold, required this.red, required this.onEnlarge, this.isTeasing = false});
  @override
  State<FlipPrefectureCard> createState() => _FlipPrefectureCardState();
}

class _FlipPrefectureCardState extends State<FlipPrefectureCard> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      // Uses either manual flip or the parent's teaser state
      tween: Tween<double>(begin: 0, end: (_isFlipped || widget.isTeasing) ? 180 : 0),
      builder: (context, double value, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * pi / 180),
          child: value < 90 ? _buildFront() : _buildBackMirrored(),
        );
      },
    );
  }

  Widget _buildFront() {
    return VxBox(
      child: VStack([
        const Spacer(),
        widget.data['name'].toString().text.white.bold.lg.make(),
        widget.data['jp'].toString().text.color(widget.gold).sm.make(),
      ]).p12(),
    ).bgImage(DecorationImage(image: NetworkImage(widget.data['img']), fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken))).roundedLg.border(color: Colors.white10).make().onTap(() => setState(() => _isFlipped = true));
  }

  Widget _buildBackMirrored() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: VxBox(
        child: VStack([
          HStack([
            widget.data['name'].toString().text.color(widget.gold).bold.lg.make().expand(), 
            Icon(Icons.close, color: widget.gold, size: 18).onTap(() => setState(() => _isFlipped = false))
          ]),
          8.heightBox,
          widget.data['details'].toString().text.white.sm.maxLines(3).ellipsis.make(),
          const Spacer(),
          Center(child: Icon(Icons.open_in_full, color: widget.gold, size: 24).p8().onTap(() {
            widget.onEnlarge(widget.data['name'], widget.data['details'], () {
              if (mounted) setState(() => _isFlipped = false);
            });
          })),
        ]).p12(),
      ).color(const Color(0xFF1A1A1A)).roundedLg.border(color: widget.red.withOpacity(0.4), width: 1).make().onTap(() => setState(() => _isFlipped = false)),
    );
  }
}