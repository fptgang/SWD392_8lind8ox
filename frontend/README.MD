# frontend

<div align="center" style="margin: 30px;">
    <a href="https://refine.dev">
    <img alt="refine logo" src="https://refine.ams3.cdn.digitaloceanspaces.com/readme/refine-readme-banner.png">
    </a>
</div>
<br/>

This [Refine](https://github.com/refinedev/refine) project was generated with [create refine-app](https://github.com/refinedev/refine/tree/master/packages/create-refine-app).

## Getting Started

A React Framework for building internal tools, admin panels, dashboards & B2B apps with unmatched flexibility ✨

Refine's hooks and components simplifies the development process and eliminates the repetitive tasks by providing industry-standard solutions for crucial aspects of a project, including authentication, access control, routing, networking, state management, and i18n.

## Available Scripts

### Running the development server.

```bash
    npm run dev
```

### Building for production.

```bash
    npm run build
```

### Running the production server.

```bash
    npm run start
```

## Learn More

To learn more about **Refine**, please check out the [Documentation](https://refine.dev/docs)

- **REST Data Provider** [Docs](https://refine.dev/docs/core/providers/data-provider/#overview)
- **Ant Design** [Docs](https://refine.dev/docs/ui-frameworks/antd/tutorial/)
- **Custom Auth Provider** [Docs](https://refine.dev/docs/core/providers/auth-provider/)
- **React Router** [Docs](https://refine.dev/docs/core/providers/router-provider/)

## License

MIT

# Shopping Cart and Checkout Flow

This project implements a modern shopping cart and checkout flow for an e-commerce application using React, Redux Toolkit, and Ant Design.

## Features

### Cart Page
- **Item List**: Displays all items in the cart with image, name, price, and quantity
- **Quantity Controls**: Users can increase or decrease the quantity of each item
- **Disable Items**: Users can disable specific items to exclude them from checkout
- **Delete Items**: Users can remove items from the cart
- **Order Summary**: Shows subtotal, savings, and final total
- **Responsive Design**: Works well on both desktop and mobile

### Checkout Flow
The checkout flow is separated from the cart page and consists of the following steps:

1. **Voucher**: Apply voucher codes for discounts
2. **Shipping Information**: Add or select shipping address
3. **Payment Method**: Choose between different payment options
4. **Order Confirmation**: Review and place order

## Implementation Details

### State Management
- **Redux Toolkit**: Used for centralized state management
- **Cart Slice**: Manages cart items, totals, and operations
- **Checkout Slice**: Handles the multi-step checkout process
- **Order Slice**: Manages order placement and status
- **Wallet Slice**: Handles wallet balance and operations

### Data Flow
1. Users review their cart and can modify items
2. Disabled items are stored and excluded from checkout
3. Clicking "Confirm and Checkout" navigates to the checkout page
4. The checkout page only processes the enabled items
5. After order placement, the cart is cleared

### Benefits of This Implementation

- **Separation of Concerns**: Cart and checkout logic are separated
- **Improved User Experience**: Simpler interface for cart management
- **Flexibility**: Users can choose which items to checkout
- **State Persistence**: Cart state persists across sessions

## Future Enhancements

- Add saved items feature for later purchase
- Implement cross-sell and up-sell recommendations
- Add order tracking functionality
- Enhance mobile experience with swipe gestures
