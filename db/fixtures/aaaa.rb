Organization.seed :id,
  id: 1, name: "TimeOverflow"

User.seed :email,
  email: "admin@example.com",
  username: "admin",
  password: "password",
  organization_id: 1,
  admin: true,
  superadmin: true
