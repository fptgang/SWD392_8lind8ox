# Payment Processing

This directory contains components for handling payment processing, particularly with VNPay integration.

## VNPay Integration Flow

1. **Initiate Payment**:
   - User selects an amount to deposit in the WalletSettings component
   - A transaction is created via API with status PENDING
   - Backend returns a payment URL for VNPay
   - User is redirected to VNPay's payment page

2. **Payment Completion**:
   - After completing payment on VNPay, user is redirected back to our application
   - The redirect URL includes parameters like:
     - `vnp_ResponseCode`: Payment status code (00 = success, 24 = pending, etc.)
     - `vnp_TxnRef`: Transaction ID in our system
     - `vnp_Amount`: Transaction amount (note: multiplied by 100)
     - `vnp_TransactionStatus`: VNPay's transaction status
     - `vnp_SecureHash`: Security hash for verification

3. **Handling the Return**:
   - The `VNPayReturnHandler` component processes these parameters
   - Displays appropriate feedback to the user based on the response code
   - Redirects back to the wallet page after a short delay
   - The actual transaction status update is handled automatically by VNPay's server-to-server callback to our backend

## Response Codes

Common VNPay response codes:
- `00`: Success
- `07`: Suspected fraud
- `09`: Customer cancelled
- `24`: Pending/Processing
- Other codes: Various failure reasons

## Implementation Notes

- The backend's VNPay integration is configured to return to `/payment/vnpay/return`
- The frontend component only handles user interface concerns (displaying status, navigation)
- Transaction status updates are processed by the backend via VNPay's server-to-server callbacks
- No API calls are needed from the frontend component to update transaction status 