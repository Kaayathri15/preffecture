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
      "description": "Hokkaidō, Japan’s northernmost island, is famous for its snowy winters, mild summers, and vast unspoiled landscapes. Skiers and snowboarders flock to resorts in Niseko and Furano, while nature lovers explore Shiretoko National Park and the flower fields of Biei. The region is renowned for Sapporo Beer and Royce’ chocolate, alongside fresh seafood and creamy dairy products. Hot springs, rural charm, and vibrant seasonal festivals make it a year-round adventure destination. Hokkaidō’s combination of outdoor thrills and culinary delights is truly one-of-a-kind.",
      "bgImg": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "prefectures": [
        {
          "name": "Hokkaido", 
          "jp": "札幌", 
          "details": "Japan’s northern frontier known for powdery winter snow, world-class skiing, and exceptionally fresh dairy and seafood shaped by its cool climate and vast natural landscapes. [cite: 306, 307] \n\nLocal specialties:\n•⁠  Dairy products, crab, salmon, soup curry [cite: 309]\n\nMust-visit attractions:\n•⁠  Sapporo Snow Festival, Otaru Canal, Furano flower fields [cite: 310]\n\nMust-try food / local cuisine:\n•⁠  Jingisukan (grilled mutton), Hokkaido ramen, fresh sushi [cite: 311]\n\nMust-buy souvenirs / local crafts:\n•⁠  Shiroi Koibito cookies, lavender products, seafood preserves [cite: 312]\n\nFun fact / cultural quirk: Hokkaido is famous for its snow festivals and large-scale outdoor winter events, attracting visitors worldwide. [cite: 313]", 
          "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
        },
      ]
    },
    {
      "region": "Tohoku",
      "jp": "東北",
      "description": "The scenic northeastern region of Honshu, known for its rugged mountains, hot springs, and vibrant traditional festivals. [cite: 315] Less crowded than central Japan, it is rich in cultural heritage and seasonal beauty. [cite: 316]",
      "bgImg": "TOHOKU_BG_IMAGE_URL",
      "prefectures": [
        {
          "name": "Aomori",
          "jp": "青森",
          "details": "Home of the Nebuta Festival, a spectacular summer parade with giant illuminated floats. [cite: 322] \n\nLocal specialties:\n•⁠  Apples, scallops, dried squid [cite: 318]\n\nMust-visit attractions:\n•⁠  Hirosaki Castle, Nebuta Museum, Lake Towada [cite: 319]\n\nMust-try food:\n•⁠  Senbei-jiru, Ichigoni [cite: 320]\n\nMust-buy souvenirs:\n•⁠  Hirosaki apples, Tsugaru lacquerware, kokeshi dolls [cite: 321]",
          "img": "AOMORI_IMAGE_URL",
        },
        {
          "name": "Iwate",
          "jp": "岩手",
          "details": "Known for its rugged nature and historic temples that survived centuries of history. [cite: 328] \n\nLocal specialties:\n•⁠  Wanko soba, beef, sea urchin [cite: 324]\n\nMust-visit attractions:\n•⁠  Chuson-ji Temple, Kitakami Tenshochi Park, Geibikei Gorge [cite: 325]\n\nMust-try food:\n•⁠  Wanko soba, Hittsumi [cite: 326]\n\nMust-buy souvenirs:\n•⁠  Nambu ironware, handcrafted wooden items, local sake [cite: 327]",
          "img": "IWATE_IMAGE_URL",
        },
        {
          "name": "Miyagi",
          "jp": "宮城",
          "details": "Matsushima Bay is celebrated as one of Japan’s three most scenic views. [cite: 334] \n\nLocal specialties:\n•⁠  Seafood, zunda, beef [cite: 330]\n\nMust-visit attractions:\n•⁠  Matsushima Bay, Sendai Castle, Zuigan-ji Temple [cite: 331]\n\nMust-try food:\n•⁠  Gyutan, fresh sushi, zunda mochi [cite: 332]\n\nMust-buy souvenirs:\n•⁠  Zunda sweets, Sendai lacquerware, local sake [cite: 333]",
          "img": "MIYAGI_IMAGE_URL",
        },
        {
          "name": "Akita",
          "jp": "秋田",
          "details": "Famous for its Namahage ritual during New Year, where men dress as ogres to scare children into good behavior. [cite: 340] \n\nLocal specialties:\n•⁠  Rice, sake, kiritanpo [cite: 336]\n\nMust-visit attractions:\n•⁠  Kakunodate Samurai District, Lake Tazawa, Akita Museum of Art [cite: 337]\n\nMust-try food:\n•⁠  Kiritanpo, Inaniwa udon, Hatahata fish dishes [cite: 338]\n\nMust-buy souvenirs:\n•⁠  Akita kiritanpo, local sake, handcrafted dolls [cite: 339]",
          "img": "AKITA_IMAGE_URL",
        },
        {
          "name": "Yamagata",
          "jp": "山形",
          "details": "Hosts the impressive Hanagasa Festival, where dancers parade with flower-adorned hats. [cite: 346] \n\nLocal specialties:\n•⁠  Cherries, soba, peaches [cite: 342]\n\nMust-visit attractions:\n•⁠  Yamadera Temple, Ginzan Onsen, Mount Zao [cite: 343]\n\nMust-try food:\n•⁠  Imoni, Yonezawa beef, soba noodles [cite: 344]\n\nMust-buy souvenirs:\n•⁠  Cherry products, Yamagata silk, local sake [cite: 345]",
          "img": "YAMAGATA_IMAGE_URL",
        },
        {
          "name": "Fukushima",
          "jp": "福島",
          "details": "Known as the “Fruit Kingdom” of Japan, producing some of the country’s finest peaches and grapes. [cite: 352] \n\nLocal specialties:\n•⁠  Fruits (peaches, grapes), sake, ramen [cite: 348]\n\nMust-visit attractions:\n•⁠  Aizuwakamatsu Castle, Ouchi-juku, Goshikinuma Ponds [cite: 349]\n\nMust-try food:\n•⁠  Kitakata ramen, Fukushima fruit parfait, Aizu miso dishes [cite: 350]\n\nMust-buy souvenirs:\n•⁠  Local sake, Aizu lacquerware, traditional sweets [cite: 351]",
          "img": "FUKUSHIMA_IMAGE_URL",
        },
      ]
    },
    {
      "region": "Kantō",
      "jp": "関東",
      "description": "The economic and political heart of Japan. From the neon lights of Tokyo to the coastal vibes of Yokohama, this region defines modern Japan.",
      "bgImg": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
      "prefectures": [
        {
          "name": "Tokyo", 
          "jp": "東京", 
          "details": "The ultra-modern heart of Japan where skyscrapers meet ancient shrines. A city that never sleeps and offers endless exploration. [cite: 361] \n\nLocal specialties:\n•⁠  Edo-style sweets, soy sauce, monjayaki [cite: 357]\n\nMust-visit attractions:\n•⁠  Tokyo Tower, Meiji Shrine, Asakusa Senso-ji, Shibuya Crossing [cite: 358]\n\nMust-try food:\n•⁠  Sushi, tempura, ramen, monjayaki [cite: 359]\n\nMust-buy souvenirs:\n•⁠  Tokyo Banana, character merchandise, traditional Edo crafts [cite: 360]", 
          "img": "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
        },
        {
          "name": "Kanagawa",
          "jp": "神奈川",
          "details": "Famous for its coastal beauty and hot springs, attracting both tourists and locals seeking relaxation near Tokyo. [cite: 367] \n\nLocal specialties:\n•⁠  Shirasu, seafood, Yokohama ramen [cite: 363]\n\nMust-visit attractions:\n•⁠  Yokohama Chinatown, Hakone hot springs, Kamakura’s Great Buddha [cite: 364]\n\nMust-try food:\n•⁠  Shirasu-don, Yokohama ramen, seafood [cite: 365]\n\nMust-buy souvenirs:\n•⁠  Kamakura wooden crafts, Hakone yosegi marquetry, local sweets [cite: 366]",
          "img": "https://images.pexels.com/photos/30091614/pexels-photo-30091614.jpeg",
        },
        {
          "name": "Chiba",
          "jp": "千葉",
          "details": "Tokyo’s gateway, hosting the country’s busiest airport. [cite: 373] \n\nLocal specialties:\n•⁠  Peanuts, seafood, neri kamaboko [cite: 369]\n\nMust-visit attractions:\n•⁠  Naritasan Shinshoji Temple, Tokyo Disneyland [cite: 370]\n\nMust-try food:\n•⁠  Neri kamaboko, peanuts-based snacks, seafood bowls [cite: 371]\n\nMust-buy souvenirs:\n•⁠  Narita rice crackers, local sake, themed Disney merchandise [cite: 372]",
          "img": "https://images.pexels.com/photos/5236398/pexels-photo-5236398.jpeg",
        },
        {
          "name": "Saitama",
          "jp": "埼玉",
          "details": "Home to Japan’s only dedicated bonsai village, where enthusiasts can explore centuries-old bonsai artistry. [cite: 379] \n\nLocal specialties:\n•⁠  Unagi, sweet potatoes, wheat-based noodles [cite: 375]\n\nMust-visit attractions:\n•⁠  Omiya Bonsai Village, Chichibu Night Festival, Hitsujiyama Park [cite: 376]\n\nMust-try food:\n•⁠  Unagi kabayaki, miso-dressed soba noodles, sweet potato snacks [cite: 377]\n\nMust-buy souvenirs:\n•⁠  Bonsai trees and tools, local snacks, regional crafts [cite: 378]",
          "img": "https://images.pexels.com/photos/24771664/pexels-photo-24771664.jpeg",
        },
        {
          "name": "Gunma",
          "jp": "群馬",
          "details": "Famous for its hot springs, many of which are said to have therapeutic properties. [cite: 385] \n\nLocal specialties:\n•⁠  Konjac, yaki-manju, onsen eggs [cite: 381]\n\nMust-visit attractions:\n•⁠  Kusatsu Onsen, Mount Haruna, Ikaho Onsen [cite: 382]\n\nMust-try food:\n•⁠  Joshu beef, onsen tamago, miso-dressed konjac dishes [cite: 383]\n\nMust-buy souvenirs:\n•⁠  Ikaho stone items, onsen soaps, local sweets [cite: 384]",
          "img": "https://images.pexels.com/photos/13443329/pexels-photo-13443329.jpeg",
        },
        {
          "name": "Ibaraki",
          "jp": "茨城",
          "details": "Kairakuen is considered one of Japan’s three most beautiful gardens, particularly famous for its plum blossoms. [cite: 391] \n\nLocal specialties:\n•⁠  Natto, lotus root, melons [cite: 387]\n\nMust-visit attractions:\n•⁠  Kairakuen Garden, Hitachi Seaside Park, Fukuroda Falls [cite: 388]\n\nMust-try food:\n•⁠  Natto rice bowls, tempura, melon desserts [cite: 389]\n\nMust-buy souvenirs:\n•⁠  Natto products, melon sweets, local crafts [cite: 390]",
          "img": "https://images.pexels.com/photos/34885502/pexels-photo-34885502.jpeg",
        },
        {
          "name": "Tochigi",
          "jp": "栃木",
          "details": "The Nikko area is steeped in history, home to lavish shrines set amidst ancient cedar forests. [cite: 397] \n\nLocal specialties:\n•⁠  Strawberries, yuba, soba [cite: 393]\n\nMust-visit attractions:\n•⁠  Nikko Toshogu Shrine, Ashikaga Flower Park, Nasu Highland [cite: 394]\n\nMust-try food:\n•⁠  Yuba dishes, Tochigi strawberries, soba noodles [cite: 395]\n\nMust-buy souvenirs:\n•⁠  Local sake, yuba snacks, handcrafted souvenirs [cite: 396]",
          "img": "https://images.pexels.com/photos/28954739/pexels-photo-28954739.jpeg",
        },
      ]
    },
    {
      "region": "Chubu",
      "jp": "中部",
      "description": "The heart of Japan’s main island, home to Mount Fuji and the Japanese Alps. [cite: 399, 400] It is a region rich in natural beauty, traditional crafts, and regional cuisine. [cite: 400]",
      "bgImg": "https://pixabay.com/get/g55769939b06e9740d9d321fcbce210d8c13c777c1961f8895e0a475e3b96e707edb1d5d6a8d294d2dcea1d01418fceb0d92ccf8ba85ec7b7b613c7bf26867dcc_1920.jpg",
      "prefectures": [
        {
          "name": "Niigata",
          "jp": "新潟",
          "details": "Known as Japan’s rice capital and produces some of the finest sake in the country. [cite: 406] \n\nLocal specialties:\n•⁠  Koshihikari rice, sake, seafood [cite: 402]\n\nMust-visit attractions:\n•⁠  Sado Island, Yahiko Shrine, Niigata City Bandai Bridge [cite: 403]\n\nMust-try food:\n•⁠  Fresh seafood rice bowls, hegi soba, sake-infused dishes [cite: 404]\n\nMust-buy souvenirs:\n•⁠  Niigata sake, rice crackers, local crafts [cite: 405]",
          "img": "https://images.pexels.com/photos/15830265/pexels-photo-15830265.jpeg",
        },
        {
          "name": "Toyama",
          "jp": "富山",
          "details": "The Tateyama Kurobe Alpine Route offers dramatic mountain scenery, including Japan’s tallest dam. [cite: 412] \n\nLocal specialties:\n•⁠  Firefly squid, yellowtail, medicinal herbs [cite: 408]\n\nMust-visit attractions:\n•⁠  Tateyama Kurobe Alpine Route, Toyama Glass Art Museum [cite: 409]\n\nMust-try food:\n•⁠  Firefly squid sashimi, yellowtail dishes, Toyama sushi [cite: 410]\n\nMust-buy souvenirs:\n•⁠  Glassware, local seafood preserves, medicinal herbs [cite: 411]",
          "img": "https://images.pexels.com/photos/4151484/pexels-photo-4151484.jpeg",
        },
        {
          "name": "Ishikawa",
          "jp": "石川",
          "details": "Renowned for its preserved Edo-era districts and exquisite gold leaf art. [cite: 418] \n\nLocal specialties:\n•⁠  Seafood, gold leaf products, Kaga vegetables [cite: 414]\n\nMust-visit attractions:\n•⁠  Kenroku-en Garden, Kanazawa Castle, Noto Peninsula [cite: 415]\n\nMust-try food:\n•⁠  Kaisendon, Kaga ryori, Jibuni [cite: 416]\n\nMust-buy souvenirs:\n•⁠  Gold leaf items, Kanazawa crafts, local sweets [cite: 417]",
          "img": "https://images.pexels.com/photos/4026905/pexels-photo-4026905.jpeg",
        },
        {
          "name": "Fukui",
          "jp": "福井",
          "details": "Home to Japan’s most famous dinosaur museum, reflecting its rich fossil history. [cite: 424] \n\nLocal specialties:\n•⁠  Echizen crab, yōkan, rice [cite: 420]\n\nMust-visit attractions:\n•⁠  Eiheiji Temple, Tojinbo Cliffs, Fukui Dinosaur Museum [cite: 421]\n\nMust-try food:\n•⁠  Echizen crab, oroshi soba, seafood hot pot [cite: 422]\n\nMust-buy souvenirs:\n•⁠  Dinosaur-themed items, Echizen lacquerware, local sweets [cite: 423]",
          "img": "https://images.pexels.com/photos/3625115/pexels-photo-3625115.jpeg",
        },
        {
          "name": "Yamanashi",
          "jp": "山梨",
          "details": "Considered the gateway to Mount Fuji, offering some of the best views of the iconic peak. [cite: 430] \n\nLocal specialties:\n•⁠  Grapes, peaches, wine [cite: 426]\n\nMust-visit attractions:\n•⁠  Mount Fuji views from Lake Kawaguchi, Shosenkyo Gorge [cite: 427]\n\nMust-try food:\n•⁠  Hoto noodles, fruit parfaits, wine-infused dishes [cite: 428]\n\nMust-buy souvenirs:\n•⁠  Wine, fruit jams, local crafts [cite: 429]",
          "img": "https://images.pexels.com/photos/15924876/pexels-photo-15924876.jpeg",
        },
        {
          "name": "Nagano",
          "jp": "長野",
          "details": "Famous for its snow monkeys that bathe in natural hot springs during winter. [cite: 436] \n\nLocal specialties:\n•⁠  Apples, soba, Matsumoto miso [cite: 432]\n\nMust-visit attractions:\n•⁠  Zenko-ji Temple, Jigokudani Monkey Park, Matsumoto Castle [cite: 433]\n\nMust-try food:\n•⁠  Soba noodles, oyaki dumplings, Shinshu miso dishes [cite: 434]\n\nMust-buy souvenirs:\n•⁠  Local miso, wooden crafts, soba flour [cite: 435]",
          "img": "https://images.pexels.com/photos/5759903/pexels-photo-5759903.jpeg",
        },
        {
          "name": "Gifu",
          "jp": "岐阜",
          "details": "Shirakawa-go features iconic gassho-zukuri farmhouses with steep thatched roofs designed for heavy snow. [cite: 442] \n\nLocal specialties:\n•⁠  Hida beef, sake, persimmons [cite: 438]\n\nMust-visit attractions:\n•⁠  Shirakawa-go, Takayama Old Town, Gifu Castle [cite: 439]\n\nMust-try food:\n•⁠  Hida beef steak, Gohei-mochi, soba noodles [cite: 440]\n\nMust-buy souvenirs:\n•⁠  Hida woodcraft, Takayama sake, traditional crafts [cite: 441]",
          "img": "https://images.pexels.com/photos/2187603/pexels-photo-2187603.jpeg",
        },
        {
          "name": "Shizuoka",
          "jp": "静岡",
          "details": "Produces about 40% of Japan’s green tea and offers breathtaking views of Mount Fuji. [cite: 448] \n\nLocal specialties:\n•⁠  Green tea, wasabi, seafood [cite: 444]\n\nMust-visit attractions:\n•⁠  Mount Fuji, Miho no Matsubara, Izu Peninsula [cite: 445]\n\nMust-try food:\n•⁠  Unagi, fresh sushi, wasabi-infused dishes [cite: 446]\n\nMust-buy souvenirs:\n•⁠  Shizuoka green tea, wasabi products, local sweets [cite: 447]",
          "img": "https://images.pexels.com/photos/3995905/pexels-photo-3995905.jpeg",
        },
        {
          "name": "Aichi",
          "jp": "愛知",
          "details": "Industrial and automotive hub of Japan, home to Toyota’s headquarters. [cite: 454] \n\nLocal specialties:\n•⁠  Nagoya miso, hitsumabushi, chicken wings [cite: 450]\n\nMust-visit attractions:\n•⁠  Nagoya Castle, Atsuta Shrine, Toyota Museum [cite: 451]\n\nMust-try food:\n•⁠  Miso katsu, hitsumabushi, Nagoya tebasaki [cite: 452]\n\nMust-buy souvenirs:\n•⁠  Local sweets, miso products, crafts from Nagoya [cite: 453]",
          "img": "https://images.pexels.com/photos/634009/pexels-photo-634009.jpeg",
        },
      ]
    },
    {
      "region": "Kansai",
      "jp": "関西",
      "description": "Japan’s cultural heart, known for its rich history, traditional architecture, and vibrant culinary scene. [cite: 456] It blends historic temples and castles with bustling city life and lively street culture. [cite: 457]",
      "bgImg": "https://cdn.pixabay.com/photo/2016/11/07/14/03/japan-1805865_1280.jpg",
      "prefectures": [
        {
          "name": "Osaka",
          "jp": "大阪",
          "details": "Residents are known for their humor and friendly nature, making the city lively and approachable. [cite: 463] \n\nLocal specialties:\n•⁠  Takoyaki, okonomiyaki, kushikatsu [cite: 459]\n\nMust-visit attractions:\n•⁠  Osaka Castle, Dotonbori, Universal Studios Japan [cite: 460]\n\nMust-try food:\n•⁠  Takoyaki, okonomiyaki, fresh sushi, kushikatsu [cite: 461]\n\nMust-buy souvenirs:\n•⁠  Osaka sweets, local snacks, character merchandise [cite: 462]",
          "img": "https://images.pexels.com/photos/356269/pexels-photo-356269.jpeg",
        },
        {
          "name": "Kyoto",
          "jp": "京都",
          "details": "Home to over 1,000 temples, preserving centuries of Japanese tradition and culture. [cite: 469] \n\nLocal specialties:\n•⁠  Matcha, yatsuhashi, kyo-kaiseki cuisine [cite: 465]\n\nMust-visit attractions:\n•⁠  Kinkaku-ji, Fushimi Inari Shrine, Arashiyama Bamboo Grove [cite: 466]\n\nMust-try food:\n•⁠  Kaiseki meals, yudofu, matcha desserts [cite: 467]\n\nMust-buy souvenirs:\n•⁠  Matcha sweets, traditional crafts, Kyoto pottery [cite: 468]",
          "img": "https://images.pexels.com/photos/35501372/pexels-photo-35501372.jpeg",
        },
        {
          "name": "Hyogo",
          "jp": "兵庫",
          "details": "Himeji Castle is nicknamed the “White Heron Castle” due to its elegant white appearance. [cite: 475] \n\nLocal specialties:\n•⁠  Kobe beef, seafood, sake [cite: 471]\n\nMust-visit attractions:\n•⁠  Himeji Castle, Arima Onsen, Kobe Harborland [cite: 472]\n\nMust-try food:\n•⁠  Kobe beef steak, seafood dishes, local ramen [cite: 473]\n\nMust-buy souvenirs:\n•⁠  Sake, Himeji crafts, Kobe sweets [cite: 474]",
          "img": "https://images.pexels.com/photos/31416883/pexels-photo-31416883.jpeg",
        },
        {
          "name": "Nara",
          "jp": "奈良",
          "details": "Nara Park’s deer are considered sacred messengers of the Shinto gods and freely interact with visitors. [cite: 481] \n\nLocal specialties:\n•⁠  Persimmons, kakinoha-zushi, sake [cite: 477]\n\nMust-visit attractions:\n•⁠  Nara Park, Todai-ji Temple, Kasuga Taisha Shrine [cite: 478]\n\nMust-try food:\n•⁠  Kakinoha-zushi, Nara mochi sweets, local soba [cite: 479]\n\nMust-buy souvenirs:\n•⁠  Deer-themed items, traditional Nara crafts, local sweets [cite: 480]",
          "img": "https://images.pexels.com/photos/27041999/pexels-photo-27041999.jpeg",
        },
        {
          "name": "Shiga",
          "jp": "滋賀",
          "details": "Lake Biwa, Japan’s largest freshwater lake, has shaped the culture and cuisine of Shiga for centuries. [cite: 487] \n\nLocal specialties:\n•⁠  Omi beef, funazushi, lotus root [cite: 483]\n\nMust-visit attractions:\n•⁠  Lake Biwa, Hikone Castle, Enryaku-ji Temple [cite: 484]\n\nMust-try food:\n•⁠  Omi beef dishes, funazushi, local freshwater fish [cite: 485]\n\nMust-buy souvenirs:\n•⁠  Omi crafts, Hikone sweets, sake [cite: 486]",
          "img": "https://images.pexels.com/photos/31361162/pexels-photo-31361162.jpeg",
        },
        {
          "name": "Wakayama",
          "jp": "和歌山",
          "details": "Famous for its spiritual Kumano pilgrimage trails, a UNESCO World Heritage site. [cite: 493] \n\nLocal specialties:\n•⁠  Umeboshi, seafood, citrus fruits [cite: 489]\n\nMust-visit attractions:\n•⁠  Kumano Kodo Pilgrimage Routes, Wakayama Castle, Nachi Falls [cite: 490]\n\nMust-try food:\n•⁠  Grilled seafood, ramen, dishes featuring ume [cite: 491]\n\nMust-buy souvenirs:\n•⁠  Ume products, local sweets, traditional crafts [cite: 492]",
          "img": "https://images.pexels.com/photos/2627089/pexels-photo-2627089.jpeg",
        },
        {
          "name": "Mie",
          "jp": "三重",
          "details": "Ise Grand Shrine is rebuilt every 20 years in a tradition called Shikinen Sengu. [cite: 499] \n\nLocal specialties:\n•⁠  Ise shrimp, Matsusaka beef, seafood [cite: 495]\n\nMust-visit attractions:\n•⁠  Ise Grand Shrine, Meoto Iwa, Nagashima Spa Land [cite: 496]\n\nMust-try food:\n•⁠  Matsusaka beef, seafood rice bowls, Ise udon [cite: 497]\n\nMust-buy souvenirs:\n•⁠  Ise pearls, local crafts, seafood products [cite: 498]",
          "img": "https://images.pexels.com/photos/31413003/pexels-photo-31413003.png",
        },
      ]
    },
    {
      "region": "Chugoku",
      "jp": "中国",
      "description": "A scenic region in western Honshu, known for its coastal beauty, historic towns, and unique cultural heritage. [cite: 501] It offers a blend of natural wonders and rich history. [cite: 502]",
      "bgImg": "https://cdn.pixabay.com/photo/2022/10/24/12/20/mountains-7543273_1280.jpg",
      "prefectures": [
        {
          "name": "Tottori",
          "jp": "鳥取",
          "details": "Famous for Japan’s largest sand dunes, offering camel rides and desert-like landscapes. [cite: 508] \n\nLocal specialties:\n•⁠  Pears, crab, wagyu beef [cite: 504]\n\nMust-visit attractions:\n•⁠  Tottori Sand Dunes, Mizuki Shigeru Road, Uradome Coast [cite: 505]\n\nMust-try food:\n•⁠  Matsuba crab, seafood rice bowls, beef dishes [cite: 506]\n\nMust-buy souvenirs:\n•⁠  Sand sculpture souvenirs, crab snacks, local crafts [cite: 507]",
          "img": "https://cdn.pixabay.com/photo/2021/03/11/02/57/mountain-6086083_1280.jpg",
        },
        {
          "name": "Shimane",
          "jp": "島根",
          "details": "Izumo Taisha is one of Japan’s oldest Shinto shrines, famous for matchmaking rituals. [cite: 514] \n\nLocal specialties:\n•⁠  Matsue sushi, seafood, sake [cite: 510]\n\nMust-visit attractions:\n•⁠  Izumo Taisha Shrine, Matsue Castle, Adachi Museum of Art [cite: 511]\n\nMust-try food:\n•⁠  Izumo soba, seafood, Matsue-style sushi [cite: 512]\n\nMust-buy souvenirs:\n•⁠  Local sake, traditional crafts, Matsue sweets [cite: 513]",
          "img": "https://cdn.pixabay.com/photo/2015/11/07/05/22/castle-1030461_1280.jpg",
        },
        {
          "name": "Okayama",
          "jp": "岡山",
          "details": "Korakuen Garden is one of Japan’s three most celebrated gardens. [cite: 520] \n\nLocal specialties:\n•⁠  White peaches, grapes, kibi dango [cite: 516]\n\nMust-visit attractions:\n•⁠  Korakuen Garden, Okayama Castle, Kurashiki Bikan Historical Quarter [cite: 517]\n\nMust-try food:\n•⁠  Barazushi, Kibi dango, grilled seafood [cite: 518]\n\nMust-buy souvenirs:\n•⁠  Kibi dango, local sweets, Okayama crafts [cite: 519]",
          "img": "https://cdn.pixabay.com/photo/2018/06/09/11/45/okayama-3464213_1280.jpg",
        },
        {
          "name": "Hiroshima",
          "jp": "広島",
          "details": "Itsukushima Shrine appears to float during high tide, creating one of Japan’s most iconic photo opportunities. [cite: 526] \n\nLocal specialties:\n•⁠  Oysters, Hiroshima okonomiyaki, lemons [cite: 522]\n\nMust-visit attractions:\n•⁠  Itsukushima Shrine, Hiroshima Peace Memorial Park, Shukkeien Garden [cite: 523]\n\nMust-try food:\n•⁠  Hiroshima okonomiyaki, fried oysters, momiji manju [cite: 524]\n\nMust-buy souvenirs:\n•⁠  Momiji manju, sake, Hiroshima crafts [cite: 525]",
          "img": "https://cdn.pixabay.com/photo/2020/01/06/05/29/japan-4744614_1280.jpg",
        },
        {
          "name": "Yamaguchi",
          "jp": "山口",
          "details": "Famous for fugu cuisine, a delicacy requiring licensed chefs due to its toxic nature. [cite: 532] \n\nLocal specialties:\n•⁠  Fugu, seafood, yamaguchi sake [cite: 528]\n\nMust-visit attractions:\n•⁠  Kintai Bridge, Rurikoji Temple, Akiyoshido Cave [cite: 529]\n\nMust-try food:\n•⁠  Fugu sashimi, seafood hot pot, local ramen [cite: 530]\n\nMust-buy souvenirs:\n•⁠  Fugu products, local crafts, sweets [cite: 531]",
          "img": "https://cdn.pixabay.com/photo/2022/12/14/17/44/japan-7655927_1280.jpg",
        },
      ]
    },
    {
      "region": "Shikoku",
      "jp": "四国",
      "description": "Japan’s smallest main island, known for its tranquil landscapes, coastal beauty, and deep spiritual heritage. [cite: 534] The region is famed for its 88-temple pilgrimage. [cite: 535]",
      "bgImg": "https://cdn.pixabay.com/photo/2022/09/07/10/01/landscape-7438429_1280.jpg",
      "prefectures": [
        {
          "name": "Tokushima",
          "jp": "徳島",
          "details": "Hosts the Awa Odori, one of Japan’s largest traditional dance festivals. [cite: 541] \n\nLocal specialties:\n•⁠  Sudachi citrus, seafood, indigo-dyed textiles [cite: 537]\n\nMust-visit attractions:\n•⁠  Awa Odori Dance Festival, Naruto Whirlpools, Mount Bizan [cite: 538]\n\nMust-try food:\n•⁠  Tokushima ramen, sudachi-flavoured dishes, seafood bowls [cite: 539]\n\nMust-buy souvenirs:\n•⁠  Sudachi products, indigo textiles, local snacks [cite: 540]",
          "img": "https://cdn.pixabay.com/photo/2020/10/23/03/20/mountain-5677590_1280.jpg",
        },
        {
          "name": "Kagawa",
          "jp": "香川",
          "details": "Famous as Japan’s “Udon Prefecture,” with udon restaurants serving noodles in unique regional styles. [cite: 547] \n\nLocal specialties:\n•⁠  Sanuki udon, olives, seafood [cite: 543]\n\nMust-visit attractions:\n•⁠  Ritsurin Garden, Kotohira Shrine, Shikoku Mura [cite: 544]\n\nMust-try food:\n•⁠  Sanuki udon, seafood rice bowls, tempura [cite: 545]\n\nMust-buy souvenirs:\n•⁠  Udon noodles, local olive products, handcrafts [cite: 546]",
          "img": "https://cdn.pixabay.com/photo/2020/10/23/03/20/mountain-5677590_1280.jpg",
        },
        {
          "name": "Ehime",
          "jp": "愛媛",
          "details": "Dogo Onsen is said to have inspired the bathhouse in the film Spirited Away. [cite: 553] \n\nLocal specialties:\n•⁠  Mikan, seafood, citrus sweets [cite: 549]\n\nMust-visit attractions:\n•⁠  Matsuyama Castle, Dogo Onsen, Shimanami Kaido [cite: 550]\n\nMust-try food:\n•⁠  Taimeshi, seafood, citrus desserts [cite: 551]\n\nMust-buy souvenirs:\n•⁠  Mikan products, Dogo Onsen souvenirs, local crafts [cite: 552]",
          "img": "https://cdn.pixabay.com/photo/2022/10/24/14/04/mountains-7543535_1280.jpg",
        },
        {
          "name": "Kochi",
          "jp": "高知",
          "details": "Home to Japan’s largest yuzu production and known for its lively Sunday market. [cite: 559] \n\nLocal specialties:\n•⁠  Katsuo, yuzu citrus, seafood [cite: 555]\n\nMust-visit attractions:\n•⁠  Kochi Castle, Shimanto River, Katsurahama Beach [cite: 556]\n\nMust-try food:\n•⁠  Katsuo tataki, seafood bowls, yuzu-flavoured dishes [cite: 557]\n\nMust-buy souvenirs:\n•⁠  Yuzu products, bonito flakes, local crafts [cite: 558]",
          "img": "https://cdn.pixabay.com/photo/2021/08/11/11/16/fishing-nets-6538206_1280.jpg",
        },
      ]
    },
    {
      "region": "Kyushu",
      "jp": "九州",
      "description": "Japan’s southern gateway, known for its volcanic landscapes, hot springs, rich culinary heritage, and historical connections to international trade. [cite: 562]",
      "bgImg": "https://cdn.pixabay.com/photo/2015/02/15/03/04/japanese-umbrellas-636870_1280.jpg",
      "prefectures": [
        {
          "name": "Fukuoka",
          "jp": "福岡",
          "details": "Famous for its open-air yatai (street food stalls), offering an intimate and lively dining culture. [cite: 569] \n\nLocal specialties:\n•⁠  Hakata ramen, mentaiko, strawberries [cite: 565]\n\nMust-visit attractions:\n•⁠  Ohori Park, Dazaifu Tenmangu Shrine, Fukuoka Tower [cite: 566]\n\nMust-try food:\n•⁠  Hakata tonkotsu ramen, mentaiko rice, yakitori [cite: 567]\n\nMust-buy souvenirs:\n•⁠  Mentaiko products, Hakata dolls, local sweets [cite: 568]",
          "img": "https://cdn.pixabay.com/photo/2021/10/09/07/06/natural-6693234_1280.jpg",
        },
        {
          "name": "Saga",
          "jp": "佐賀",
          "details": "One of Japan’s most celebrated ceramic regions, with centuries-old porcelain craftsmanship. [cite: 575] \n\nLocal specialties:\n•⁠  Saga beef, ceramics, seaweed [cite: 571]\n\nMust-visit attractions:\n•⁠  Karatsu Castle, Yoshinogari Historical Park, Arita Porcelain Park [cite: 572]\n\nMust-try food:\n•⁠  Saga beef steak, seafood, traditional Japanese sweets [cite: 573]\n\nMust-buy souvenirs:\n•⁠  Arita and Imari porcelain, local seaweed products [cite: 574]",
          "img": "https://cdn.pixabay.com/photo/2021/01/23/00/22/autumn-5941506_1280.jpg",
        },
        {
          "name": "Nagasaki",
          "jp": "長崎",
          "details": "Japan’s only international trading port during the Edo period, resulting in strong European and Chinese influences. [cite: 581] \n\nLocal specialties:\n•⁠  Castella cake, champon noodles, seafood [cite: 577]\n\nMust-visit attractions:\n•⁠  Nagasaki Peace Park, Glover Garden, Hashima Island [cite: 578]\n\nMust-try food:\n•⁠  Nagasaki champon, sara udon, castella cake [cite: 579]\n\nMust-buy souvenirs:\n•⁠  Castella cakes, glassware, local crafts [cite: 580]",
          "img": "https://cdn.pixabay.com/photo/2015/04/16/15/21/island-725792_1280.jpg",
        },
        {
          "name": "Kumamoto",
          "jp": "熊本",
          "details": "Mount Aso is one of the world’s largest active volcanic calderas, shaping the region’s dramatic landscape. [cite: 587] \n\nLocal specialties:\n•⁠  Kumamoto ramen, horse meat, watermelon [cite: 583]\n\nMust-visit attractions:\n•⁠  Kumamoto Castle, Mount Aso, Suizenji Garden [cite: 584]\n\nMust-try food:\n•⁠  Kumamoto ramen, basashi, mustard lotus root [cite: 585]\n\nMust-buy souvenirs:\n•⁠  Kumamon merchandise, local sweets, sake [cite: 586]",
          "img": "https://cdn.pixabay.com/photo/2013/12/10/05/38/aso-226338_1280.jpg",
        },
        {
          "name": "Oita",
          "jp": "大分",
          "details": "The country’s onsen capital, with the highest volume of natural hot spring water in Japan. [cite: 593] \n\nLocal specialties:\n•⁠  Onsen cuisine, kabosu citrus, seafood [cite: 589]\n\nMust-visit attractions:\n•⁠  Beppu hot springs, Yufuin village, Usa Shrine [cite: 590]\n\nMust-try food:\n•⁠  Toriten, seafood, hot spring-steamed dishes [cite: 591]\n\nMust-buy souvenirs:\n•⁠  Onsen skincare products, kabosu goods, local crafts [cite: 592]",
          "img": "https://cdn.pixabay.com/photo/2020/08/28/13/15/river-5524569_1280.jpg",
        },
        {
          "name": "Miyazaki",
          "jp": "宮崎",
          "details": "Associated with Japanese mythology, particularly the legend of the sun goddess Amaterasu. [cite: 599] \n\nLocal specialties:\n•⁠  Mangoes, Miyazaki beef, chicken nanban [cite: 595]\n\nMust-visit attractions:\n•⁠  Takachiho Gorge, Aoshima Island, Udo Shrine [cite: 596]\n\nMust-try food:\n•⁠  Chicken nanban, Miyazaki beef, tropical fruit desserts [cite: 597]\n\nMust-buy souvenirs:\n•⁠  Mango products, local sweets, traditional crafts [cite: 598]",
          "img": "https://cdn.pixabay.com/photo/2017/07/04/07/29/miyazaki-2470212_1280.jpg",
        },
        {
          "name": "Kagoshima",
          "jp": "鹿児島",
          "details": "Sakurajima is one of Japan’s most active volcanoes and is a defining symbol of the landscape. [cite: 605] \n\nLocal specialties:\n•⁠  Sweet potatoes, shochu, black pork [cite: 601]\n\nMust-visit attractions:\n•⁠  Sakurajima volcano, Sengan-en Garden, Yakushima Island [cite: 602]\n\nMust-try food:\n•⁠  Kurobuta pork dishes, sweet potato desserts, shochu [cite: 603]\n\nMust-buy souvenirs:\n•⁠  Sweet potato snacks, shochu, local crafts [cite: 604]",
          "img": "https://cdn.pixabay.com/photo/2017/03/21/19/08/ship-2163005_1280.jpg",
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