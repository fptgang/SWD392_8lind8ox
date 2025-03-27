export const BROKER_URL = import.meta.env.VITE_BROKER_URL || "ws://localhost:8080/8lind8ox-ws";
export const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8080/api/v1";
export const ROLE_OPTIONS = [
  { label: "Admin", value: "ADMIN" },
  { label: "Client", value: "CLIENT" },
  { label: "Staff", value: "STAFF" },
  { label: "Freelance", value: "FREELANCER" },
];
export const ROLE_COLOR_MAP = {
  ADMIN: "purple", // Purple represents authority and power
  STAFF: "cyan", // Cyan for support/operational roles
  CUSTOMER: "orange", // Orange for dynamic/independent workers
};
