# Changelog

## [1.13.0](https://github.com/SethCohen/ASL/compare/v1.12.0...v1.13.0) (2023-03-30)


### Features

* updated Flashcard responsiveness ([9dea5a8](https://github.com/SethCohen/ASL/commit/9dea5a84be2808197e83236bdd0a53b40bc52319))


### Miscellaneous

* dependency upgrades and overrides ([9f80d6c](https://github.com/SethCohen/ASL/commit/9f80d6cece3ac45ed4fb9cf750d586ff093693fe))

## [1.12.0](https://github.com/SethCohen/ASL/compare/v1.11.0...v1.12.0) (2023-03-30)


### Features

* added `firebase_ui_firestore` dependency ([a48eaf0](https://github.com/SethCohen/ASL/commit/a48eaf09e358070ae7c822d299e6e8698970aebc))
* added basic dictionary system ([3351465](https://github.com/SethCohen/ASL/commit/3351465e55f968f9d4673a7b3a560be3e9a05b76))
* **comfy:** added filledbutton theme ([c63194e](https://github.com/SethCohen/ASL/commit/c63194eea1382dd03e66bbf36bb1d6789bd4c51c))
* **dictionary:** updated dictionary system to use `firebase_ui_firestore` ([323fb0d](https://github.com/SethCohen/ASL/commit/323fb0d7ab3da5b0c6cd5f0b6a718dc3b741eff4))
* **flashcard:** updated widget usability across different pages ([323fb0d](https://github.com/SethCohen/ASL/commit/323fb0d7ab3da5b0c6cd5f0b6a718dc3b741eff4))
* **HomePage:** added custom tab ([28a7fd1](https://github.com/SethCohen/ASL/commit/28a7fd1a3c99e308e498fb7078a5291d8f3b5ea5))
* restructured project to feature-first design ([c20df26](https://github.com/SethCohen/ASL/commit/c20df262bda54e75cd58610af4aeee3b63df9f35))
* **review:** added review all cards system ([82bee53](https://github.com/SethCohen/ASL/commit/82bee53da52f91527860c9a215ef6e1709e8a52d))
* updated lesson pagination to use new `firebase_ui_firestore` dependency ([8a6737b](https://github.com/SethCohen/ASL/commit/8a6737bf00e94ad68f9b8159ea3d87994200b081))


### Miscellaneous

* added additional TODOs ([3351465](https://github.com/SethCohen/ASL/commit/3351465e55f968f9d4673a7b3a560be3e9a05b76))
* updated dependencies ([a48eaf0](https://github.com/SethCohen/ASL/commit/a48eaf09e358070ae7c822d299e6e8698970aebc))


### Styles

* **LandingPage:** cleaned and restyled ([c63194e](https://github.com/SethCohen/ASL/commit/c63194eea1382dd03e66bbf36bb1d6789bd4c51c))


### Code Refactoring

* **comfy:** added palette constants ([c63194e](https://github.com/SethCohen/ASL/commit/c63194eea1382dd03e66bbf36bb1d6789bd4c51c))
* renamed lessons and reviews pages ([2ffc51a](https://github.com/SethCohen/ASL/commit/2ffc51ab6b24a21c4959b74a7cbff8a184d26f76))

## [1.11.0](https://github.com/SethCohen/ASL/compare/v1.10.0...v1.11.0) (2023-03-26)


### Features

* added custom colour palette theme extension ([5bd4e7e](https://github.com/SethCohen/ASL/commit/5bd4e7e472fb302659c7d376b2cef1dc9eae6510))
* added custom icon button ([5bd4e7e](https://github.com/SethCohen/ASL/commit/5bd4e7e472fb302659c7d376b2cef1dc9eae6510))
* added popup instructions ([5bd4e7e](https://github.com/SethCohen/ASL/commit/5bd4e7e472fb302659c7d376b2cef1dc9eae6510))
* added review page refresh on finished deck review ([d16b29b](https://github.com/SethCohen/ASL/commit/d16b29b5496285643dfd15cb666dad44e8329eae))
* **lesson|review:** added spacing between progress bar and flashcards ([f84d3df](https://github.com/SethCohen/ASL/commit/f84d3dfa3e308415a9980e21c924740a312a3fb9))


### Bug Fixes

* **flashcard:** fixed empty instructions still showing up ([c25211b](https://github.com/SethCohen/ASL/commit/c25211bdc0548b311124672360f5b6311114100b))


### Styles

* added responsive flashcard width ([fe06a77](https://github.com/SethCohen/ASL/commit/fe06a77b8fb006085d6e0bbfa3fdc2113c41ddc4))


### Miscellaneous

* added additional TODOs ([f960452](https://github.com/SethCohen/ASL/commit/f960452e781f529c1d2fe5ff0af6386419c0a781))

## [1.10.0](https://github.com/SethCohen/ASL/compare/v1.9.0...v1.10.0) (2023-03-24)


### Features

* added dynamic routing ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))
* added pagination using Provider ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))
* restructured and refactored entire project ([#19](https://github.com/SethCohen/ASL/issues/19)) ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))


### Code Refactoring

* lesson.dart -&gt; lesson_page.dart ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))
* manage_page -&gt; profile_page.dart ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))
* review.dart -&gt; review_page.dart ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))
* updated project to use relative imports ([b87b4a3](https://github.com/SethCohen/ASL/commit/b87b4a3cc6631e3b7afcd632fbf007d5e25553cb))

## [1.9.0](https://github.com/SethCohen/ASL/compare/v1.8.1...v1.9.0) (2023-03-21)


### Features

* added flashcard media control visuals ([eeecd5f](https://github.com/SethCohen/ASL/commit/eeecd5f06c5fb80f12fd425cda4dc2ff37dc6150))
* added instructions display ([5e910f5](https://github.com/SethCohen/ASL/commit/5e910f532ceaec1b38c33d77f6b76e1917cd115e))
* pagination ([8c68b71](https://github.com/SethCohen/ASL/commit/8c68b712e50358e43984de8d07351e5acb582037))


### Miscellaneous

* additional style changes ([7b44704](https://github.com/SethCohen/ASL/commit/7b44704853ee00afca5d5d494d509ac00de57ea9))


### Styles

* instruction box style changes ([ce48987](https://github.com/SethCohen/ASL/commit/ce4898768b521690e072d7d0f6fc2b7d87a01d96))

## [1.8.1](https://github.com/SethCohen/ASL/compare/v1.8.0...v1.8.1) (2023-03-14)


### Styles

* matched flashcard style to new theme ([b1396d1](https://github.com/SethCohen/ASL/commit/b1396d13738c2a0933d290c4694a4849f08b81d9))
* more theme changes ([93d6a82](https://github.com/SethCohen/ASL/commit/93d6a8296ac3f3d65941f46db906e2db2a2e2640))
* moved progress indicator to bottom ([ec34ee9](https://github.com/SethCohen/ASL/commit/ec34ee922bfaf2ca9ecff7b1d0f2b8b2156a7de3))
* theme changes ([afa1073](https://github.com/SethCohen/ASL/commit/afa10739a98d76c228e508cba5da502204ecfa8e))

## [1.8.0](https://github.com/SethCohen/ASL/compare/v1.7.1...v1.8.0) (2023-03-13)


### Features

* added json theme support ([5c8c92b](https://github.com/SethCohen/ASL/commit/5c8c92b7845762024bc5cdb8baf6361f3fcfec7d))
* added review all cards implementation ([b145354](https://github.com/SethCohen/ASL/commit/b145354b1688047785f8b8b40379c4e6770d3d79))
* **lesson:** added numerical progression indicator ([2c34d26](https://github.com/SethCohen/ASL/commit/2c34d26eccf292b3ffc1949ab68f61393e8a27e7))


### Miscellaneous

* added new dependencies ([cd53ba8](https://github.com/SethCohen/ASL/commit/cd53ba852e040e9bec2fcd576c363d45a7b4ba33))


### Code Refactoring

* replaced profile dropdown with profile page ([95b2f74](https://github.com/SethCohen/ASL/commit/95b2f74a374f0bd13ce4727d7d0014c8ddf440da))


### Styles

* **lesson:** changed lesson progress icon ([8cd3f3c](https://github.com/SethCohen/ASL/commit/8cd3f3c08aa5f552308404486e111922155d7b43))

## [1.7.1](https://github.com/SethCohen/ASL/compare/v1.7.0...v1.7.1) (2023-03-02)


### Miscellaneous

* added more TODOs ([65b9a53](https://github.com/SethCohen/ASL/commit/65b9a53bf86dcd7b79bc67a7519862f8afdcfe89))

## [1.7.0](https://github.com/SethCohen/ASL/compare/v1.6.0...v1.7.0) (2023-02-24)


### Features

* added basic review system ([1e0fa8f](https://github.com/SethCohen/ASL/commit/1e0fa8f831d468124ba4b581fd97c8abde4c9071))
* added card number indicator ([16e5c93](https://github.com/SethCohen/ASL/commit/16e5c939504f96ceb6881786ccc3873b2d578d12))
* added diff  between lesson and review cards ([27a966d](https://github.com/SethCohen/ASL/commit/27a966d18aa7a132d6a62f4a5b900bfd5976e946))
* added lesson progress indicator ([bff2d25](https://github.com/SethCohen/ASL/commit/bff2d25ba3beeac59ba18b4392b1787a6d200527))
* added visual diff for (un)completed lesson ([e872ffc](https://github.com/SethCohen/ASL/commit/e872ffcb040bd25c24adfa4548e2b51beb5b5164))
* added visual progress bar ([aa0bf7f](https://github.com/SethCohen/ASL/commit/aa0bf7f74929439d13d4529b5c2fbefda25635f4))


### Bug Fixes

* fixed flashcard blur ([b2fefc3](https://github.com/SethCohen/ASL/commit/b2fefc3c7e1e8b47c93d4fbb5ed119090309ba66))


### Code Refactoring

* moved handleCardProgress ([8638599](https://github.com/SethCohen/ASL/commit/8638599c45d0258355e3b370a033afd16952f730))
* moved user streak handling to own method ([a08129b](https://github.com/SethCohen/ASL/commit/a08129b4fc7e75d9dacb284278bc308d8cf97a58))
* refactored lesson code readability ([29b19ea](https://github.com/SethCohen/ASL/commit/29b19ea046371e2759edb91ae8a5aad81b65acd3))


### Styles

* changed flashcard width ([7eb90be](https://github.com/SethCohen/ASL/commit/7eb90be8d8eac9bc61fbefc2458aedf896973937))
* changed lesson button width ([a020ffe](https://github.com/SethCohen/ASL/commit/a020ffe169006d1f3dd21f10eecc1a4ac2aa9126))
* changed lesson icon and icon colour ([4956166](https://github.com/SethCohen/ASL/commit/49561669f2996f72e22d4af1f5b7c4d9d4cc5fd8))
* changed review button width ([20f5725](https://github.com/SethCohen/ASL/commit/20f5725797ee418d29c78c4d0db094ed34f1b445))


### Miscellaneous

* added additional TODOs ([c0261ea](https://github.com/SethCohen/ASL/commit/c0261eaed969316157b57087fa9bba955d2fbef0))
* updated Docker container ([cec81b2](https://github.com/SethCohen/ASL/commit/cec81b2a4d86987ff9d3adf09bf9d99b84f27f0b))

## [1.6.0](https://github.com/SethCohen/ASL/compare/v1.5.0...v1.6.0) (2023-02-13)


### Features

* added full implementation of spaced repetition ([3c5959d](https://github.com/SethCohen/ASL/commit/3c5959de1c4fcea42f8f8a94d71d65bbf742f74e))
* added streak and last login tracking ([b4c9d86](https://github.com/SethCohen/ASL/commit/b4c9d867db552f36d9f95aef99fdce7e1379a95d))


### Miscellaneous

* added docker ([817dcc9](https://github.com/SethCohen/ASL/commit/817dcc9dd785ac7e9ca8f86d99f8d6dda52f8599))
* updated dependencies ([41d21ca](https://github.com/SethCohen/ASL/commit/41d21cae26790b2036ac2aa64c4f84b79e062eb4))
* updated gitignore ([c79d385](https://github.com/SethCohen/ASL/commit/c79d3855a6d677b11a6fc59fd22266a405cafb98))

## [1.5.0](https://github.com/SethCohen/ASL/compare/v1.4.0...v1.5.0) (2023-01-18)


### Features

* restyled landing page ([2185548](https://github.com/SethCohen/ASL/commit/2185548af942697dae0bba0b1bb091888a3581b7))
* restyled lesson and flashcard components ([7da4afb](https://github.com/SethCohen/ASL/commit/7da4afbc2ea2da33ec6ad699f017325b9d228e27))
* restyled lessons page ([a059f82](https://github.com/SethCohen/ASL/commit/a059f8299580857f53ff1c0e55fb40c2bb17c200))
* restyled page placeholder widgets ([592fe31](https://github.com/SethCohen/ASL/commit/592fe31cb5bae72f2db5f6a44dc738d74f39299a))

## [1.4.0](https://github.com/SethCohen/ASL/compare/v1.3.0...v1.4.0) (2022-12-21)


### Features

* added basic flashcard system ([9c30687](https://github.com/SethCohen/ASL/commit/9c30687bf9e8cbe69e49ed68149c6fd6b14c48dc))
* added flashcard instructions display ([43faac7](https://github.com/SethCohen/ASL/commit/43faac7da02d3e15c19c937891aae36de8a98b07))
* added spaced repetition algorithm dependency ([fcc4c64](https://github.com/SethCohen/ASL/commit/fcc4c643229b2190607a20249c3d2eee495fd73f))


### Styles

* layout design changes ([9f22710](https://github.com/SethCohen/ASL/commit/9f2271014d0eeb543856a20187373293a2ca75c5))

## [1.3.0](https://github.com/SethCohen/ASL/compare/v1.2.1...v1.3.0) (2022-12-20)


### Features

* added additional pages ([1a7e0d3](https://github.com/SethCohen/ASL/commit/1a7e0d379d9bcc3e1c219dc467ae67a172a30cb3))
* added lesson card system ([53a605b](https://github.com/SethCohen/ASL/commit/53a605bfff62831fb93607e0a5864a2661076e26))


### Miscellaneous

* updated README.md ([d87c182](https://github.com/SethCohen/ASL/commit/d87c182cb09d577261986cac97599d008d6615a8))

## [1.2.1](https://github.com/SethCohen/ASL/compare/v1.2.0...v1.2.1) (2022-11-17)


### Miscellaneous

* updated README.md ([4f1cda1](https://github.com/SethCohen/ASL/commit/4f1cda17b3c78d2e3d0d9ae32ddbe9db16e773fd))

## [1.2.0](https://github.com/SethCohen/ASL/compare/v1.1.0...v1.2.0) (2022-11-17)


### Features

* added fully functional login/logout system using Google authentication and Firebase ([25474cb](https://github.com/SethCohen/ASL/commit/25474cbae7de97c1a1ee3e658a58785580420e68)), closes [#3](https://github.com/SethCohen/ASL/issues/3)
* added profile account manager page and functionality ([081b457](https://github.com/SethCohen/ASL/commit/081b45775133520d92daa088b34b625329a7a0d3))
* changed app theme ([8bd0bf7](https://github.com/SethCohen/ASL/commit/8bd0bf7c8e9689909675955bc0b311e5d760b3cd))


### Code Refactoring

* minor deprecation and linting fixes ([59c52d7](https://github.com/SethCohen/ASL/commit/59c52d7e4e25a58c64cffb9d816f5735304b12ce))

## [1.1.0](https://github.com/SethCohen/ASL/compare/v1.0.0...v1.1.0) (2022-10-27)


### Features

* **?:** partial implementation of google sign in authentication ([6436231](https://github.com/SethCohen/ASL/commit/6436231d3de8312a95616bfafd6fa32e74872e50))

## 1.0.0 (2022-09-29)


### Features

* added basic homepage ([8bc0cd7](https://github.com/SethCohen/ASL/commit/8bc0cd75344948c0ac6aa8aaa9e014891725d8d3))
* initial project setup ([a1ebfea](https://github.com/SethCohen/ASL/commit/a1ebfea9b703835f08777ecbb369662ab40c0b6e))


### Miscellaneous

* added google release-please ([f48337e](https://github.com/SethCohen/ASL/commit/f48337ec8bac3feae32ef159cb19aa1324e872af))
* restructured project ([429a353](https://github.com/SethCohen/ASL/commit/429a3530a873a2e4771a4ec1255bf1f45cb5b69f))
