# PayGate - Flutter Payment Gateway Demo

A Flutter application demonstrating integration with multiple payment gateways (SSLCommerz and Stripe) in sandbox/test mode.

## Overview

This project demonstrates how to implement payment processing in Flutter applications using:

- **SSLCommerz** - Popular payment gateway in Bangladesh
- **Stripe** - International payment processor

> ⚠️ **Note:** This project uses test/sandbox payment environments only. No real transactions are processed.

## Features

- Simple user interface to enter payment amount
- Integration with SSLCommerz payment gateway
- Integration with Stripe payment gateway
- Environment variable configuration for API keys
- Transaction status handling and error management

## Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK (^3.7.0)
- A Stripe test account
- An SSLCommerz sandbox account

## Setup Instructions

1. Clone the repository

   ```
   git clone https://github.com/MotiurRahmanSany/PayGate-app.git
   cd paygate
   ```

2. Create a `.env` file in the project root with the following variables:

   ```
   SSL_STORE_ID=your_sslcommerz_store_id
   SSL_STORE_PASSWORD=your_sslcommerz_store_password
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   STRIPE_SECRET_KEY=your_stripe_secret_key
   ```

3. Install dependencies

   ```
   flutter pub get
   ```

4. Run the application
   ```
   flutter run
   ```

## Testing Payments

### SSLCommerz Test Cards

- Use the test cards provided in the [SSLCommerz developer documentation](https://developer.sslcommerz.com/doc/v4/#test-credentials)

### Stripe Test Cards

- Card number: `4242 4242 4242 4242`
- Expiry: Any future date
- CVC: Any 3 digits
- More test cards available in the [Stripe testing documentation](https://stripe.com/docs/testing)

## Dependencies

- `flutter_stripe: ^11.5.0` - For Stripe payment integration
- `flutter_sslcommerz: ^2.4.4` - For SSLCommerz payment integration
- `flutter_dotenv: ^5.2.1` - For loading environment variables
- `dio: ^5.8.0+1` - For HTTP requests
- `uuid: ^4.5.1` - For generating unique transaction IDs

## Limitations

- This project is for demonstration purposes only
- All payments are processed in test mode
- Some features may not work exactly as they would in production environments
- Real money is not charged in any transaction

## Additional Resources

- [Stripe Documentation](https://stripe.com/docs)
- [SSLCommerz Documentation](https://developer.sslcommerz.com/doc/)
- [Flutter Documentation](https://docs.flutter.dev/)

## License

This project is available for educational purposes. Feel free to use it as a reference for your own implementation.
