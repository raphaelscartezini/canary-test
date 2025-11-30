class User {
  final String id;
  final String name;
  final int age;
  final String country;
  final String countryFlag;
  final String learningLanguage;
  final String learningLanguageFlag;
  final String imageUrl;
  final String bio;
  final List<String> interests;

  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.country,
    required this.countryFlag,
    required this.learningLanguage,
    required this.learningLanguageFlag,
    required this.imageUrl,
    required this.bio,
    required this.interests,
  });

  // Sample users for the matching feature
  static const List<User> sampleUsers = [
    User(
      id: '1',
      name: 'Sophie Martin',
      age: 24,
      country: 'France',
      countryFlag: '🇫🇷',
      learningLanguage: 'Spanish',
      learningLanguageFlag: '🇪🇸',
      imageUrl: 'https://i.pravatar.cc/150?img=1',
      bio: 'Love traveling and learning new languages! Currently studying Spanish and looking for practice partners.',
      interests: ['Travel', 'Music', 'Cooking', 'Photography'],
    ),
    User(
      id: '2',
      name: 'Lucas Silva',
      age: 28,
      country: 'Brazil',
      countryFlag: '🇧🇷',
      learningLanguage: 'French',
      learningLanguageFlag: '🇫🇷',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
      bio: 'Software developer passionate about languages. Want to improve my French for work opportunities.',
      interests: ['Technology', 'Sports', 'Movies', 'Reading'],
    ),
    User(
      id: '3',
      name: 'Yuki Tanaka',
      age: 22,
      country: 'Japan',
      countryFlag: '🇯🇵',
      learningLanguage: 'English',
      learningLanguageFlag: '🇬🇧',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'University student studying English literature. Looking for conversation practice and cultural exchange!',
      interests: ['Anime', 'Books', 'Gaming', 'Art'],
    ),
    User(
      id: '4',
      name: 'Emma Johnson',
      age: 26,
      country: 'United States',
      countryFlag: '🇺🇸',
      learningLanguage: 'Japanese',
      learningLanguageFlag: '🇯🇵',
      imageUrl: 'https://i.pravatar.cc/150?img=9',
      bio: 'Marketing professional learning Japanese. Dream of visiting Tokyo soon! Let\'s practice together.',
      interests: ['Fashion', 'Food', 'Yoga', 'Travel'],
    ),
  ];
}
