'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "38d3897f331bdc99f78db7cd0977edb5",
"version.json": "79d0a34012c0226dceb91628762ce27a",
"macos/Runner.xcworkspace/contents.xcworkspacedata": "7053ea3423578187357b9f92d0c67fc6",
"macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "117105d2f2ee718eb485a07574a219b6",
"macos/RunnerTests/RunnerTests.swift": "97d3a20fd20a063c192e886d1822b4a8",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png": "8bf511604bc6ed0a6aeb380c5113fdcf",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png": "c9becc9105f8cabce934d20c7bfb6aac",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png": "dfe2c93d1536ae02f085cc63faa3430e",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png": "04e7b6ef05346c70b663ca1d97de3ad5",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png": "0ad44039155424738917502c69667699",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png": "3ded30823804caaa5ccc944067c54a36",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json": "5bd47c3ef1d1a261037c87fb3ddb9cfd",
"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png": "8e0ae58e362a6636bdfccbc04da2c58c",
"macos/Runner/DebugProfile.entitlements": "6e164fc6ed6acb30c71fe12e29e49642",
"macos/Runner/Base.lproj/MainMenu.xib": "a41bc20792a7e771d7901124cdb8c835",
"macos/Runner/MainFlutterWindow.swift": "4a747b1f256d62a2bbb79bd976891eb5",
"macos/Runner/Configs/AppInfo.xcconfig": "63e5fdfb9a5ac38a7a2381f11f0817fa",
"macos/Runner/Configs/Debug.xcconfig": "0a7555f820f3e4371d88ec1c339d70ef",
"macos/Runner/Configs/Release.xcconfig": "d36330778580798c0d9c5a5b71501a0f",
"macos/Runner/Configs/Warnings.xcconfig": "e19c2368cf97e5f3eaf8de37cff2b341",
"macos/Runner/AppDelegate.swift": "2a7411ae3e7c6715525b94b6f8d2e80b",
"macos/Runner/Info.plist": "b945a5051bb1cca2d906ac0be98b629a",
"macos/Runner/Release.entitlements": "e6fde05dec64f9856d3978a4a5e4bf48",
"macos/Runner.xcodeproj/project.pbxproj": "359f206d9e8b0b3766d668a8ab165abc",
"macos/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "117105d2f2ee718eb485a07574a219b6",
"macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme": "5091f754cd70a18d8506b7e1645fc6eb",
"macos/Flutter/Flutter-Debug.xcconfig": "5699404db81f3897cb3d40ce86ee8a1c",
"macos/Flutter/GeneratedPluginRegistrant.swift": "dd4715d49ff20a83b2d538c1ac0278e7",
"macos/Flutter/Flutter-Release.xcconfig": "d77c83fba1179be363f387359a9ed946",
"macos/Podfile": "23e430d94a635771e7fa6d9f43689023",
"index.html": "5418499205ad01d67a49cd88642af6a0",
"/": "5418499205ad01d67a49cd88642af6a0",
"devtools_options.yaml": "d1ff5187b1b67653e7357395895e8449",
"main.dart.js": "c5d473ec148f56b248c65d94a341c105",
"web/index.html": "db18c687a2d8f1918acfd7338ae3f79c",
"web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"web/icons/proKarieraLogo.jpeg": "627799097cad51538105a56dc036f9b3",
"web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"web/manifest.json": "61ad1ac27b33bcc912da8de44ce861f3",
"pubspec.lock": "92907310f9e46a3dc77bc5717f3ea5ee",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"web_entrypoint.dart": "d41d8cd98f00b204e9800998ecf8427e",
"ios/Runner.xcworkspace/contents.xcworkspacedata": "7053ea3423578187357b9f92d0c67fc6",
"ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "117105d2f2ee718eb485a07574a219b6",
"ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings": "56b1e4b1f6b3b790f471044c301e69ea",
"ios/RunnerTests/RunnerTests.swift": "a225a382d14d7b16b6f602a5c1d49331",
"ios/Runner/Runner-Bridging-Header.h": "e07862ac930ed4d8479185d52c6cc66d",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md": "e175e436acacf76c814d83532d0b662c",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json": "770f4f65e02ca2fc57f46f4f4148d15d",
"ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png": "978c1bee49d7ad5fc1a4d81099b13e18",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png": "643842917530acf4c5159ae851b0baf2",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png": "be8887071dd7ec39cb754d236aa9584f",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png": "2247a840b6ee72b8a069208af170e5b1",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png": "a2f8558fb1d42514111fbbb19fb67314",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png": "c785f8932297af4acd5f5ccb7630f01c",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png": "665cb5e3c5729da6d639d26eff47a503",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png": "1b3b1538136316263c7092951e923e9d",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json": "c3cdf9688b604d14f2e76a8287e16167",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png": "2247a840b6ee72b8a069208af170e5b1",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png": "2b1452c4c1bda6177b4fbbb832df217f",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png": "8245359312aea1b0d2412f79a07b0ca5",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png": "e419d22a37bc40ba185aca1acb6d4ac6",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png": "5b3c0902200ce596e9848f22e1f0fe0e",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png": "36c0d7a7132bdde18898ffdfcfcdc4d2",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png": "5b3c0902200ce596e9848f22e1f0fe0e",
"ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png": "043119ef4faa026ff82bd03f241e5338",
"ios/Runner/Base.lproj/LaunchScreen.storyboard": "89e8363b3b781ee4977c3c9422b88a37",
"ios/Runner/Base.lproj/Main.storyboard": "0e0faca0bc5766e8640496223a31706a",
"ios/Runner/AppDelegate.swift": "303ca46dbd58544be7b816861d70a27c",
"ios/Runner/Info.plist": "91429629ed91fc0b5d880129718ab876",
"ios/Runner.xcodeproj/project.pbxproj": "e2b8f46dafcc6935badb4b30ef471f9d",
"ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata": "a54b6450d65c401d48911394f6a65bd2",
"ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist": "117105d2f2ee718eb485a07574a219b6",
"ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings": "56b1e4b1f6b3b790f471044c301e69ea",
"ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme": "8908ab6700ba930c7dd60ea027f74eaa",
"ios/Flutter/Debug.xcconfig": "46d49915c32600030d79cd085ab92cf9",
"ios/Flutter/Release.xcconfig": "b60ff1c5444e52fc259cf0169dfbe87d",
"ios/Flutter/AppFrameworkInfo.plist": "5eb1ee18836d512da62e476379865f8d",
"ios/Podfile": "c2b6b3dcb8b917d6535f78c4454b55ad",
"README.md": "0427083f55220ac346371b5ef6608d41",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"pubspec.yaml": "d79995665e64c58417a077ab6d461b95",
"linux/CMakeLists.txt": "e325a17209dd378b6011856ea27c8f88",
"linux/runner/main.cc": "0643b8609698e96b3abd63c210361a87",
"linux/runner/CMakeLists.txt": "6d75431dc21756981b53a7494c836311",
"linux/runner/my_application.h": "7bd839b67ebee22174be9f4da4521b6f",
"linux/runner/my_application.cc": "774258eeb1c6781c6fd4d9a6b1ca7f9c",
"linux/flutter/generated_plugin_registrant.cc": "0fb71e1c93dab058d59d4889eefa731e",
"linux/flutter/CMakeLists.txt": "46690fb8ffaf7d227d8bc4713f31140d",
"linux/flutter/generated_plugins.cmake": "95256b36548b2a130a1b70af0f4d6e18",
"linux/flutter/generated_plugin_registrant.h": "d295462c9da9f7fef22dc86c34492318",
"android/app/build.gradle.kts": "c85a8127dc59d13b14fd2e075b951828",
"android/app/src/profile/AndroidManifest.xml": "ac1dad6fec40014c3c6cbbd849a880dc",
"android/app/src/main/res/mipmap-mdpi/ic_launcher.png": "6270344430679711b81476e29878caa7",
"android/app/src/main/res/mipmap-hdpi/ic_launcher.png": "13e9c72ec37fac220397aa819fa1ef2d",
"android/app/src/main/res/drawable/launch_background.xml": "79c59c987bd2e693cd741ec3035ef383",
"android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": "57838d52c318faff743130c3fcfae0c6",
"android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": "afe1b655b9f32da22f9a4301bb8e6ba8",
"android/app/src/main/res/values-night/styles.xml": "feddd27a2f77ef486e2b7a420b1de43d",
"android/app/src/main/res/values/styles.xml": "58b48ec178bde5aad76063577172ad24",
"android/app/src/main/res/drawable-v21/launch_background.xml": "ab00f2bfdce1a5187d1ba31e9e68b921",
"android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": "a0a8db5985280b3679d99a820ae2db79",
"android/app/src/main/AndroidManifest.xml": "f3cb944a67874928abcbea64a0dcc6a9",
"android/app/src/main/kotlin/com/example/pro_kariera/MainActivity.kt": "5f0fe83beb627635bb5e0f0560621b68",
"android/app/src/debug/AndroidManifest.xml": "ac1dad6fec40014c3c6cbbd849a880dc",
"android/gradle/wrapper/gradle-wrapper.properties": "119bb9a3f8765901eb293a15fdec4458",
"android/build.gradle.kts": "699579880a795350891cafc998a3ec79",
"android/settings.gradle.kts": "e61cad7ba20397368b0ef120702043cf",
"android/gradle.properties": "7b10ce389a3f45df326e4f3b665aa00f",
"icons/proKarieraLogo.jpeg": "627799097cad51538105a56dc036f9b3",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "61ad1ac27b33bcc912da8de44ce861f3",
"lib/l10n/dynamic_localizations.dart": "fa5232f7a4a92dbb26e13bec39c04822",
"lib/l10n/app_localizations.dart": "8152870956d483b635da6a6e12c41854",
"lib/l10n/app_uk.arb": "106c26463a47a5991b16b9a3ba06c995",
"lib/l10n/app_de.arb": "d3b752a19ec052addc20437927a66e15",
"lib/l10n/strapi_locales_loader.dart": "3ec8e9b9595ce88e820277e87c5f1dfc",
"lib/l10n/app_en.arb": "bcc7dd739ec26ee0bf2a11ed8369ad78",
"lib/l10n/app_localizations_uk.dart": "3def15e40182bc8936eaa658569454f4",
"lib/l10n/app_localizations_de.dart": "ac915fe4334ad243b3a594a0544df299",
"lib/l10n/app_localizations_en.dart": "f73bf6508902031ce10f84b54070ec56",
"lib/firebase_options.dart": "30dec3fce466b37e9d6a5162bc9dc953",
"lib/admin/app/admin_guard.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/app/admin_router.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/app/admin_app.dart": "65f24cf24117d6fbfba2fe6d284cf714",
"lib/admin/app/widgets_admin/how_i_work_admin.dart": "1e0769972104eba2185c113097e41346",
"lib/admin/app/widgets_admin/faq_admin.dart": "60d98cc55af11cfb605b4c40c649e2b1",
"lib/admin/app/widgets_admin/price_admin.dart": "601fe91b08d9cb1610b2fc04ff21bf39",
"lib/admin/app/widgets_admin/contact_admin.dart": "5a2e35311c3c69175432bff3e9298c49",
"lib/admin/app/widgets_admin/service_admin.dart": "412e636df575b2344712eab31b85d6d9",
"lib/admin/app/widgets_admin/header_admin.dart": "5fb5dd2652d0c66c3b9090eb71f9b97a",
"lib/admin/app/widgets_admin/messages_admin.dart": "37093ab61efc3420f9e4b35f147b6f0d",
"lib/admin/app/widgets_admin/avgs_admin.dart": "a930f71a4432976e3602e5b31d062d27",
"lib/admin/app/widgets_admin/hero_admin.dart": "0ada972d72c3fcca427616984864722e",
"lib/admin/app/widgets_admin/testimonials_admin.dart": "6176eb0bdbedc785c86a6bee2b91cd78",
"lib/admin/app/widgets_admin/about_me_admin.dart": "2cfaff14c499f5046b79e07f6e3ee5ac",
"lib/admin/auth/ui/login_screen.dart": "d2593c29bf9411c8126612e049dbe4c6",
"lib/admin/auth/data/auth_repository.dart": "429f687b2c1b538052773658a71a64ec",
"lib/admin/auth/domain/admin_role_service.dart": "acba16621db2a58df23485c9e4a6e870",
"lib/admin/admin_entry.dart": "cb016514e03d75dfa8ec04270573b0a9",
"lib/admin/features/services/ui/service_form.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/features/services/ui/services_page.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/features/services/data/services_repository.dart": "912886bfcaf58f08ba18bf8af9018915",
"lib/admin/features/services/domain/service_model.dart": "f03ee7ef86e9abd57027a9d6db23f905",
"lib/admin/schared/utils/validators.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/schared/services/firestore_paths.dart": "fe1454cf1dbad68e8c842ec8fa82e9a4",
"lib/admin/schared/services/cloudinary_uploader.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/schared/widgets/image_preview.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/schared/widgets/admin_scaffold.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/admin/schared/widgets/labeled_text_field.dart": "d41d8cd98f00b204e9800998ecf8427e",
"lib/main.dart": "e1207dbe087f6034905ed1178106deb4",
"lib/const/api_strapi.dart": "cca23c069fe3ef42430181138d55bf68",
"lib/const/app_colors.dart": "9c4646a6cd56df0d64d5be89698efa0a",
"lib/const/cloudinary.dart": "c3d05253d9583a8e86078748f084ca98",
"lib/const/theme.dart": "364213bb278881d475873144130cb374",
"lib/firebase/firestore_content_service.dart": "cd7b72a5197d3c961ccc9ddd2818e651",
"lib/api/strapi_client.dart": "cc7e669fcdf04ff6b1f1ee2a57d04872",
"lib/funkcional/language_prompt_localstorage.dart": "4c36795b0b8a2a7ee292d37c8f42107b",
"lib/funkcional/animated_fab_menu.dart": "8dfd8dc90ab468f861841af6aac6ed63",
"lib/services/strings_provider.dart": "0c496c1973de2473125a7e55c41cb1cc",
"lib/services/cloudinary_uploader.dart": "1782a31f1b5109c81a13ab95deb9fca2",
"lib/services/cloudinary_service.dart": "9d322ff1c1459cc2dbc76675baf2e3a2",
"lib/widgets/photo.dart": "2ce764d69b860bee49d206a4eafd60cb",
"lib/widgets/net_photo.dart": "1c2193f82f8be291e53622f95c0a618b",
"lib/widgets/photo_collage.dart": "03e1776337504b7979b3608fdbafe50b",
"lib/widgets/screens/preis_screen.dart": "e48ab1ffb78941c0bfe4751bc71988ea",
"lib/widgets/screens/contact.dart": "7c1ee979dfd9ac944c6b1cb00a97785d",
"lib/widgets/screens/testimonials.dart": "bb2615b175a3704079457df53e37a3ee",
"lib/widgets/screens/about_me.dart": "8c4da7b1909290b7710dcf3f807f5a5a",
"lib/widgets/screens/how_i_work.dart": "9a48dd4a5974d6d6c833d9c0981a98b1",
"lib/widgets/screens/hero_section.dart": "5ae119a6dd744acd16555a08faf186ed",
"lib/widgets/screens/faq_section.dart": "0c1a21d409913a938ba13f377d85bd7a",
"lib/widgets/screens/avgs.dart": "8edb65bf1a671d02fcef24aa7cbc11cd",
"lib/widgets/screens/header.dart": "4dd7b308beb8c906c86612a8d975232b",
"lib/widgets/screens/main_scafold.dart": "2f09050a7bd00280d043077c039be9aa",
"lib/widgets/screens/services.dart": "3a5d465e32af9c9072faeefec12c9618",
"lib/widgets/footer.dart": "d41d8cd98f00b204e9800998ecf8427e",
"firebase.json": "eff6493a02f36f3035a0edccfbfd2c6d",
"analysis_options.yaml": "be4b078e1022d3a457690c54dd76aa16",
"windows/CMakeLists.txt": "70e9bf79f52c768845f2beb7f331082e",
"windows/runner/flutter_window.cpp": "9b92b95a9eecce25e3e9d356688d0cb6",
"windows/runner/utils.h": "c741fb9cddbf3a62f4688b6cca39ddcc",
"windows/runner/utils.cpp": "9b5697b276c8ad67a02ec12ad2c09851",
"windows/runner/runner.exe.manifest": "81f2aed52d431763e83890f3d17da92a",
"windows/runner/CMakeLists.txt": "e99a99b5cc82a168fc557eb23b8d5a96",
"windows/runner/win32_window.h": "5a4cf051798d7e6931ee0405a4523c8f",
"windows/runner/win32_window.cpp": "928e86a2be27eca688669dce6c9177d9",
"windows/runner/resources/app_icon.ico": "6ea04d80ca2a3fa92c7717c3c44ccc19",
"windows/runner/resource.h": "c8f809a4f8d3f2f625e358fd90f72fee",
"windows/runner/Runner.rc": "0fafe2690b884b2c6176a459393e3594",
"windows/runner/main.cpp": "9811b0c327e1457fccd2a1f72abf3813",
"windows/runner/flutter_window.h": "79bea736711adda00c49419a39a4a0b4",
"windows/flutter/generated_plugin_registrant.cc": "b53e4f2f21f2c5b408e4732a59f957e0",
"windows/flutter/CMakeLists.txt": "0c500410e3259a9a053797dc1c28070e",
"windows/flutter/generated_plugins.cmake": "a8919a5063a4208a0fb11e28f1d822e9",
"windows/flutter/generated_plugin_registrant.h": "0ea33875f9f8e118f9c2ded03e2e2835",
"assets/AssetManifest.json": "cf8008461788f2a75bddc1c598b00e5e",
"assets/photo7.jpeg": "af78b3c5b2612b4c643e7265c78d8b32",
"assets/NOTICES": "7b0438078aee2019ecbc0eb7c07e97f3",
"assets/photo4.jpeg": "23deef04bf11c1d8a32efa66edd003b5",
"assets/photo8.jpeg": "48e03b1a8778387f73d950fc2e04b60f",
"assets/logo/proKarieraLogo.png": "867a31499e72895221ba2dd34c233f86",
"assets/FontManifest.json": "3ddd9b2ab1c2ae162d46e3cc7b78ba88",
"assets/AssetManifest.bin.json": "15f6e9ead50b72d4fb3e261ecb9ca7f7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "2c3d37703f6c6e51d16edcae8063534b",
"assets/avatar/foto1.png": "d457d34de49b8c6be434b109575aa5b7",
"assets/avatar/image1.png": "9fa49e3ee0235c16747a4d08e2db29b8",
"assets/avatar/image2.png": "87c564cde543567003f2f5682b9fa222",
"assets/avatar/image3.png": "c23458e9e7ca98a33b3fc472a08f1d3d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "2d38cb8be2e56ac9e91ea2318b4c3b67",
"assets/photo2.jpeg": "7e2c99a20e6ee3ec178265571eb2924d",
"assets/fonts/MaterialIcons-Regular.otf": "fda04dc990245729d2bcd7d501892d03",
"assets/fotoHeroDes.jpeg": "dcbf49d5cbe5fcad770d66c5a478a1f5",
"assets/assets/photo7.jpeg": "af78b3c5b2612b4c643e7265c78d8b32",
"assets/assets/photo4.jpeg": "23deef04bf11c1d8a32efa66edd003b5",
"assets/assets/photo8.jpeg": "48e03b1a8778387f73d950fc2e04b60f",
"assets/assets/logo/proKarieraLogo.png": "867a31499e72895221ba2dd34c233f86",
"assets/assets/avatar/foto1.png": "d457d34de49b8c6be434b109575aa5b7",
"assets/assets/avatar/image1.png": "9fa49e3ee0235c16747a4d08e2db29b8",
"assets/assets/avatar/image2.png": "87c564cde543567003f2f5682b9fa222",
"assets/assets/avatar/image3.png": "c23458e9e7ca98a33b3fc472a08f1d3d",
"assets/assets/photo2.jpeg": "7e2c99a20e6ee3ec178265571eb2924d",
"assets/assets/fotoHeroDes.jpeg": "dcbf49d5cbe5fcad770d66c5a478a1f5",
"assets/assets/photo3.jpeg": "4537b84d590c58cbd72871fff5da0458",
"assets/assets/1.png": "1909f4da7ae455ee6b3a526c1d0572c5",
"assets/photo3.jpeg": "4537b84d590c58cbd72871fff5da0458",
"assets/1.png": "1909f4da7ae455ee6b3a526c1d0572c5",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
