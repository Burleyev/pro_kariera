class ApiStrapi {
  static const _urlStrapi =
      // 'https://delicate-bell-ab0fef9fe9.strapiapp.com/api';
      'http://localhost:1337/api';

  static const _apiToken =
      // "c75326235be24a86248df095225a3c5016b01dbb1f7c5e0ac1eece8e2154dc39694b57bc7c34562e1ad663c728df3befff9b1b432c6b084cd72282f60f51a3bfd3bbd223790b411a1e5891176f6857382ebcb4f3b08384c7538630341928d234d1fdd3e82d1b101703a66eeada3a4ac2a2cd586f8ad2703e9dd781d029a97732";
      '4b953bf814cf4b4968b9f6687a6722a7ef54d0ccfcb9c0646920624d444a8474c4f4b7065ea43ee14d09d2c5e0b7245c5b6ec31394d91ca864f20ba79d8cc35dcb244c9e5e1ac169a5c365a576f84cea07d7e3bf5724e1a752f9f5e0390c25b2ad122583eca7908e25213e715803a4f6bd04d5666d8bfe191e71e3d3a0cd15dd';
  static String get url => _urlStrapi;
  static String get token => _apiToken;
}
