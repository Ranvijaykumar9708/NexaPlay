import '../models/content_item.dart';
import '../models/live_channel.dart';
import '../models/profile.dart';

class MockData {
  static const List<UserProfile> initialProfiles = [
    UserProfile(
      id: 'p1',
      name: 'Ranvijay (रणविजय)',
      avatarColor: '0xFF8B5CF6',
      avatarIcon: 'person',
      isKids: false,
    ),
    UserProfile(
      id: 'p2',
      name: 'Roshani (रोशनी)',
      avatarColor: '0xFFEC4899',
      avatarIcon: 'face',
      isKids: false,
    ),
    UserProfile(
      id: 'p3',
      name: 'Kids (बच्चे)',
      avatarColor: '0xFF06B6D4',
      avatarIcon: 'child_care',
      isKids: true,
      pin: '1234',
    ),
  ];

  static const List<LiveChannel> liveChannels = [
    LiveChannel(
      id: 'star-plus',
      name: 'Star Plus HD',
      category: 'Entertainment',
      logoUrl:
          'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=400&auto=format&fit=crop&q=80',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      currentShow: 'Anupamaa (अनुपमा)',
      currentShowTime: '08:00 PM - 09:00 PM',
      nextShow: 'Yeh Rishta Kya Kehlata Hai',
      nextShowTime: '09:00 PM',
      viewers: '2.8M Live',
    ),
    LiveChannel(
      id: 'sony-max',
      name: 'Sony MAX HD',
      category: 'Movies',
      logoUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&auto=format&fit=crop&q=80',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      currentShow: 'Suryavansham (सूर्यवंशम) - Uncut 4K',
      currentShowTime: '07:30 PM - 10:30 PM',
      nextShow: 'KGF: Chapter 1 (Hindi)',
      nextShowTime: '10:30 PM',
      viewers: '1.9M Live',
    ),
    LiveChannel(
      id: 'sports-18',
      name: 'Sports 18 HD',
      category: 'Sports',
      logoUrl:
          'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=400&auto=format&fit=crop&q=80',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      currentShow: 'India vs Australia - 4th T20I (Live)',
      currentShowTime: '07:00 PM - 11:00 PM',
      nextShow: 'Post Match Analysis with Experts',
      nextShowTime: '11:00 PM',
      viewers: '5.4M Live',
    ),
    LiveChannel(
      id: 'aaj-tak',
      name: 'Aaj Tak HD',
      category: 'News',
      logoUrl:
          'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=400&auto=format&fit=crop&q=80',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      currentShow: 'Dangal Prime Time Debate',
      currentShowTime: '08:00 PM - 09:00 PM',
      nextShow: '10 Tak with Special Investigation',
      nextShowTime: '10:00 PM',
      viewers: '3.1M Live',
    ),
  ];

  static const List<ContentItem> allContent = [
    // 1. JAWAN (Hero Feature)
    ContentItem(
      id: 'jawan',
      title: 'JAWAN',
      hindiTitle: 'जवान',
      description:
          'An emotionally driven thriller about a prison officer Azad Rathore and his father Vikram Rathore, who fight systemic corruption, farmer distress, and political greed.',
      posterUrl:
          'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1600&auto=format&fit=crop&q=80',
      rating: 8.4,
      year: 2023,
      duration: '2h 48m',
      genres: ['Action', 'Thriller', 'Drama'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      cast: ['Shah Rukh Khan', 'Nayanthara', 'Vijay Sethupathi', 'Deepika Padukone', 'Sanya Malhotra'],
      director: 'Atlee Kumar',
      maturityRating: 'U/A 16+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: true,
      isMovie: true,
      introSkipStart: 0,
      introSkipEnd: 60,
      trivia: [
        'Shah Rukh Khan plays a dual role: father Vikram Rathore and son Azad Rathore.',
        'Atlee wrote the high-octane metro hijacking scene inspired by social issues in rural India.',
        'Anirudh Ravichander made his Bollywood debut with this chartbusting soundtrack.',
      ],
      soundtrack: ['Chaleya (Arijit Singh)', 'Zinda Banda', 'Not Ramaiya Vastavaiya'],
      isPremiere: true,
    ),

    // 2. MIRZAPUR
    ContentItem(
      id: 'mirzapur',
      title: 'MIRZAPUR: SEASON 3',
      hindiTitle: 'मिर्ज़ापुर',
      description:
          'The iron-fisted Akhandanand Tripathi (Kaleen Bhaiya) battles Guddu Pandit and Golu Gupta for the undisputed control of the purvanchal throne.',
      posterUrl:
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&auto=format&fit=crop&q=80',
      rating: 8.5,
      year: 2024,
      duration: '3 Seasons',
      genres: ['Crime', 'Action', 'Thriller'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      cast: ['Pankaj Tripathi', 'Ali Fazal', 'Shweta Tripathi', 'Rasika Dugal', 'Vijay Varma'],
      director: 'Gurmmeet Singh',
      maturityRating: 'A 18+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: true,
      isMovie: false,
      seasons: 3,
      introSkipStart: 0,
      introSkipEnd: 75,
      trivia: [
        'Pankaj Tripathi improvised Kaleen Bhaiya\'s signature deep neck tilt and calm demeanor.',
        'Ali Fazal put on over 14kg of raw muscle for Guddu Pandit\'s fierce revenge arc.',
      ],
      soundtrack: ['Mirzapur Raw Theme (John Stewart Eduri)', 'Bhaukaal Beat'],
    ),

    // 3. ANIMAL
    ContentItem(
      id: 'animal',
      title: 'ANIMAL',
      hindiTitle: 'एनिमल',
      description:
          'A fiercely loyal son Ranvijay Singh embarks on a brutal, unrelenting war against enemies who attempted to assassinate his emotionally distant father.',
      posterUrl:
          'https://images.unsplash.com/photo-1533928298208-27ff66555d8d?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?w=1600&auto=format&fit=crop&q=80',
      rating: 7.9,
      year: 2023,
      duration: '3h 21m',
      genres: ['Action', 'Crime', 'Drama'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      cast: ['Ranbir Kapoor', 'Anil Kapoor', 'Rashmika Mandanna', 'Bobby Deol', 'Triptii Dimri'],
      director: 'Sandeep Reddy Vanga',
      maturityRating: 'A 18+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: true,
      isMovie: true,
      introSkipStart: 0,
      introSkipEnd: 50,
      trivia: [
        'Bobby Deol\'s mute character Abrar became a national viral sensation with "Jamal Kudu".',
        'Ranbir Kapoor filmed the marathon interval action sequence in an intense 18-day continuous schedule.',
      ],
      soundtrack: ['Arjan Vailly (Bhupinder Babbal)', 'Satranga (Arijit Singh)', 'Jamal Kudu'],
    ),

    // 4. 12TH FAIL
    ContentItem(
      id: '12th-fail',
      title: '12TH FAIL',
      hindiTitle: '१२वीं फेल',
      description:
          'Based on the inspiring real-life journey of IPS officer Manoj Kumar Sharma who restarts his academic journey in Delhi despite grinding poverty and failure.',
      posterUrl:
          'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1600&auto=format&fit=crop&q=80',
      rating: 9.0,
      year: 2023,
      duration: '2h 27m',
      genres: ['Biography', 'Drama'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      cast: ['Vikrant Massey', 'Medha Shankr', 'Anant V Joshi', 'Geeta Agrawal'],
      director: 'Vidhu Vinod Chopra',
      maturityRating: 'U/A 13+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: true,
      isTrending: true,
      isMovie: true,
      trivia: [
        'Vikrant Massey spent months in Mukherjee Nagar preparing alongside real UPSC aspirants.',
        'Won Filmfare Award for Best Film and Best Actor Critics.',
      ],
      soundtrack: ['Restart Anthem (Swanand Kirkire)', 'Bolo Na'],
    ),

    // 5. PANCHAYAT
    ContentItem(
      id: 'panchayat',
      title: 'PANCHAYAT: SEASON 3',
      hindiTitle: 'पंचायत',
      description:
          'An engineering graduate Abhishek Tripathi works as a secretary in the remote village of Phulera, navigating rural politics, Pradhan ji, and Binod with heartwarming humor.',
      posterUrl:
          'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1600&auto=format&fit=crop&q=80',
      rating: 9.0,
      year: 2024,
      duration: '3 Seasons',
      genres: ['Comedy', 'Drama'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      cast: ['Jitendra Kumar', 'Neena Gupta', 'Raghubir Yadav', 'Chandan Roy', 'Faisal Malik'],
      director: 'Deepak Kumar Mishra',
      maturityRating: 'U/A 13+',
      is4K: true,
      isHDR: true,
      isDolbyVision: false,
      isDolbyAtmos: true,
      isKidsFriendly: true,
      isTrending: true,
      isMovie: false,
      seasons: 3,
      introSkipStart: 0,
      introSkipEnd: 45,
      trivia: [
        'The village of Mahodiya in Sehore, Madhya Pradesh served as the real-world Phulera village set.',
        'The water tank scenes have become one of Indian television\'s most celebrated comedy setups.',
      ],
      soundtrack: ['Panchayat Acoustic Title', 'Phulera Folk Symphony'],
    ),

    // 6. KALKI 2898 AD
    ContentItem(
      id: 'kalki-2898-ad',
      title: 'KALKI 2898 AD',
      hindiTitle: 'कल्कि २८९८ एडी',
      description:
          'In a dystopian post-apocalyptic future in Kasi, the immortal warrior Ashwatthama rises to safeguard Sumathi, carrying the divine avatar destined to end Kaliyuga.',
      posterUrl:
          'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1600&auto=format&fit=crop&q=80',
      rating: 8.6,
      year: 2024,
      duration: '3h 01m',
      genres: ['Sci-Fi', 'Mythology', 'Action'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      cast: ['Amitabh Bachchan', 'Prabhas', 'Kamal Haasan', 'Deepika Padukone', 'Disha Patani'],
      director: 'Nag Ashwin',
      maturityRating: 'U/A 13+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: true,
      isTrending: true,
      isMovie: true,
      trivia: [
        'Nag Ashwin developed custom robotic vehicles including Bujji for the desert wasteland battles.',
        'Amitabh Bachchan performed intense martial arts sequences as the towering Ashwatthama.',
      ],
      soundtrack: ['Bhairava Anthem (Diljit Dosanjh)', 'Theme of Kasi', 'Veera Dheera'],
      isPremiere: true,
    ),

    // 7. THE FAMILY MAN
    ContentItem(
      id: 'the-family-man',
      title: 'THE FAMILY MAN',
      hindiTitle: 'द फैमिली मैन',
      description:
          'Srikant Tiwari, a middle-class man who secretly works as an elite intelligence officer for T.A.S.C, attempts to protect the nation from terrorist threats while managing family duties.',
      posterUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1600&auto=format&fit=crop&q=80',
      rating: 8.7,
      year: 2021,
      duration: '2 Seasons',
      genres: ['Action', 'Comedy', 'Thriller'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      cast: ['Manoj Bajpayee', 'Priyamani', 'Sharib Hashmi', 'Samantha Ruth Prabhu'],
      director: 'Raj & DK',
      maturityRating: 'U/A 16+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: false,
      isMovie: false,
      seasons: 2,
      trivia: [
        'Manoj Bajpayee won widespread critical acclaim for blending suburban comedy with gritty espionage.',
      ],
      soundtrack: ['Family Man Title Beats', 'TASC Action Chants'],
    ),

    // 8. STREE 2
    ContentItem(
      id: 'stree-2',
      title: 'STREE 2: SARKATE KA AATANK',
      hindiTitle: 'स्त्री २',
      description:
          'The town of Chanderi is haunted once more, this time by a headless entity named Sarkata. Vicky and his loyal gang must join hands with Stree to save the town.',
      posterUrl:
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1600&auto=format&fit=crop&q=80',
      rating: 8.3,
      year: 2024,
      duration: '2h 29m',
      genres: ['Comedy', 'Horror'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      cast: ['Shraddha Kapoor', 'Rajkummar Rao', 'Pankaj Tripathi', 'Aparshakti Khurana', 'Abhishek Banerjee'],
      director: 'Amar Kaushik',
      maturityRating: 'U/A 16+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: true,
      isMovie: true,
      trivia: [
        'Became the highest-grossing Hindi film domestically in Indian cinema history.',
      ],
      soundtrack: ['Aaj Ki Raat (Madhubanti Bagchi)', 'Aayi Nai (Pawan Singh)'],
    ),

    // 9. K.G.F: CHAPTER 2
    ContentItem(
      id: 'kgf-2',
      title: 'K.G.F: CHAPTER 2',
      hindiTitle: 'के.जी.एफ: चैप्टर २',
      description:
          'Rocky rules the blood-soaked empire of Kolar Gold Fields. However, the ruthless Adheera and Prime Minister Ramika Sen launch an all-out assault against him.',
      posterUrl:
          'https://images.unsplash.com/photo-1533928298208-27ff66555d8d?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1600&auto=format&fit=crop&q=80',
      rating: 8.3,
      year: 2022,
      duration: '2h 48m',
      genres: ['Action', 'Drama', 'Crime'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      cast: ['Yash', 'Sanjay Dutt', 'Raveena Tandon', 'Srinidhi Shetty', 'Prakash Raj'],
      director: 'Prashanth Neel',
      maturityRating: 'U/A 16+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: false,
      isMovie: true,
      trivia: [
        'Sanjay Dutt shot the climax sword clash shortly after beating lung cancer.',
      ],
      soundtrack: ['Toofan (Hindi)', 'Sulthan', 'Mehabooba'],
    ),

    // 10. RRR
    ContentItem(
      id: 'rrr',
      title: 'RRR',
      hindiTitle: 'आर.आर.आर',
      description:
          'A tale of two legendary revolutionaries - Alluri Sitarama Raju and Komaram Bheem - who unite to fight British colonial tyranny in 1920s India.',
      posterUrl:
          'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&auto=format&fit=crop&q=80',
      rating: 8.8,
      year: 2022,
      duration: '3h 02m',
      genres: ['Action', 'Drama', 'History'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      cast: ['Ram Charan', 'N.T. Rama Rao Jr.', 'Alia Bhatt', 'Ajay Devgn', 'Shriya Saran'],
      director: 'S.S. Rajamouli',
      maturityRating: 'U/A 16+',
      is4K: true,
      isHDR: true,
      isDolbyVision: true,
      isDolbyAtmos: true,
      isKidsFriendly: false,
      isTrending: false,
      isMovie: true,
      trivia: [
        'Won the Academy Award (Oscar) and Golden Globe for Best Original Song "Naatu Naatu".',
      ],
      soundtrack: ['Naacho Naacho (Hindi Naatu Naatu)', 'Dosti', 'Sholay'],
    ),

    // 11. CHHOTA BHEEM (Kids Special)
    ContentItem(
      id: 'chhota-bheem',
      title: 'CHHOTA BHEEM & THRONE OF BALI',
      hindiTitle: 'छोटा भीम: बाली का सिंहासन',
      description:
          'Bheem and his friends Chutki, Raju, Jaggu and Kalia travel to Bali to save Prince Arjun and his kingdom from the evil witch Rangda.',
      posterUrl:
          'https://images.unsplash.com/photo-1563089145-599997674d42?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1600&auto=format&fit=crop&q=80',
      rating: 8.1,
      year: 2023,
      duration: '1h 45m',
      genres: ['Animation', 'Adventure', 'Kids'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      cast: ['Chhota Bheem', 'Chutki', 'Raju', 'Kalia', 'Dholakpur Heroes'],
      director: 'Rajiv Chilaka',
      maturityRating: 'U (All Ages)',
      is4K: true,
      isHDR: false,
      isDolbyVision: false,
      isDolbyAtmos: true,
      isKidsFriendly: true,
      isTrending: false,
      isMovie: true,
      trivia: [
        'India\'s most beloved animated superhero created by Green Gold Animation.',
      ],
      soundtrack: ['Dholakpur Ka Dhol Baje', 'Laddoo Song'],
    ),

    // 12. MOTU PATLU (Kids Special)
    ContentItem(
      id: 'motu-patlu',
      title: 'MOTU PATLU: KUNG FU KINGS',
      hindiTitle: 'मोटू पतलू: कुंग फू किंग्स',
      description:
          'Motu eats hot samosas to gain superhuman martial arts powers to defend Furfuri Nagar against villain John the Don.',
      posterUrl:
          'https://images.unsplash.com/photo-1563089145-599997674d42?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1600&auto=format&fit=crop&q=80',
      rating: 7.8,
      year: 2023,
      duration: '1h 32m',
      genres: ['Animation', 'Comedy', 'Kids'],
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      cast: ['Motu', 'Patlu', 'Dr. Jhatka', 'Ghasitaram', 'Chingum'],
      director: 'Suhas Kadav',
      maturityRating: 'U (All Ages)',
      is4K: true,
      isHDR: false,
      isDolbyVision: false,
      isDolbyAtmos: false,
      isKidsFriendly: true,
      isTrending: false,
      isMovie: true,
      trivia: [
        'Furfuri Nagar\'s samosa powered adventures are loved by millions of children across India.',
      ],
      soundtrack: ['Motu Aur Patlu Ki Jodi', 'Samosa Anthem'],
    ),
  ];

  static const List<String> recentSearches = [
    'jawan',
    'mirzapur',
    'animal',
    'panchayat',
    '12th fail',
    'kalki 2898 ad',
    'stree 2',
    'kgf 2',
    'shah rukh khan',
    'pankaj tripathi',
  ];
}
