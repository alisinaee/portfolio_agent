import '../models/portfolio_models.dart';

// Source: https://github.com/alisinaee/alisinaee (main)
// Snapshot commit: 9ed616f3201317b48dfb6fd73a6f7e0b8b29d2e7
// Imported on: February 27, 2026
const portfolioSnapshot = PortfolioSnapshot(
  fullName: 'Ali Sinaee',
  headline: 'Senior Flutter Expert & Mobile App Developer',
  location: 'Tehran, Iran',
  resumeUrl: 'https://github.com/alisinaee/alisinaee/raw/main/AliSinaee.pdf',
  heroLinks: [
    ContactLink(
      label: 'GitHub',
      value: 'github.com/alisinaee',
      url: 'https://github.com/alisinaee',
    ),
    ContactLink(
      label: 'LinkedIn',
      value: 'linkedin.com/in/alisinaee',
      url: 'https://www.linkedin.com/in/alisinaee',
    ),
    ContactLink(
      label: 'Instagram',
      value: '@alisinaee',
      url: 'https://instagram.com/alisinaee',
    ),
    ContactLink(
      label: 'Email',
      value: 'alisinaiasl@gmail.com',
      url: 'mailto:alisinaiasl@gmail.com',
    ),
  ],
  profile: ProfileInfo(
    fields: [
      ProfileField(label: 'Full Name', value: 'Ali Sinaee'),
      ProfileField(label: 'Date of Birth', value: 'January 27, 1996'),
      ProfileField(label: 'Location', value: 'Tehran, Iran'),
      ProfileField(
        label: 'Languages',
        value: 'Persian (Native), English (Fluent)',
      ),
      ProfileField(
        label: 'Education',
        value: 'Bachelor of Computer Engineering - Bu-Ali Sina University',
      ),
      ProfileField(label: 'University', value: 'Bu-Ali Sina'),
      ProfileField(label: 'Marital Status', value: 'Single'),
      ProfileField(label: 'Military Service', value: 'Completed / Discharged'),
      ProfileField(label: 'Phone', value: '+989162363723'),
      ProfileField(label: 'Email', value: 'alisinaiasl@gmail.com'),
      ProfileField(label: 'LinkedIn', value: 'www.linkedin.com/in/alisinaee'),
      ProfileField(label: 'GitHub', value: 'www.github.com/alisinaee'),
    ],
  ),
  contactLinks: [
    ContactLink(
      label: 'LinkedIn',
      value: 'www.linkedin.com/in/alisinaee',
      url: 'https://www.linkedin.com/in/alisinaee',
    ),
    ContactLink(
      label: 'GitHub',
      value: 'www.github.com/alisinaee',
      url: 'https://github.com/alisinaee',
    ),
    ContactLink(
      label: 'Email',
      value: 'alisinaiasl@gmail.com',
      url: 'mailto:alisinaiasl@gmail.com',
    ),
    ContactLink(
      label: 'Phone',
      value: '+989162363723',
      url: 'tel:+989162363723',
    ),
  ],
  experiences: [
    ExperienceItem(
      role: 'Senior Flutter Developer (Freelance / Side Project)',
      period: 'Oct 2024 - Present',
      company: 'IDA Company',
      location: 'Remote',
      project: 'Home Palette: AI Decor & Design',
      projectSummary:
          'AI-powered home decoration and room remodeling app for iOS and Android.',
      responsibilities: [
        'Sole Flutter developer; designed and built the full app from scratch for both platforms.',
        'Implemented AI-driven room redesign and image-processing workflows.',
        'Built in-app purchase flows and subscription lifecycle management.',
        'Handled App Store and Google Play submission, review, and release operations.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: BLoC',
        'Source Control: GitHub',
        'Deployment: App Store, Google Play',
        'Development Process: TDD, DDD',
      ],
      platforms: 'Android, iOS',
      technologies: [
        'Dart',
        'Flutter',
        'AI service integration',
        'Image processing',
        'In-app purchases',
        'Crash reporting and analytics',
      ],
      relatedLinks: [
        ContactLink(
          label: 'App Store',
          value: 'Home Palette: AI Decor & Design',
          url:
              'https://apps.apple.com/app/home-palette-ai-decor-design/id6756274814',
        ),
      ],
      keyAchievements: [
        'Built and launched a production AI interior-design app end-to-end as sole Flutter engineer.',
        'Delivered a polished AI-driven redesign experience for real user rooms.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Developer',
      period: 'Oct 2024 - Present',
      company: 'ToBank (GardeshPay) - Gardeshgari Bank',
      location: 'Tehran, Iran',
      project: 'ToBank',
      projectSummary:
          'Official digital banking platform serving millions of Iranian users across mobile and web.',
      responsibilities: [
        'Led Flutter development for payment and security-critical modules.',
        'Built secure workflows: Shetab transfer, wallet, bill pay, top-up, insurance, and donations.',
        'Implemented OTP, biometric login, session/device security, and encrypted storage.',
        'Collaborated with backend and DevOps for anti-fraud checks and compliance hardening.',
        'Maintained strong unit/integration/widget test coverage for financial logic.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture, Modular Monorepo (Melos)',
        'State Management: BLoC, GetX',
        'Development Practices: TDD, DDD',
        'Version Control: GitHub',
        'Deployment: Fastlane, Firebase App Distribution',
        'Project Management: Notion, Agile Scrum',
      ],
      platforms: 'Android, iOS, Web',
      technologies: [
        'Dart',
        'Flutter',
        'Dio',
        'Secure encrypted storage',
        'OTP and biometric authentication',
        'End-to-end encryption',
        'Firebase',
        'Sentry',
      ],
      relatedLinks: [
        ContactLink(
          label: 'Google Play',
          value: 'ToBank',
          url:
              'https://play.google.com/store/apps/details?id=com.gardeshpay.app&hl=en',
        ),
        ContactLink(
          label: 'Official Website',
          value: 'tobank.ir',
          url: 'https://tobank.ir/',
        ),
      ],
      keyAchievements: [
        'Strengthened transaction security with encrypted storage, device binding, and anti-fraud logic.',
        'Delivered regulatory-compliant modules for high-volume banking operations.',
        'Reduced regressions through broad automated testing across financial flows.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Expert & PM',
      period: 'Jun 2024 - Oct 2024',
      company: 'DUSK VPN Project',
      location: 'Tehran, Iran',
      project: 'Dusk',
      projectSummary:
          'Cross-platform VPN solution using Singbox and Xray technologies.',
      responsibilities: [
        'Planned and shipped secure VPN features for desktop and mobile clients.',
        'Integrated proxy core protocols and operational tooling for distribution.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: BLoC',
        'Cloud: Google Cloud, Firebase',
        'Deployment: Fastlane',
        'Testing: Unit test, Widget test',
      ],
      platforms: 'Windows, macOS, Linux, Android, iOS',
      technologies: [
        'Flutter',
        'Go',
        'Python',
        'Bash',
        'Docker',
        'Django',
        'Sing-box',
        'Xray',
        'TUIC',
        'Hysteria',
        'Reality',
        'Trojan',
        'SSH',
      ],
      relatedLinks: [
        ContactLink(
          label: 'GitHub Repository',
          value: 'dusk-net/dusk',
          url: 'https://github.com/dusk-net/dusk',
        ),
      ],
      keyAchievements: [
        'Delivered multi-platform VPN clients with modern proxy protocol support.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Expert',
      period: 'Apr 2024 - Jun 2024',
      company: 'Dolphin Company',
      location: 'Tehran, Iran',
      project: 'Dolphin Tracker',
      projectSummary:
          'Fleet management and GPS tracking system with real-time monitoring and device control.',
      responsibilities: [
        'Built app features for real-time fleet tracking and route history review.',
        'Implemented BLE communication for sensor data and device settings.',
        'Enabled firmware update workflows over the internet.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: GetX',
        'Source Control: GitHub',
        'Project Management: Trello',
        'Testing: Unit test, Widget test',
      ],
      platforms: 'Android, iOS',
      technologies: [
        'Flutter',
        'BLE',
        'Real-time tracking',
        'Sensor telemetry',
        'Firmware update pipelines',
      ],
      relatedLinks: [
        ContactLink(
          label: 'Company Website',
          value: '2lphin.com',
          url: 'https://2lphin.com',
        ),
      ],
      keyAchievements: [
        'Shipped production-grade fleet tracking and IoT features on mobile.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Expert',
      period: 'Jun 2021 - Jun 2024',
      company: 'Rastak Company',
      location: 'Isfahan, Iran',
      project: 'Hamkelasi Smart Super App',
      projectSummary:
          'Comprehensive school management app serving students, parents, teachers, and admins.',
      responsibilities: [
        'Implemented role-based experiences for students, parents, teachers, and staff.',
        'Built messaging, notification, assignment, and academic workflow features.',
        'Supported real-time updates and multi-platform deployment.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: GetX',
        'Source Control: GitHub',
        'Project Management: Jira',
        'Development Process: TDD, DDD',
      ],
      platforms: 'Android, iOS, PWA',
      technologies: [
        'Flutter',
        'RESTful APIs',
        'WebSocket/STOMP',
        'Role-based access control',
        'Audio recording and playback',
      ],
      relatedLinks: [
        ContactLink(
          label: 'Company Website',
          value: 'hamkelasi.co',
          url: 'https://hamkelasi.co/',
        ),
        ContactLink(
          label: 'Google Play',
          value: 'Hamkelasi',
          url:
              'https://play.google.com/store/apps/details?id=com.hamkelasisoftware.app&pcampaignid=web_share',
        ),
      ],
      keyAchievements: [
        'Contributed to an education super app with over 100,000 downloads on multiple stores.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Expert',
      period: 'Mar 2021 - Sep 2021',
      company: 'Aban VPN',
      location: 'Vilnius, Lithuania',
      project: 'Aban VPN',
      projectSummary:
          'Global VPN network app focused on secure, high-performance connectivity.',
      responsibilities: [
        'Built client features for server selection, secure tunneling, and usage simplicity.',
        'Delivered cross-platform VPN UX for Android and iOS users at scale.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: Riverpod (hooks)',
        'Source Control: GitHub',
        'Project Management: Trello',
        'Development Process: TDD, DDD',
      ],
      platforms: 'Android, iOS',
      technologies: ['Flutter', 'Go', 'PHP', 'V2ray', 'Shadowsocks', 'Trojan'],
      relatedLinks: [
        ContactLink(
          label: 'Company Website',
          value: 'abanvpn.com',
          url: 'https://abanvpn.com/iran/',
        ),
        ContactLink(
          label: 'App Store',
          value: 'Aban VPN',
          url:
              'https://apps.apple.com/lt/app/aban-vpn/id1660467884?platform=iphone',
        ),
      ],
      keyAchievements: [
        'Delivered secure VPN functionality with broad regional server coverage.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Expert',
      period: 'Jun 2020 - Feb 2021',
      company: 'Radar GPS',
      location: 'Mashhad, Iran',
      project: 'Radar Tracker',
      projectSummary:
          'Vehicle tracking and security application with remote control and alerting.',
      responsibilities: [
        'Built live vehicle tracking, report generation, and remote control features.',
        'Implemented alert systems for ignition, security, and device health.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: BLoC',
        'Source Control: GitHub',
        'Project Management: Jira',
        'Development Process: TDD, DDD',
      ],
      platforms: 'Android, iOS',
      technologies: ['Flutter', 'GPS telemetry', 'Remote actions', 'Alerting'],
      relatedLinks: [
        ContactLink(
          label: 'Company Website',
          value: 'radargps.org',
          url: 'https://radargps.org/',
        ),
      ],
      keyAchievements: [
        'Delivered security-focused vehicle tracking workflows for production use.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Developer',
      period: 'Mar 2021 - Jun 2021',
      company: 'Raymoon Company',
      location: 'Isfahan, Iran',
      project: 'Tanin Vahy',
      projectSummary:
          'Dramatic spoken translation app for the Holy Quran with immersive audio.',
      responsibilities: [
        'Built features for local storage and rich audio playback experiences.',
        'Supported content delivery and performance for media-heavy flows.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: GetX',
        'Source Control: GitHub',
        'Project Management: Jira',
        'Development Process: TDD',
      ],
      platforms: 'Android',
      technologies: ['Flutter', 'Local storage', 'Audio player'],
      relatedLinks: [
        ContactLink(
          label: 'Café Bazaar',
          value: 'Tanin Vahy',
          url: 'https://cafebazaar.ir/app/com.taninevahy.android',
        ),
      ],
      keyAchievements: [
        'Contributed to an award-recognized cultural application.',
      ],
    ),
    ExperienceItem(
      role: 'Senior Flutter Developer',
      period: 'Dec 2020 - Mar 2021',
      company: 'Entekhab Industrial Group',
      location: 'Isfahan, Iran',
      project: 'EPS Man',
      projectSummary:
          'Human resource management application developed for Polystyrene Company.',
      responsibilities: [
        'Built HR workflows and core operational features in Flutter.',
        'Supported desktop and mobile compatibility goals for the product line.',
      ],
      architectureAndTools: [
        'Architecture: MVC',
        'State Management: GetX',
        'Source Control: GitHub',
        'Project Management: Trello',
        'Development Process: TDD',
      ],
      platforms: 'Android',
      technologies: ['Flutter', 'HR process flows'],
      relatedLinks: [
        ContactLink(
          label: 'Demo Version',
          value: 'epsman-dd8b8.web.app',
          url: 'https://epsman-dd8b8.web.app/',
        ),
      ],
      keyAchievements: [
        'Delivered a custom enterprise HR app tailored for industrial operations.',
      ],
    ),
    ExperienceItem(
      role: 'Flutter Developer',
      period: 'Jan 2019 - Nov 2020',
      company: 'Rock Machine Co',
      location: 'Isfahan, Iran',
      project: 'ZigZag',
      projectSummary: 'Trade platform for heavy machinery buying and selling.',
      responsibilities: [
        'Built marketplace app flows for listings, browsing, and transactions.',
        'Designed UX around domain-specific heavy-equipment operations.',
      ],
      architectureAndTools: [
        'Architecture: Clean Architecture',
        'State Management: Provider',
        'Source Control: GitHub',
        'Project Management: Trello',
      ],
      platforms: 'Android, iOS',
      technologies: ['Flutter', 'Marketplace workflows'],
      relatedLinks: [
        ContactLink(
          label: 'Company Website',
          value: 'rockmachineco.com',
          url: 'https://www.rockmachineco.com/',
        ),
      ],
      keyAchievements: [
        'Shipped domain-focused trade app features for heavy machinery market needs.',
      ],
    ),
    ExperienceItem(
      role: 'Flutter Developer',
      period: '2017 - 2019',
      company: 'Nicode',
      location: 'Isfahan, Iran',
      project: 'Kargozar',
      projectSummary:
          'Insurance services app with more than 10,000 active users.',
      responsibilities: [
        'Implemented app functionality to simplify insurance user workflows.',
        'Supported product growth with production-ready mobile delivery.',
      ],
      architectureAndTools: [
        'Architecture: MVC',
        'State Management: GetX',
        'Project Management: Trello',
      ],
      platforms: 'Android, iOS',
      technologies: ['Flutter', 'Insurance service workflows'],
      relatedLinks: [],
      keyAchievements: [
        'Helped deliver and scale a consumer insurance app with 10k+ active users.',
      ],
    ),
  ],
  skillGroups: [
    SkillGroup(
      title: 'Languages & Frameworks',
      subtitle: 'Expert',
      items: ['Dart', 'Flutter'],
    ),
    SkillGroup(
      title: 'Languages & Frameworks',
      subtitle: 'Mid-Level',
      items: [
        'Swift',
        'SwiftUI',
        'UIKit',
        'Kotlin',
        'Java',
        'Laravel',
        'PHP',
        'Vue.js',
        'Python',
        'Django',
        'MySQL',
        'C',
        'C++',
        'C#',
      ],
    ),
    SkillGroup(
      title: 'Languages & Frameworks',
      subtitle: 'Beginner',
      items: ['Go', 'Fiber', 'WPF', 'Qt'],
    ),
    SkillGroup(
      title: 'State Management & Architecture',
      subtitle: 'Expert',
      items: ['BLoC', 'GetX', 'Provider', 'Cubit'],
    ),
    SkillGroup(
      title: 'State Management & Architecture',
      subtitle: 'Mid-Level',
      items: ['Riverpod'],
    ),
    SkillGroup(
      title: 'Development Tools',
      items: [
        'Cursor',
        'Git',
        'GitHub',
        'GitLab',
        'Bitbucket',
        'Android Studio',
        'VS Code',
        'IntelliJ IDEA',
        'Xcode',
        'Visual Studio',
      ],
    ),
    SkillGroup(
      title: 'Project Management',
      items: ['Trello', 'Notion', 'Jira', 'Slack'],
    ),
    SkillGroup(
      title: 'Design & API',
      items: ['Figma', 'Adobe XD', 'Postman', 'Swagger'],
    ),
    SkillGroup(
      title: 'Deployment & CI/CD',
      items: [
        'Fastlane',
        'Codemagic',
        'Firebase',
        'Sentry',
        'Google Play Console',
        'App Store Connect',
        'TestFlight',
      ],
    ),
    SkillGroup(
      title: 'iOS Native & Platform Integration',
      items: [
        'Swift',
        'SwiftUI',
        'UIKit',
        'Platform Channels',
        'Plugin Development',
        'APNs',
        'Universal Links',
        'Keychain / Biometric Auth',
        'Signing and Provisioning',
      ],
    ),
    SkillGroup(
      title: 'Architecture & Engineering Principles',
      items: [
        'Clean Architecture',
        'MVVM',
        'MVC',
        'Repository',
        'Hexagonal',
        'SOLID',
        'DRY',
        'KISS',
        'SoC',
        'IoC',
        'TDD',
        'DDD',
      ],
    ),
    SkillGroup(
      title: 'AI & Modern Development',
      items: [
        'Cursor AI',
        'GitHub Copilot',
        'AI Agents',
        'Vibe Coding',
        'ChatGPT Integration',
      ],
    ),
  ],
  achievementGroups: [
    AchievementGroup(
      title: 'AI & Interior Design',
      items: [
        'Built and launched Home Palette on iOS and Android as sole Flutter developer.',
        'Integrated AI services for room redesign and interior decoration generation.',
        'Managed full lifecycle from implementation to app store publication.',
      ],
    ),
    AchievementGroup(
      title: 'Banking & Financial Services',
      items: [
        'Led ToBank development for a secure banking product serving millions of users.',
        'Implemented enterprise-grade security with encryption, device binding, and anti-fraud controls.',
        'Delivered regulatory-compliant payment modules backed by automated tests.',
      ],
    ),
    AchievementGroup(
      title: 'Multi-Platform Delivery',
      items: [
        'Shipped apps across 10+ stores including Google Play, App Store, Café Bazaar, and Myket.',
        'Delivered Android, iOS, Web, Windows, macOS, and Linux products.',
      ],
    ),
    AchievementGroup(
      title: 'Education, VPN, and IoT Domains',
      items: [
        'Built Hamkelasi with 100,000+ downloads and role-based educational workflows.',
        'Delivered VPN products with modern protocols and global server coverage.',
        'Implemented real-time fleet tracking, BLE integration, and security alerting.',
      ],
    ),
    AchievementGroup(
      title: 'Cultural Applications',
      items: [
        'Contributed to Tanin Vahy, an award-recognized dramatic spoken translation app.',
      ],
    ),
  ],
  packageGroup: PackageGroup(
    title: 'Key Flutter Packages',
    groups: [
      SkillGroup(
        title: 'Core Development',
        items: [
          'flutter_localizations',
          'shared_preferences',
          'dio',
          'json_annotation',
          'lottie',
          'riverpod',
          'audioplayers',
          'just_audio',
          'audio_service',
          'record',
          'freezed_annotation',
          'flutter_bloc',
          'GetX',
          'hooks_riverpod',
          'rxdart',
          'get_it',
          'http',
          'go_router',
          'firebase',
          'cached_network_image',
          'hive',
          'injectable',
          'animations',
          'url_launcher',
          'flutter_svg',
          'protobuf',
          'path_provider',
          'intl',
          'carousel_slider',
          'fl_chart',
          'grpc',
          'flutter_blue_plus',
          'flutter_local_notifications',
          'json_serializable',
          'sentry_flutter',
          'auto_route',
          'mockito',
          'image_picker',
          'pinput',
          'device_info_plus',
          'qr_flutter',
          'nordic_dfu',
          'sqlite3_flutter_libs',
          'retrofit',
        ],
      ),
      SkillGroup(
        title: 'AI & Modern Development',
        items: [
          'Cursor AI',
          'GitHub Copilot',
          'AI Agents',
          'Vibe Coding',
          'ChatGPT Integration',
        ],
      ),
    ],
  ),
  currentFocus: [
    'Building AI-powered mobile apps such as Home Palette.',
    'Continuing fintech delivery for ToBank digital banking platform.',
    'Implementing stronger security controls for financial applications.',
    'Expanding AI and ML integrations in mobile products.',
    'Extending cross-platform Flutter expertise on web and desktop.',
    'Leveraging AI-assisted development workflows and modern tooling.',
  ],
);
