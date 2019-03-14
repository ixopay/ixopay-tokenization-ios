# ixopay-tokenization-ios

This SDK enables you to tokenize card data natively from your iOS application to our PCI-certified servers.

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

IxopayApi *ixopay = [[IxopayApi alloc] initWithPublicIntegrationKey:@"PUBLIC_INTEGRATION_KEY];
[ixopay tokenizeCardData:cardData onComplete:^(Token *token) {
	//process token, and continue with transaction sending
        NSLog(@"Success, token is: %@ ; fingerprint: %@", token.token, token.fingerprint);

    } onError:^(NSArray<Error *> *errors) {
	//Errors occurred, handle accordingly
        NSLog(@"Error occurred:");
        [errors enumerateObjectsUsingBlock:^(Error * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj.message);
        }];

    }
];
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