### Currency Conversion
• Currency Conversion App that allows a user view exchange rates for any given currency

### Features
1. Currency list and rates fetched from https://currencylayer.com/documentation

2. Enter desired amount for selected currency then see a list of exchange rates for the selected currency

NOTE: Can't use https://api.currencylayer.com/convert due to API limitations in free version. So to convert rate with selected currency first get live rate in USD and the convert into selected currency.

### Architecture
MVVM-C architecture for this project and adding closures to perform binding between View and ViewModel (MVVM).

C- Coordinator for managing app navigation flow.

### IDE and Language 
XCode 11.3.1, Swift 5.1.3

### Required third party libraries
[FlexLayout](https://github.com/layoutBox/FlexLayout)

[PinLayout](https://github.com/layoutBox/PinLayout)


### Getting Started
1. Clone the repo

2. In terminal, navigate to root folder of repo

3. Run below command

```sh
pod install
```
Cheers!
