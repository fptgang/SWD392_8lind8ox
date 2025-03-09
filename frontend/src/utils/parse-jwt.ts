import { AuthResponseDto } from "../../generated";

// Interface for JWT payload with common fields
interface JwtPayload {
  sub?: string;
  email?: string;
  exp?: number;
  iat?: number;
  // Add other JWT standard fields as needed
  [key: string]: any; // Allow for additional custom fields
}

export function parseJwt(token: string): JwtPayload | null {
  // Early return if token is undefined, null, or empty
  if (!token) {
    return null;
  }

  try {
    const tokenParts = token.split(".");
    // Check if the token has the expected JWT format (at least 3 parts)
    if (tokenParts.length < 2) {
      return null;
    }

    const base64Url = tokenParts[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    const jsonPayload = decodeURIComponent(
      window
        .atob(base64)
        .split("")
        .map((c) => `%${`00${c.charCodeAt(0).toString(16)}`.slice(-2)}`)
        .join("")
    );

    return JSON.parse(jsonPayload);
  } catch (error) {
    console.error("Error parsing JWT token:", error);
    return null;
  }
}
