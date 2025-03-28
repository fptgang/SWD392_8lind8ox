import { AccessControlProvider } from "@refinedev/core";
import { newEnforcer } from "casbin";
import { model, adapter } from "../utils/access-controls";
import { store } from "../store";
import { notification } from "antd";

/**
 * Check out the Access Control Provider documentation for detailed information
 * https://refine.dev/docs/api-reference/core/providers/accessControl-provider
 **/
export const accessControlProvider: AccessControlProvider = {
  can: async ({ resource, action, params }) => {
    const role = store.getState().auth.account?.role;
    const enforcer = await newEnforcer(model, adapter);
    let can = false;

    if (action === "delete" || action === "edit" || action === "show") {
      can = await enforcer.enforce(role, `${resource}/${params?.id}`, action);
    } else if (action === "field") {
      can = await enforcer.enforce(role, `${resource}/${params?.field}`, action);
    } else {
      can = await enforcer.enforce(role, resource, action);
    }

    // Show specific notifications for staff when trying to perform unauthorized actions on accounts
    if (!can && role === "STAFF" && resource === "accounts") {
      let message = "Access Denied";
      let description = "";

      switch (action) {
        case "create":
          description = "Staff members can only view accounts. Creating new accounts is not allowed.";
          break;
        case "edit":
          description = "Staff members can only view accounts. Editing accounts is not allowed.";
          break;
        case "delete":
          description = "Staff members can only view accounts. Deleting accounts is not allowed.";
          break;
        case "field":
          description = "Staff members can only view basic account information.";
          break;
        default:
          description = "Staff members are not authorized to perform this action on accounts.";
      }

      notification.error({
        message,
        description,
        placement: "topRight",
        duration: 5, // Show for 5 seconds
      });
    }

    return { can };
  },
  options: {
    buttons: {
      enableAccessControl: true,
      hideIfUnauthorized: true, // Hide buttons for unauthorized actions
    },
  },
};
