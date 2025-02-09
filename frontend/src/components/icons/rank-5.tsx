import type { SVGProps } from "react";
import { useThemedLayoutContext } from "@refinedev/antd";

export const Rank5Icon = (props: SVGProps<SVGSVGElement>) => {
  const { mode } = useThemedLayoutContext();

  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width={44}
      height={44}
      viewBox="0 0 44 44"
      fill="none"
      {...props}
    >
      <path
        fill="#2F54EB"
        stroke={mode === "dark" ? "#000" : "#fff"}
        strokeWidth={2}
        d="M25.429 1.81a7.667 7.667 0 0 0-6.858 0L5.238 8.475A7.667 7.667 0 0 0 1 15.333v13.334a7.666 7.666 0 0 0 4.238 6.857l13.333 6.667a7.666 7.666 0 0 0 6.858 0l13.333-6.667A7.667 7.667 0 0 0 43 28.667V15.333a7.667 7.667 0 0 0-4.238-6.857L25.429 1.81Z"
      />
      <path
        fill="#1D39C4"
        fillRule="evenodd"
        d="M22.745 7.176a1.667 1.667 0 0 0-1.49 0L7.92 13.843c-.564.282-.921.859-.921 1.49v13.334c0 .63.357 1.208.921 1.49l13.334 6.667c.469.235 1.021.235 1.49 0l13.334-6.667c.564-.282.921-.86.921-1.49V15.333c0-.631-.357-1.208-.921-1.49L22.745 7.176Zm2.236-4.472a6.667 6.667 0 0 0-5.962 0L5.685 9.37A6.667 6.667 0 0 0 2 15.333v13.334a6.667 6.667 0 0 0 3.685 5.962l13.334 6.667a6.667 6.667 0 0 0 5.962 0l13.334-6.666A6.667 6.667 0 0 0 42 28.666V15.333a6.667 6.667 0 0 0-3.685-5.963L24.98 2.704Z"
        clipRule="evenodd"
      />
      <path
        fill="#F0F5FF"
        d="M19.988 29.234c-2.695 0-4.619-1.68-4.824-3.974l-.01-.108h1.729l.01.078c.175 1.397 1.425 2.461 3.115 2.461 1.914 0 3.242-1.328 3.242-3.222v-.02c-.01-1.855-1.348-3.183-3.213-3.183-.957 0-1.777.283-2.402.85a3.497 3.497 0 0 0-.664.83h-1.553l.723-8.038h8.066v1.563h-6.621l-.479 4.736h.04c.664-.947 1.835-1.455 3.203-1.455 2.705 0 4.658 1.963 4.658 4.668v.02c-.01 2.822-2.09 4.794-5.02 4.794Zm7.862-.097a1.1 1.1 0 0 1-1.114-1.114 1.1 1.1 0 0 1 1.114-1.113 1.1 1.1 0 0 1 1.113 1.113 1.1 1.1 0 0 1-1.113 1.114Z"
      />
    </svg>
  );
};
