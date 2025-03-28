import React from "react";
import { Link } from "react-router";
import { motion } from "framer-motion";

export const Logo: React.FC = () => {
  return (
    <Link to="/" className="text-xl font-bold">
      <motion.span
        animate={{
          color: ["#ef4444", "#8b5cf6", "#ef4444"],
        }}
        transition={{
          duration: 10,
          repeat: Infinity,
          ease: "linear"
        }}
      >
        8lind8ox
      </motion.span>
    </Link>
  );
};
