import { newModel, StringAdapter } from "casbin";

export const model = newModel(`
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act, eft

[role_definition]
g = _, _

[policy_effect]
e = some(where (p.eft == allow)) && !some(where (p.eft == deny))

[matchers]
m = g(r.sub, p.sub) && keyMatch(r.obj, p.obj) && regexMatch(r.act, p.act)
`);

export const adapter = new StringAdapter(`
# Admin has full access
p, ADMIN, accounts, (list)|(create)
p, ADMIN, accounts/*, (edit)|(show)|(delete)
p, ADMIN, accounts/*, field

# Staff can only view accounts
p, STAFF, accounts, list
p, STAFF, accounts/*, show
p, STAFF, accounts/*, (create)|(edit)|(delete), deny

# Common resources that both ADMIN and STAFF can access
p, ADMIN, dashboard, list
p, STAFF, dashboard, list

# Catalog Management - Admin has full access
p, ADMIN, blind-boxes, (list)|(create)
p, ADMIN, blind-boxes/*, (edit)|(show)|(delete)
p, ADMIN, blind-boxes/*, field

# Catalog Management - Staff can only see visible items
p, STAFF, blind-boxes, list
p, STAFF, blind-boxes/*, show
p, STAFF, blind-boxes/*, (create)|(edit)|(delete), deny
p, STAFF, blind-boxes/*, field

p, ADMIN, brands, (list)|(create)
p, ADMIN, brands/*, (edit)|(show)|(delete)
p, ADMIN, brands/*, field

p, STAFF, brands, list
p, STAFF, brands/*, show
p, STAFF, brands/*, (create)|(edit)|(delete), deny
p, STAFF, brands/*, field

p, ADMIN, orders, list
p, ADMIN, orders/*, (show)|(edit)|(delete)
p, ADMIN, orders/*, field

p, STAFF, orders, list
p, STAFF, orders/*, show
p, STAFF, orders/*, (edit)|(delete), deny
p, STAFF, orders/*, field

p, ADMIN, promotional-campaigns, (list)|(create)
p, ADMIN, promotional-campaigns/*, (edit)|(show)|(delete)
p, ADMIN, promotional-campaigns/*, field

p, STAFF, promotional-campaigns, list
p, STAFF, promotional-campaigns/*, show
p, STAFF, promotional-campaigns/*, (create)|(edit)|(delete), deny
p, STAFF, promotional-campaigns/*, field

p, ADMIN, vouchers, (list)|(create)
p, ADMIN, vouchers/*, (edit)|(show)|(delete)
p, ADMIN, vouchers/*, field

p, STAFF, vouchers, list
p, STAFF, vouchers/*, show
p, STAFF, vouchers/*, (create)|(edit)|(delete), deny
p, STAFF, vouchers/*, field
`);
