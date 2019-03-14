# ixopay-tokenization-ios

[![Version](https://img.shields.io/cocoapods/v/IxopayTokenizationSdk.svg?style=flat)](https://cocoapods.org/pods/IxopayTokenizationSdk)
[![License](https://img.shields.io/cocoapods/l/IxopayTokenizationSdk.svg?style=flat)](https://cocoapods.org/pods/IxopayTokenizationSdk)
[![Platform](https://img.shields.io/cocoapods/p/IxopayTokenizationSdk.svg?style=flat)](https://cocoapods.org/pods/IxopayTokenizationSdk)

This SDK enables you to tokenize card data natively from your iOS application to our PCI-certified servers.

## Installation

IxopayTokenizationSdk is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IxopayTokenizationSdk'
```


## Usage

Build a `CardData` object with card number ("pan"), CVV/CVC code ("cvv"), card holder, exipiration month and year.
Instantiate the `IxopayApi` class with your public integration key (and optionally hostname, if different than production environment) and call
`tokenizeCardData` on that.

```objective-c

#import "IxopayTokenizationSdk/CardData.h"
#import "IxopayTokenizationSdk/IxopayApi.h"

...


CardData *cardData = [[CardData alloc] init];
cardData.pan = @"CARD NUMBER";
cardData.cvv = @"CVV";
cardData.cardHolder = @"CARD HOLDER";
cardData.expirationMonth = [NSNumber numberWithInt:4];
cardData.expirationYear = [NSNumber numberWithInt:2025];

IxopayApi *ixopay = [[IxopayApi alloc] initWithPublicIntegrationKey:@"PUBLIC_INTEGRATION_KEY"];
[ixopay tokenizeCardData:cardData onComplete:^(Token *token) {
        NSLog(@"Success, token is: %@ ; fingerprint: %@", token.token, token.fingerprint);

    } onError:^(NSError *error) {
        NSLog(@"Error occurred: Code %d", error.code);
        [error.userInfo enumerateKeysAndObjectsUsingBlock:^(NSErrorUserInfoKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"Field %@, Message: %@", key, obj);
        }];
    }];

```


## Development

### Requirements
- iOS 9.0 or higher
- Xcode 8.0 or higher (to build source)

### Dependencies
- none

## License

[LICENSE](LICENSE)

## Changelog

[CHANGELOG.md](CHANGELOG.md)