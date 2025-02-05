import React from "react";
import NavBar from "./nav-bar";

import BrandShowcase from "./components/brand-showcase";
import TrendingProducts from "./components/trending-products";
import ProductSeries from "./components/product-series";

export default function LandingPage() {
  return (
    <div style={{ minHeight: '100vh', background: 'var(--ant-color-bg-layout)' }}>
      <div style={{ maxWidth: 1200, margin: '0 auto', padding: '0 24px' }}>
        <TrendingProducts />
        <ProductSeries />
        <BrandShowcase />
      </div>
    </div>
  );
}
