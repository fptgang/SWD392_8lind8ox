import React from "react";
import { Link } from "react-router";

export const Logo: React.FC = () => {
  return (
    <Link to="/" className="text-xl font-bold">
      Store Logo
    </Link>
  );
};
